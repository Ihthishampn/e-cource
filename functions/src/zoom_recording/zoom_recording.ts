import axios from "axios";
import * as crypto from "crypto";
import express from "express";
import * as admin from "firebase-admin";
import { FieldValue, getFirestore } from "firebase-admin/firestore";
import { https } from "firebase-functions/v2";
import { onSchedule } from "firebase-functions/v2/scheduler";

// Helper function to safely encode UUID for use as Firestore document ID
function encodeUUIDForFirestore(uuid: string): string {
    // Replace characters that are not allowed in Firestore document IDs
    return uuid
        .replace(/[\/\+=\[\]*\.#\(\)<>{}|?&$@:;"'`~!%^\\\s]/g, "_")
        .replace(/__+/g, "_") // Replace multiple consecutive underscores with single underscore
        .replace(/^_|_$/g, ""); // Remove leading and trailing underscores
}

export const zoomApp = express();

// Helper to log to Firestore for easy debugging
async function logToFirestore(data: any) {
    try {
        await getFirestore("ihthishamecource").collection("webhookLogs").add({
            ...data,
            timestamp: admin.firestore.FieldValue.serverTimestamp(),
        });
    } catch (e) {
        console.error("Firestore logging failed", e);
    }
}

function normalizeMeetingValue(value: unknown): string | null {
    if (typeof value !== "string" && typeof value !== "number") {
        return null;
    }

    const normalized = String(value).trim();
    return normalized ? normalized : null;
}

type LiveDocMatch = {
    doc: admin.firestore.QueryDocumentSnapshot | null;
    ambiguous: boolean;
    candidateIds: string[];
    rationale?: string;
};

type FindLiveDocResult = {
    doc: admin.firestore.QueryDocumentSnapshot | null;
    ambiguousMatches: { matchedBy: string; candidateIds: string[] }[];
    rationale?: string;
};

type RankedLiveDoc = {
    doc: admin.firestore.QueryDocumentSnapshot;
    status: string;
    statusRank: number;
    anchorTimestamp: number | null;
    timeDiff: number | null;
};

const CLEAR_WINNER_WINDOW_MS = 15 * 60 * 1000;
const CLEAR_WINNER_GAP_MS = 15 * 60 * 1000;

function normalizeStatusValue(value: unknown): string {
    return typeof value === "string" ? value.trim().toLowerCase() : "";
}

function toTimestamp(value: unknown): number | null {
    if (value === null || value === undefined) {
        return null;
    }

    if (typeof value === "number") {
        return Number.isFinite(value) ? value : null;
    }

    if (value instanceof Date) {
        return value.getTime();
    }

    if (typeof value === "string") {
        const parsed = Date.parse(value);
        return Number.isNaN(parsed) ? null : parsed;
    }

    if (typeof value === "object" && value !== null && "toMillis" in value) {
        const toMillis = (value as { toMillis?: () => number }).toMillis;
        if (typeof toMillis === "function") {
            return toMillis.call(value);
        }
    }

    return null;
}

function getAnchorTimestamp(doc: admin.firestore.QueryDocumentSnapshot): number | null {
    const data = doc.data();
    return toTimestamp(data.startedAt) ?? toTimestamp(data.createdAt);
}

function buildMatchRationale(
    matchedBy: string,
    candidate: RankedLiveDoc,
): string {
    const diff = candidate.timeDiff === null
        ? "unknown"
        : `${Math.round(candidate.timeDiff / 60000)}m`;
    return `matchedBy=${matchedBy}; status=${candidate.status || "unknown"}; diff=${diff}`;
}

function pickUniqueLiveDoc(
    docs: admin.firestore.QueryDocumentSnapshot[],
    statuses?: string[],
    zoomAccountDocId?: string,
    targetTimestamp?: number | null,
    statusPriority: Record<string, number> = {},
    requireTemporalFit: boolean = false,
    matchedBy: string = "unknown",
): LiveDocMatch {
    const allowedStatuses = statuses?.map((status) => status.toLowerCase()) ?? null;
    const rankedDocs: RankedLiveDoc[] = (zoomAccountDocId
        ? docs.filter((doc) => doc.data().zoomAccountId === zoomAccountDocId)
        : docs)
        .filter((doc) => {
            if (!allowedStatuses?.length) {
                return true;
            }

            return allowedStatuses.includes(normalizeStatusValue(doc.data().status));
        })
        .map((doc) => {
            const anchorTimestamp = getAnchorTimestamp(doc);
            return {
                doc,
                status: normalizeStatusValue(doc.data().status),
                statusRank: statusPriority[normalizeStatusValue(doc.data().status)] ?? 0,
                anchorTimestamp,
                timeDiff:
                    targetTimestamp !== null &&
                        targetTimestamp !== undefined &&
                        anchorTimestamp !== null
                        ? Math.abs(anchorTimestamp - targetTimestamp)
                        : null,
            };
        })
        .sort((a, b) => {
            if (targetTimestamp !== null && targetTimestamp !== undefined) {
                if (a.timeDiff === null && b.timeDiff !== null) return 1;
                if (a.timeDiff !== null && b.timeDiff === null) return -1;
                if (a.timeDiff !== null && b.timeDiff !== null && a.timeDiff !== b.timeDiff) {
                    return a.timeDiff - b.timeDiff;
                }
            }

            if (b.statusRank !== a.statusRank) {
                return b.statusRank - a.statusRank;
            }

            const aAnchor = a.anchorTimestamp ?? 0;
            const bAnchor = b.anchorTimestamp ?? 0;
            if (bAnchor !== aAnchor) {
                return bAnchor - aAnchor;
            }

            return a.doc.id.localeCompare(b.doc.id);
        });

    if (rankedDocs.length === 0) {
        return { doc: null, ambiguous: false, candidateIds: [] };
    }

    const bestCandidate = rankedDocs[0];
    const bestWithinWindow =
        bestCandidate.timeDiff !== null &&
        bestCandidate.timeDiff <= CLEAR_WINNER_WINDOW_MS;

    if (rankedDocs.length === 1) {
        if (requireTemporalFit && targetTimestamp !== null && targetTimestamp !== undefined && !bestWithinWindow) {
            return {
                doc: null,
                ambiguous: false,
                candidateIds: [bestCandidate.doc.id],
            };
        }

        return {
            doc: bestCandidate.doc,
            ambiguous: false,
            candidateIds: [bestCandidate.doc.id],
            rationale: buildMatchRationale(matchedBy, bestCandidate),
        };
    }

    const secondCandidate = rankedDocs[1];
    const secondFarEnough =
        secondCandidate.timeDiff === null ||
        (bestCandidate.timeDiff !== null &&
            secondCandidate.timeDiff - bestCandidate.timeDiff >= CLEAR_WINNER_GAP_MS);

    if (bestWithinWindow && secondFarEnough) {
        return {
            doc: bestCandidate.doc,
            ambiguous: false,
            candidateIds: [bestCandidate.doc.id],
            rationale: buildMatchRationale(matchedBy, bestCandidate),
        };
    }

    return {
        doc: null,
        ambiguous: true,
        candidateIds: rankedDocs.map((candidate) => candidate.doc.id),
    };
}

async function findLiveDoc({
    db,
    zoomMeetingId,
    meetingUUID,
    zoomAccountDocId,
    statuses,
    allowZoomAccountFallback = false,
    targetTimestamp,
    statusPriority = {},
    requireTemporalFitForReusableIds = false,
}: {
    db: admin.firestore.Firestore;
    zoomMeetingId?: string | null;
    meetingUUID?: string | null;
    zoomAccountDocId?: string;
    statuses?: string[];
    allowZoomAccountFallback?: boolean;
    targetTimestamp?: number | null;
    statusPriority?: Record<string, number>;
    requireTemporalFitForReusableIds?: boolean;
}): Promise<FindLiveDocResult> {
    const liveCollection = db.collection("live");
    const ambiguousMatches: { matchedBy: string; candidateIds: string[] }[] = [];

    const resolveMatch = (
        matchedBy: string,
        docs: admin.firestore.QueryDocumentSnapshot[],
        requireTemporalFit: boolean = false,
    ): LiveDocMatch => {
        const match = pickUniqueLiveDoc(
            docs,
            statuses,
            zoomAccountDocId,
            targetTimestamp,
            statusPriority,
            requireTemporalFit,
            matchedBy,
        );
        if (match.doc) {
            return match;
        }

        if (match.ambiguous) {
            ambiguousMatches.push({
                matchedBy,
                candidateIds: match.candidateIds,
            });
        }

        return match;
    };

    if (meetingUUID) {
        const byMeetingUUID = await liveCollection.where("meetingUUID", "==", meetingUUID).get();
        const liveDoc = resolveMatch("meetingUUID", byMeetingUUID.docs, false);
        if (liveDoc.doc) {
            return { doc: liveDoc.doc, ambiguousMatches, rationale: liveDoc.rationale };
        }

        const byMeetingUUIDHistory = await liveCollection
            .where("meetingUUIDHistory", "array-contains", meetingUUID)
            .get();
        const historyDoc = resolveMatch("meetingUUIDHistory", byMeetingUUIDHistory.docs, false);
        if (historyDoc.doc) {
            return { doc: historyDoc.doc, ambiguousMatches, rationale: historyDoc.rationale };
        }
    }

    if (zoomMeetingId) {
        const byMeetingId = await liveCollection.where("meetingId", "==", zoomMeetingId).get();
        const liveDoc = resolveMatch("meetingId", byMeetingId.docs, requireTemporalFitForReusableIds);
        if (liveDoc.doc) {
            return { doc: liveDoc.doc, ambiguousMatches, rationale: liveDoc.rationale };
        }
    }

    if (allowZoomAccountFallback && zoomAccountDocId) {
        const byZoomAccount = await liveCollection.where("zoomAccountId", "==", zoomAccountDocId).get();
        const liveDoc = resolveMatch("zoomAccountIdFallback", byZoomAccount.docs, true);
        if (liveDoc.doc) {
            return { doc: liveDoc.doc, ambiguousMatches, rationale: liveDoc.rationale };
        }
    }

    return { doc: null, ambiguousMatches };
}

function buildMeetingIdentityUpdate(
    zoomMeetingId?: string | null,
    meetingUUID?: string | null,
) {
    const updateData: Record<string, unknown> = {};

    if (zoomMeetingId) {
        updateData.meetingId = zoomMeetingId;
    }

    if (meetingUUID) {
        updateData.meetingUUID = meetingUUID;
        updateData.meetingUUIDHistory = FieldValue.arrayUnion(meetingUUID);
    }

    return updateData;
}

function buildProcessingDocId(
    zoomAccountDocId: string,
    meetingUUID: string,
): string {
    return encodeUUIDForFirestore(`${zoomAccountDocId}_${meetingUUID}`);
}

// Configure body parsing to capture rawBody needed for signature verification
zoomApp.use(express.json({
    verify: (req: any, res, buf) => {
        req.rawBody = buf.toString();
    }
}));

const zoomHandler = async (req: any, res: any) => {
    try {
        const db = getFirestore("ihthishamecource");
        const { zoomAccountDocId } = req.params;
        const event = req.body?.event;

        // 1. URL Validation - MUST BE FIRST and independent of signature for initial setup
        if (event === "endpoint.url_validation") {
            const zoomAccountSnapshot = await db.collection("zoomAccounts").doc(zoomAccountDocId).get();
            if (!zoomAccountSnapshot.exists) return res.status(404).json({ message: "Account not found" });

            const secretToken = zoomAccountSnapshot.data()?.webhookSecret || "";
            const plainToken = req.body.payload.plainToken;
            const encryptedToken = crypto
                .createHmac("sha256", secretToken)
                .update(plainToken)
                .digest("hex");

            console.log("✅ Zoom URL Validated for account:", zoomAccountDocId);
            return res.status(200).json({
                plainToken,
                encryptedToken,
            });
        }

        const timestamp = req.headers["x-zm-request-timestamp"] as string;
        const signatureHeader = req.headers["x-zm-signature"] as string;

        await logToFirestore({
            type: "incoming_event",
            path: req.path,
            event: event,
            zoomAccountDocId: zoomAccountDocId,
            payload: req.body,
        });

        let secretToken: string | null = null;
        const zoomAccountSnapshot = await db.collection("zoomAccounts").doc(zoomAccountDocId).get();

        if (zoomAccountSnapshot.exists) {
            secretToken = zoomAccountSnapshot.data()?.webhookSecret || "";
        } else {
            return res.status(404).json({ message: "Account not found" });
        }

        if (!secretToken || !timestamp || !signatureHeader) {
            return res.status(400).json({ message: "Missing security headers" });
        }

        // Signature Verification
        const message = `v0:${timestamp}:${req.rawBody}`;
        const hashForVerify = crypto
            .createHmac("sha256", secretToken)
            .update(message)
            .digest("hex");
        const signature = `v0=${hashForVerify}`;

        if (signature !== signatureHeader) {
            console.warn("Signature mismatch for event:", event);
            await logToFirestore({ type: "warning", message: "Signature mismatch", id: zoomAccountDocId });
            return res.status(401).json({ message: "Unauthorized" });
        }

        // 2. Meeting Started
        if (event === "meeting.started" || event === "meeting.live_streaming_started") {
            const zoomMeetingId = normalizeMeetingValue(req.body?.payload?.object?.id);
            const meetingUUID = normalizeMeetingValue(
                req.body?.payload?.object?.uuid ?? req.body?.payload?.object?.id,
            );
            const startTimestamp = toTimestamp(req.body?.payload?.object?.start_time) ?? Date.now();
            console.log(`🚀 Meeting Started: ${zoomMeetingId} (${meetingUUID})`);

            const liveDoc = await findLiveDoc({
                db,
                zoomMeetingId,
                meetingUUID,
                zoomAccountDocId,
                statuses: ["Created", "Scheduled"],
                allowZoomAccountFallback: true,
                targetTimestamp: startTimestamp,
                statusPriority: { created: 2, scheduled: 1 },
                requireTemporalFitForReusableIds: true,
            });

            if (liveDoc.doc) {
                const startTimeStr = req.body?.payload?.object?.start_time;
                const startedAt = startTimeStr ? new Date(startTimeStr) : admin.firestore.FieldValue.serverTimestamp();

                await liveDoc.doc.ref.update({
                    ...buildMeetingIdentityUpdate(zoomMeetingId, meetingUUID),
                    status: "onLive",
                    startedAt: startedAt,
                    lastWebhookEvent: event,
                });

                await logToFirestore({
                    type: "success",
                    message: "Status updated to onLive",
                    liveId: liveDoc.doc.id,
                    matchRationale: liveDoc.rationale,
                });
                return res.status(200).json({ message: "Meeting Started" });
            }

            if (liveDoc.ambiguousMatches.length) {
                await logToFirestore({
                    type: "warning",
                    message: "Ambiguous live match on meeting start",
                    event,
                    zoomAccountDocId,
                    zoomMeetingId,
                    meetingUUID,
                    ambiguousMatches: liveDoc.ambiguousMatches,
                });
            }
        }

        // 3. Meeting Ended
        if (event === "meeting.ended") {
            const zoomMeetingId = normalizeMeetingValue(req.body?.payload?.object?.id);
            const meetingUUID = normalizeMeetingValue(
                req.body?.payload?.object?.uuid ?? req.body?.payload?.object?.id,
            );
            console.log(`🏁 Meeting Ended: ${zoomMeetingId} (${meetingUUID})`);

            const startTimestamp =
                toTimestamp(req.body?.payload?.object?.start_time) ??
                toTimestamp(req.body?.payload?.object?.end_time);

            const liveDoc = await findLiveDoc({
                db,
                zoomMeetingId,
                meetingUUID,
                zoomAccountDocId,
                statuses: ["onLive", "completed", "Created", "Scheduled"],
                allowZoomAccountFallback: true,
                targetTimestamp: startTimestamp,
                statusPriority: { onlive: 4, completed: 3, created: 2, scheduled: 1 },
                requireTemporalFitForReusableIds: true,
            });

            if (liveDoc.doc) {
                const endTimeStr = req.body?.payload?.object?.end_time;
                const endedAt = endTimeStr ? new Date(endTimeStr) : admin.firestore.FieldValue.serverTimestamp();

                await liveDoc.doc.ref.update({
                    ...buildMeetingIdentityUpdate(zoomMeetingId, meetingUUID),
                    status: "completed",
                    endedAt: endedAt,
                    lastWebhookEvent: event,
                });
                await logToFirestore({
                    type: "success",
                    message: "Status updated to completed",
                    liveId: liveDoc.doc.id,
                    matchRationale: liveDoc.rationale,
                });
            } else if (liveDoc.ambiguousMatches.length) {
                await logToFirestore({
                    type: "warning",
                    message: "Ambiguous live match on meeting end",
                    event,
                    zoomAccountDocId,
                    zoomMeetingId,
                    meetingUUID,
                    ambiguousMatches: liveDoc.ambiguousMatches,
                });
            }
            return res.status(200).json({ message: "Meeting Ended" });
        }

        // 4. Recording Completed
        if (event === "recording.completed") {
            console.log("✅ Zoom Recording Completed Event ✅");

            // Process recording logic (the existing complex logic)
            // I'll call a separate internal function to keep it clean
            processZoomRecording(req.body, zoomAccountDocId, db);

            return res.status(200).json({ message: "Recording processing initiated" });
        }

        return res.status(200).json({ message: "Event ignored" });
    } catch (error: any) {
        console.error("Error in zoomHandler:", error);
        await logToFirestore({ type: "critical_error", message: error.message });
        return res.status(500).json({ message: "Internal Server Error" });
    }
};

// Map routes to the unified handler
zoomApp.post("/webhook/:zoomAccountDocId", zoomHandler);
zoomApp.post("/meetingStart/:zoomAccountDocId", zoomHandler);
zoomApp.post("/meetingEnd/:zoomAccountDocId", zoomHandler);
zoomApp.post("/recordingComplete/:zoomAccountDocId", zoomHandler);

// Internal function to handle recording processing
async function processZoomRecording(body: any, zoomAccountDocId: string, db: admin.firestore.Firestore) {
    const zoomMeetingId = normalizeMeetingValue(body?.payload?.object?.id);
    const meetingUUID = normalizeMeetingValue(body?.payload?.object?.uuid ?? body?.payload?.object?.id);
    const startTimestamp =
        toTimestamp(body?.payload?.object?.start_time) ??
        toTimestamp(body?.payload?.object?.recording_start) ??
        toTimestamp(body?.payload?.object?.recording_start_time);
    try {
        if (!meetingUUID) {
            throw new Error("Recording completed payload is missing meeting UUID.");
        }

        const processingDocId = buildProcessingDocId(zoomAccountDocId, meetingUUID);

        // Use transaction to ensure atomic processing and prevent duplicates
        const result = await db.runTransaction(async (transaction) => {
            const processingDocRef = db.collection("recordingProcessing").doc(processingDocId);
            const processingDoc = await transaction.get(processingDocRef);

            if (processingDoc.exists) {
                const processingData = processingDoc.data();
                if (processingData?.status === "completed") return { status: "already_completed" };
                if (processingData?.status === "processing") return { status: "already_processing" };
            }

            transaction.set(processingDocRef, {
                meetingId: zoomMeetingId,
                meetingUUID: meetingUUID,
                zoomAccountDocId: zoomAccountDocId,
                processingStartedAt: FieldValue.serverTimestamp(),
                webhookId: zoomAccountDocId,
                status: "processing",
            });

            return { status: "processing_started" };
        });

        if (result.status !== "processing_started") {
            console.log(` Recording ${meetingUUID} skipped: ${result.status}`);
            return;
        }

        let bunnyLibraryId: string | null = null;
        let bunnyAccessToken: string | null = null;

        const bunnyCredentialsSnapshot = await db.collection("bunnyVideo").doc("bunnyVideo").get();
        if (bunnyCredentialsSnapshot.exists) {
            const data = bunnyCredentialsSnapshot.data();
            bunnyLibraryId = data?.libraryId || "";
            bunnyAccessToken = data?.accessKey || "";
        } else {
            throw new Error("Bunny credentials not found");
        }

        const downloadToken = body.download_token || "";
        const files = body.payload?.object?.recording_files ?? [];

        // Log file types for debugging
        const fileTypes = files.map((f: any) => f.recording_type);
        console.log(`🔍 Zoom Recording Files found: ${fileTypes.join(", ")}`);

        // Relaxed filtering: include most video types
        const eligibleRecordings = files.filter((f: any) =>
            f.file_type === "MP4" && (
                f.recording_type === "shared_screen_with_speaker_view" ||
                f.recording_type === "shared_screen_with_speaker_view(CC)" ||
                f.recording_type === "shared_screen_with_gallery_view" ||
                f.recording_type === "speaker_view" ||
                f.recording_type === "gallery_view" ||
                f.recording_type === "shared_screen"
            )
        );

        const totalFileSizeInGB = eligibleRecordings.reduce((t: number, f: any) => t + f.file_size / (1024 * 1024 * 1024), 0);
        console.log(`📊 Processing ${eligibleRecordings.length} eligible files, ${totalFileSizeInGB.toFixed(2)}GB total`);

        await db.collection("recordingProcessing").doc(processingDocId).update({
            foundFileTypes: fileTypes,
            eligibleFileCount: eligibleRecordings.length,
            totalFileSizeInGB: totalFileSizeInGB,
        });

        const liveStreamDoc = await findLiveDoc({
            db,
            zoomMeetingId,
            meetingUUID,
            zoomAccountDocId,
            statuses: ["onLive", "completed", "Created", "Scheduled"],
            allowZoomAccountFallback: true,
            targetTimestamp: startTimestamp,
            statusPriority: { onlive: 4, completed: 3, created: 2, scheduled: 1 },
            requireTemporalFitForReusableIds: true,
        });

        if (!liveStreamDoc.doc) {
            if (liveStreamDoc.ambiguousMatches.length) {
                const details = JSON.stringify(liveStreamDoc.ambiguousMatches);
                await logToFirestore({
                    type: "error",
                    message: "Ambiguous live stream match for recording. Manual review required.",
                    zoomAccountId: zoomAccountDocId,
                    meetingUUID,
                    ambiguousMatches: liveStreamDoc.ambiguousMatches,
                });
                throw new Error("Ambiguous live stream match for recording. " + details);
            }

            throw new Error("Live stream not found for meetingUUID: " + meetingUUID);
        }

        await liveStreamDoc.doc.ref.set(buildMeetingIdentityUpdate(zoomMeetingId, meetingUUID), { merge: true });

        await db.collection("recordingProcessing").doc(processingDocId).update({
            matchedLiveId: liveStreamDoc.doc.id,
            matchRationale: liveStreamDoc.rationale || null,
        });

        const liveStreamData = liveStreamDoc.doc.data();
        const courseId = liveStreamData.courseId || "";

        // Use batchIds if available, otherwise fallback to single batchId
        const batchIds: string[] = liveStreamData.batchIds && Array.isArray(liveStreamData.batchIds) && liveStreamData.batchIds.length > 0
            ? liveStreamData.batchIds
            : (liveStreamData.batchId ? [liveStreamData.batchId] : []);

        if (!courseId || batchIds.length === 0) {
            throw new Error(
                `Live stream ${liveStreamDoc.doc.id} is missing courseId or batchIds. courseId="${courseId}", batchIds="${batchIds}"`,
            );
        }

        let uploadedFiles = 0;

        for (let i = 0; i < eligibleRecordings.length; i++) {
            const recording = eligibleRecordings[i];

            // Upload to Bunny and store in Firestore
            const videoId = await uploadVideoToBunny({
                accessToken: bunnyAccessToken!,
                libraryId: bunnyLibraryId!,
                videoUrl: recording.download_url,
                videoName: liveStreamData.title || body.payload.object.topic || "Meeting",
                courseId: liveStreamData.courseId || "standalone",
                downloadToken: downloadToken,
            });

            if (videoId) {
                // Store in EACH associated batch
                for (const targetBatchId of batchIds) {
                    const liveRecordingDoc = db.collection("courses").doc(courseId).collection("batches").doc(targetBatchId).collection("liveRecordings");
                    const id = liveRecordingDoc.doc().id;
                    await liveRecordingDoc.doc(id).set({
                        isFromBunny: true,
                        libraryId: bunnyLibraryId,
                        id: id,
                        videoId: videoId,
                        courseId: courseId,
                        batchId: targetBatchId,
                        liveId: liveStreamDoc.doc.id,
                        createdAt: FieldValue.serverTimestamp(),
                        name: liveStreamData.title || body.payload.object.topic || "Meeting",
                        uploadedBy: "Webhook",
                        meetingId: zoomMeetingId,
                        meetingUUID: meetingUUID,
                        downloadURL: recording.download_url,
                        fileSize: recording.file_size.toString(),
                        uploadStatus: "initiated",
                        recordingType: recording.recording_type,
                    });
                }
                uploadedFiles++;
            } else {
                console.error(`❌ Failed to initiate Bunny upload for ${recording.recording_type}`);
            }
        }

        await db.collection("recordingProcessing").doc(processingDocId).update({
            status: "completed",
            completedAt: FieldValue.serverTimestamp(),
            uploadedFiles,
            totalFiles: eligibleRecordings.length,
        });

    } catch (error: any) {
        console.error("Recording processing error:", error);
        const processingDocId = meetingUUID
            ? buildProcessingDocId(zoomAccountDocId, meetingUUID)
            : encodeUUIDForFirestore(`${zoomAccountDocId}_missing_uuid_${Date.now()}`);
        await db.collection("recordingProcessing").doc(processingDocId).set({
            status: "failed",
            error: error.message,
            failedAt: FieldValue.serverTimestamp(),
        }, { merge: true });
    }
}



interface DeleteRecordingData { courseId: string; batchId: string; recordingId: string; }
export const deleteRecordingIhthisham = https.onCall(async (request: https.CallableRequest<DeleteRecordingData>) => {
    try {
        const { courseId, batchId, recordingId } = request.data;
        const db = getFirestore("ihthishamecource");
        const recordingRef = db.collection("courses").doc(courseId).collection("batches").doc(batchId).collection("liveRecordings").doc(recordingId);
        const recordingDoc = await recordingRef.get();

        if (!recordingDoc.exists) {
            throw new https.HttpsError("not-found", "Recording not found.");
        }

        // const data = recordingDoc.data();
        // const videoId = data?.videoId;
        // const libraryId = data?.libraryId;

        // // 1. Delete from Bunny if applicable
        // if (videoId && libraryId) {
        //     const bunnyCreds = await db.collection("bunnyVideo").doc("bunnyVideo").get();
        //     const accessKey = bunnyCreds.data()?.accessKey;

        //     if (accessKey) {
        //         try {
        //             await axios.delete(`https://video.bunnycdn.com/library/${libraryId}/videos/${videoId}`, {
        //                 headers: { AccessKey: accessKey }
        //             });
        //             console.log(`Successfully deleted video ${videoId} from Bunny library ${libraryId}`);
        //         } catch (e: any) {
        //             console.error("Error deleting from Bunny:", e.response?.data || e.message);
        //             // We continue to delete from Firestore even if Bunny delete fails (e.g., video already gone)
        //         }
        //     }
        // }

        // 2. Delete from Firestore
        await recordingRef.delete();

        return { success: true, message: "Recording deleted successfully." };
    } catch (e: any) {
        console.error("Error in deleteRecording:", e);
        throw new https.HttpsError("internal", e.message);
    }
});

// Scheduled Cleanup
export const scheduledCleanupIhthisham = onSchedule({ schedule: "0 2 * * *", timeZone: "Asia/Kolkata" }, async (event) => {
    try {
        const db = getFirestore("ihthishamecource");
        const now = admin.firestore.Timestamp.now();
        const fiveMinutesAgo = admin.firestore.Timestamp.fromDate(new Date(now.toDate().getTime() - 5 * 60 * 1000));

        const stuckProcessingSnapshot = await db.collection("recordingProcessing")
            .where("status", "==", "processing")
            .get();

        for (const doc of stuckProcessingSnapshot.docs) {
            const data = doc.data();
            const startedAt = data.processingStartedAt;
            if (startedAt && startedAt.toMillis() < fiveMinutesAgo.toMillis()) {
                await doc.ref.update({ status: "failed", error: "Processing timeout", failedAt: FieldValue.serverTimestamp() });
            }
        }
        console.log("Stuck records cleaned up.");
    } catch (e) {
        console.error("Error in scheduled cleanup:", e);
    }
});

// Helper functions 
async function uploadVideoToBunny({ accessToken, libraryId, videoUrl, videoName, courseId, downloadToken }: any): Promise<string | null> {
    try {
        let collectionId = "";
        if (courseId && courseId !== "standalone") {
            const courseRef = await getFirestore("ihthishamecource").collection("courses").doc(courseId).get();
            collectionId = courseRef.data()?.bunnyCollectionId || "";
        }

        const authenticatedUrl = downloadToken ? `${videoUrl}?access_token=${downloadToken}` : videoUrl;

        const res = await axios.post(`https://video.bunnycdn.com/library/${libraryId}/videos/fetch${collectionId ? `?collectionId=${collectionId}` : ""}`,
            { url: authenticatedUrl, title: videoName },
            { headers: { AccessKey: accessToken, "Content-Type": "application/json" } });
        return res.status === 200 ? res.data.id : null;
    } catch (e: any) {
        console.error("Bunny fetch error:", e.response?.data || e.message);
        return null;
    }
}
