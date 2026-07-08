import { onRequest } from "firebase-functions/v2/https";

export const getZoomParticipantsIhthisham = onRequest({ cors: true }, async (req, res) => {
    try {
        if (req.method === "OPTIONS") {
            res.status(204).send("Method not allowed");
            return;
        }

        const { meetingUUID, accountId, clientId, clientSecret, nextPageToken } = req.body;
        console.log("getZoomParticipants called with:", { meetingUUID, accountId, clientId, clientSecret: "***", nextPageToken });

        if (!meetingUUID) {
            console.error("Missing meetingUUID");
            res.status(400).json({ error: "Missing meetingUUID" });
            return;
        }

        // Zoom OAuth credentials - Ensure No Spaces or Invisible characters
        const aId = accountId.replace(/\s/g, '');
        const cId = clientId.replace(/\s/g, '');
        const cSecret = clientSecret.replace(/\s/g, '');

        console.log("Token request for Account ID:", aId.substring(0, 4) + "****");

        // Get access token
        const tokenUrl = "https://zoom.us/oauth/token";
        const credentials = Buffer.from(`${cId}:${cSecret}`).toString("base64");

        // Some Zoom apps prefer params in Body, some in URL. Body is the most standard for OAuth.
        const tokenParams = new URLSearchParams();
        tokenParams.append("grant_type", "account_credentials");
        tokenParams.append("account_id", aId);

        console.log("Sending token request to Zoom with params:", tokenParams.toString());

        const tokenResponse = await fetch(tokenUrl, {
            method: "POST",
            headers: {
                Authorization: `Basic ${credentials}`,
                "Content-Type": "application/x-www-form-urlencoded",
            },
            body: tokenParams.toString(),
        });

        const responseText = await tokenResponse.text();
        console.log(`Zoom Auth Response Status: ${tokenResponse.status}`);
        console.log(`Zoom Auth Response Headers: ${JSON.stringify(Object.fromEntries(tokenResponse.headers.entries()))}`);

        let tokenData: any;
        try {
            tokenData = JSON.parse(responseText);
        } catch (e) {
            console.error("Non-JSON response from Zoom:", responseText);
            throw new Error(`Zoom returned invalid response: ${responseText.substring(0, 100)}`);
        }

        if (!tokenResponse.ok) {
            console.error("Zoom Auth Failed:", tokenData);
            // Include reason and error for definitive debugging
            const errorReason = tokenData.reason || "No reason";
            const errorCode = tokenData.error || "No error code";
            throw new Error(`Zoom Auth Failed: ${errorCode} (${errorReason})`);
        }
        const accessToken = tokenData.access_token;
        console.log("Access token retrieved successfully");

        if (!accessToken) {
            throw new Error("Access token missing in Zoom success response.");
        }

        // Fetch participants
        const encodedUuid = encodeURIComponent(encodeURIComponent(meetingUUID));
        const participantsUrl =
            nextPageToken && nextPageToken !== ""
                ? `https://api.zoom.us/v2/past_meetings/${encodedUuid}/participants?page_size=30&next_page_token=${nextPageToken}`
                : `https://api.zoom.us/v2/past_meetings/${encodedUuid}/participants?page_size=30`;

        const participantsResponse = await fetch(participantsUrl, {
            method: "GET",
            headers: {
                Authorization: `Bearer ${accessToken}`,
                "Content-Type": "application/json",
            },
        });

        const participantsData = await participantsResponse.json() as any;
        console.log("Participants fetched successfully, count:", participantsData.participants?.length || 0);

        res.status(200).json(participantsData);
    } catch (error: any) {
        console.error("Error fetching Zoom participants:", error);
        res.status(500).json({ error: error.message });
    }
});

