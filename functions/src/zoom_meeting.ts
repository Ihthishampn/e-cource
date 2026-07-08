import axios from "axios";
import { onCall, HttpsError } from "firebase-functions/v2/https";

export const createZoomMeetingIhthisham = onCall(async (request) => {
    // 1. Security Check: Ensure the caller is authenticated
    if (!request.auth) {
        throw new HttpsError(
            "unauthenticated",
            "Only authenticated admins can create Zoom meetings."
        );
    }

    const { accountId, clientId, clientSecret, topic, startTime, duration, password } = request.data;
    if (!accountId || !clientId || !clientSecret || !topic || !startTime) {
        throw new HttpsError(
            "invalid-argument",
            "Missing required fields: accountId, clientId, clientSecret, topic, or startTime."
        );
    }

    try {
        console.log(`🔐 Fetching Zoom Access Token for Account: ${accountId}`);

        // 2. Get Access Token via Server-to-Server OAuth
        const authHeader = Buffer.from(`${clientId}:${clientSecret}`).toString("base64");
        const tokenResponse = await axios.post(
            `https://zoom.us/oauth/token?grant_type=account_credentials&account_id=${accountId}`,
            {},
            {
                headers: {
                    Authorization: `Basic ${authHeader}`,
                },
            }
        );

        const accessToken = tokenResponse.data.access_token;
        if (!accessToken) {
            throw new Error("Failed to retrieve access token from Zoom.");
        }

        console.log(`✅ Access Token acquired. Creating meeting: ${topic} at ${startTime}`);

        // Ensure startTime strictly follows the format: yyyy-MM-ddTHH:mm:ssZ
        const formattedStartTime = new Date(startTime).toISOString().split('.')[0] + "Z";

        // 3. Create Meeting
        const meetingResponse = await axios.post(
            "https://api.zoom.us/v2/users/me/meetings",
            {
                topic: topic,
                type: 2, // Scheduled meeting
                start_time: formattedStartTime,
                duration: duration || 30,
                password: password,


                settings: {
                    host_video: true,
                    participant_video: true,
                    join_before_host: true,
                    mute_upon_entry: true,
                    waiting_room: false,
                    enforce_login: false,
                    meeting_authentication: false,
                },
            },
            {
                headers: {
                    Authorization: `Bearer ${accessToken}`,
                    "Content-Type": "application/json",
                },
            }
        );

        console.log(`🚀 Zoom Meeting Created: ${meetingResponse.data.id}`);

        console.log("ihthisham");
        return JSON.stringify(meetingResponse.data);

    } catch (error: any) {
        const errorData = error.response?.data;
        console.error("❌ Zoom API Error:", errorData || error.message);

        throw new HttpsError(
            "internal",
            errorData?.message || error.message || "An error occurred while creating the Zoom meeting."
        );
    }
});
