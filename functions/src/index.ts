/**
 * This Cloud Function handles the secure creation of a new team member.
 * It checks for existing auth users before creating a new one and 
 * initializes their profile in the 'team' Firestore collection.
 */

import { onCall, HttpsError, onRequest } from "firebase-functions/v2/https";
import * as admin from "firebase-admin";
import { getFirestore } from "firebase-admin/firestore";

if (!admin.apps.length) {
    admin.initializeApp();
}

/**
 * Helper function to build keywords for search indexing.
 */
function buildKeywords(name: string): string[] {
    const keywords: string[] = [];
    const searchString = name.toLowerCase().trim();
    const words = searchString.split(/\s+/);

    for (const word of words) {
        for (let i = 1; i <= word.length; i++) {
            keywords.push(word.substring(0, i));
        }
    }

    for (let i = 1; i <= searchString.length; i++) {
        keywords.push(searchString.substring(0, i));
    }

    // Return unique values
    return Array.from(new Set(keywords));
}

/**
 * Callable function to add a new member.
 * Expected data: { name: string, email: string, password: string, availability: object }
 */
export const addMemberIhthisham = onCall(async (request) => {
    // 1. Security Check: Ensure the caller is authenticated
    if (!request.auth) {
        throw new HttpsError(
            "unauthenticated",
            "Only authenticated admins can add members."
        );
    }

    const { name, email, password, availability } = request.data;
    if (!name || !email || !password) {
        throw new HttpsError(
            "invalid-argument",
            "Missing required fields: name, email, or password."
        );
    }

    const db = getFirestore("ihthishamecource");

    try {
        let uid: string;
        let userRecord: admin.auth.UserRecord;

        // 2. Check if user already exists in Firebase Authentication
        try {
            userRecord = await admin.auth().getUserByEmail(email);
            uid = userRecord.uid;
            console.log(`User already exists in Auth: ${uid}`);
        } catch (error: any) {
            if (error.code === 'auth/user-not-found') {
                // 3. Create user if not found
                userRecord = await admin.auth().createUser({
                    email: email,
                    password: password,
                    displayName: name,
                });
                uid = userRecord.uid;
                console.log(`Created new Auth user: ${uid}`);
            } else {
                throw error;
            }
        }

        // 4. Check if user already exists in 'team' collection
        const memberRef = db.collection("team").doc(uid);
        const memberDoc = await memberRef.get();

        if (memberDoc.exists) {
            console.log("ihthisham");
            return {
                success: false,
                message: "Member already exists in the team list.",
                uid: uid
            };
        }

        // 5. Initialize member profile in Firestore
        const memberData = {
            id: uid,
            name: name,
            email: email,
            keywords: buildKeywords(name),
            createdAt: admin.firestore.FieldValue.serverTimestamp(),
            availability: availability || {
                isDashboardAvailable: false,
                isUserAvailable: false,
                isCourseAvailable: false,
                isCouponsAvailable: false,
                isSelfServiceAvailable: false,
                isRoleAccessAvailable: false,
                isBannerAvailable: false,
                isNotificationAvailable: false,
                isPaymentGatewayAvailable: false,
                isSettingsAvailable: false,
                availableCourses: [],
            },
        };

        await memberRef.set(memberData);

        console.log("ihthisham");
        return {
            success: true,
            message: "Member added successfully.",
            uid: uid
        };

    } catch (error: any) {
        console.error("Error in addMember:", error);
        throw new HttpsError(
            "internal",
            error.message || "An internal error occurred."
        );
    }
});

/**
 * Callable function to update an existing member.
 * Expected data: { id: string, name?: string, email?: string, password?: string }
 */
export const updateMemberIhthisham = onCall(async (request) => {
    if (!request.auth) {
        throw new HttpsError(
            "unauthenticated",
            "Only authenticated admins can update members."
        );
    }

    const { id, name, email, password } = request.data;
    if (!id) {
        throw new HttpsError(
            "invalid-argument",
            "Missing required field: id."
        );
    }

    const db = getFirestore("ihthishamecource");

    try {
        const updateData: any = {};
        const authUpdateData: admin.auth.UpdateRequest = {};

        if (name) {
            updateData.name = name;
            updateData.keywords = buildKeywords(name);
            authUpdateData.displayName = name;
        }
        if (email) {
            updateData.email = email;
            authUpdateData.email = email;
        }
        if (password) {
            authUpdateData.password = password;
        }

        // 1. Update Firebase Authentication
        if (Object.keys(authUpdateData).length > 0) {
            await admin.auth().updateUser(id, authUpdateData);
            console.log(`Updated Auth user: ${id}`);
        }

        // 2. Update Firestore 'team' collection
        if (Object.keys(updateData).length > 0) {
            await db.collection("team").doc(id).update(updateData);
            console.log(`Updated Firestore document: ${id}`);
        }

        console.log("ihthisham");
        return {
            success: true,
            message: "Member updated successfully."
        };

    } catch (error: any) {
        console.error("Error in updateMember:", error);
        throw new HttpsError(
            "internal",
            error.message || "An internal error occurred."
        );
    }
});

export const createAdminUserIhthisham = onRequest({ cors: true }, async (req, res) => {
    try {
        const { phoneNumber } = req.body;

        if (!phoneNumber) {
            res.status(400).json({ error: "Phone number is required" });
            return;
        }

        let userRecord;

        try {
            userRecord = await admin.auth().getUserByPhoneNumber(phoneNumber);
        } catch (error: any) {
            if (error.code === "auth/user-not-found") {
                userRecord = await admin.auth().createUser({
                    phoneNumber,
                });
            } else {
                throw error;
            }
        }

        // 4️⃣ Response
        console.log("ihthisham");
        res.status(200).json({
            uid: userRecord.uid,
        });
    } catch (error: any) {
        console.error("OTP verification failed:", error);
        res.status(500).json({
            error: error.message || "Internal server error",
        });
    }
});

import { zoomApp } from "./zoom_recording/zoom_recording";
export const zoomWebhookIhthisham = onRequest({ timeoutSeconds: 3000, cors: true }, zoomApp);

export { getZoomParticipantsIhthisham, getZoomParticipantsExcelReportIhthisham } from "./zoom_attendence/index";

export {
    scheduledCleanupIhthisham,
    deleteRecordingIhthisham
} from "./zoom_recording/zoom_recording";

export { createZoomMeetingIhthisham } from "./zoom_meeting";