export const getZoomParticipantsExcelReportIhthisham = onRequest({ cors: true }, async (req, res) => {
    try {
        if (req.method === "OPTIONS") {
            res.status(204).send("Method not allowed");
            return;
        }

        const { meetingUUID, accountId, clientId, clientSecret } = req.body;
        console.log("getZoomParticipantsExcelReport called with:", { meetingUUID, accountId, clientId, clientSecret: "***" });

        if (!meetingUUID) {
            console.error("Missing meetingUUID");
            res.status(400).json({ error: "Missing meetingUUID" });
            return;
        }

        // Zoom OAuth credentials - Ensure No Spaces
        const aId = accountId.replace(/\s/g, '');
        const cId = clientId.replace(/\s/g, '');
        const cSecret = clientSecret.replace(/\s/g, '');

        console.log("Token request (Excel) for Account ID:", aId.substring(0, 4) + "****");

        // Get access token
        const tokenUrl = "https://zoom.us/oauth/token";
        const credentials = Buffer.from(`${cId}:${cSecret}`).toString("base64");

        const tokenParams = new URLSearchParams();
        tokenParams.append("grant_type", "account_credentials");
        tokenParams.append("account_id", aId);

        console.log("Fetching access token from Zoom...");
        const tokenResponse = await fetch(tokenUrl, {
            method: "POST",
            headers: {
                Authorization: `Basic ${credentials}`,
                "Content-Type": "application/x-www-form-urlencoded",
            },
            body: tokenParams.toString(),
        });

        const responseText = await tokenResponse.text();
        console.log(`Zoom Auth Response Status (Excel): ${tokenResponse.status}`);
        console.log(`Zoom Auth Response Headers (Excel): ${JSON.stringify(Object.fromEntries(tokenResponse.headers.entries()))}`);

        let tokenData: any;
        try {
            tokenData = JSON.parse(responseText);
        } catch (e) {
            console.error("Non-JSON response from Zoom:", responseText);
            throw new Error(`Zoom returned invalid response: ${responseText.substring(0, 100)}`);
        }

        if (!tokenResponse.ok) {
            console.error("Zoom Auth Failed (Excel):", tokenData);
            const errorReason = tokenData.reason || "No reason";
            const errorCode = tokenData.error || "No error code";
            throw new Error(`Zoom Auth Failed: ${errorCode} (${errorReason})`);
        }
        const accessToken = tokenData.access_token;
        console.log("Access token retrieved successfully");

        if (!accessToken) {
            throw new Error("Access token missing in Zoom success response.");
        }

        // Fetch all participants with pagination
        const encodedUuid = encodeURIComponent(encodeURIComponent(meetingUUID));
        console.log("Fetching participants for UUID:", encodedUuid);
        let allParticipants: any[] = [];
        let nextPageToken = "";
        let pageCount = 0;
        let totalRecords = 0;

        // Loop to fetch all pages
        do {
            console.log(`Fetching page with token: ${nextPageToken || 'initial'}`);
            let participantsUrl = `https://api.zoom.us/v2/past_meetings/${encodedUuid}/participants?page_size=300`;
            if (nextPageToken && nextPageToken !== "") {
                participantsUrl += `&next_page_token=${nextPageToken}`;
            }

            const participantsResponse = await fetch(participantsUrl, {
                method: "GET",
                headers: {
                    Authorization: `Bearer ${accessToken}`,
                    "Content-Type": "application/json",
                },
            });

            const participantsData = await participantsResponse.json() as any;

            // Check for errors in response
            if (!participantsResponse.ok) {
                throw new Error(participantsData.message || "Failed to fetch participants");
            }

            // Accumulate participants
            if (participantsData.participants && Array.isArray(participantsData.participants)) {
                allParticipants = allParticipants.concat(participantsData.participants);
            }

            // Update pagination info
            pageCount = participantsData.page_count || 0;
            totalRecords = participantsData.total_records || allParticipants.length;
            nextPageToken = participantsData.next_page_token || "";
        } while (nextPageToken && nextPageToken !== "");

        // Return combined response
        console.log("Excel report generated successfully, total records:", totalRecords);
        res.status(200).json({
            participants: allParticipants,
            page_count: pageCount,
            total_records: totalRecords,
            page_size: 300,
        });
    } catch (error: any) {
        console.error("Error fetching Zoom participants:", error);
        res.status(500).json({ error: error.message });
    }
});
