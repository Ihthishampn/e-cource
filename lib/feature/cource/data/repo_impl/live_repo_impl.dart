import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:e_cource/feature/cource/data/model/live_model.dart';
import 'package:e_cource/feature/cource/domain/live_repo.dart';
import 'package:e_cource/feature/settings/domain/model/zoom_account_model.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: LiveRepo)
class LiveRepoImpl implements LiveRepo {
  final FirebaseFirestore firebaseFirestore;

  LiveRepoImpl(this.firebaseFirestore);

  @override
  Future<List<ZoomAccountModel>> getZoomAccounts() async {
    try {
      final snapshot = await firebaseFirestore.collection('zoomAccounts').get();
      return snapshot.docs
          .map((doc) => ZoomAccountModel.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      log('Error getting Zoom accounts in LiveRepoImpl: $e');
      rethrow;
    }
  }

  @override
  Future<List<LiveModel>> fetchLivesForCourse(String courseId) async {
    try {
      final snapshot = await firebaseFirestore
          .collection('live')
          .where('courseId', isEqualTo: courseId)
          .orderBy('scheduledAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => LiveModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      log('Error fetching lives for course in LiveRepoImpl: $e');
      rethrow;
    }
  }

  @override
  Future<LiveModel> scheduleLive({
    required String courseId,
    required String courseName,
    required String title,
    required ZoomAccountModel zoomAccount,
    required DateTime scheduledAt,
    required int duration,
    required String passcode,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final token = await user?.getIdToken();
      final startTimeIso = '${scheduledAt.toUtc().toIso8601String().split('.')[0]}Z';

      final dio = Dio();
      final response = await dio.post(
        'https://us-central1-ecommerce-test-54853.cloudfunctions.net/createZoomMeetingIhthisham',
        data: {
          'data': {
            'accountId': zoomAccount.accountId,
            'clientId': zoomAccount.clientId,
            'clientSecret': zoomAccount.clientSecret,
            'topic': title,
            'startTime': startTimeIso,
            'duration': duration,
            'password': passcode.isEmpty ? null : passcode,
          }
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      final responseData = response.data['result'];
      if (responseData == null) {
        throw Exception('No response data returned from Cloud Function');
      }
      
      final Map<String, dynamic> meetingData = jsonDecode(responseData as String);

      final docRef = firebaseFirestore.collection('live').doc();
      final newLive = LiveModel(
        id: docRef.id,
        title: title,
        courseId: courseId,
        courseName: courseName,
        zoomAccountId: zoomAccount.id,
        zoomAccountName: zoomAccount.accountName,
        meetingId: meetingData['id']?.toString() ?? '',
        meetingPasscode: meetingData['password'] ?? passcode,
        joinUrl: meetingData['join_url'] ?? '',
        startUrl: meetingData['start_url'] ?? '',
        status: 'scheduled',
        scheduledAt: scheduledAt,
        createdAt: DateTime.now(),
      );

      await docRef.set(newLive.toMap());
      
      // Log success to webhookLogs so admin can view it in "View Logs"
      await firebaseFirestore.collection('webhookLogs').add({
        'type': 'success',
        'message': 'Meeting Scheduled: $title',
        'event': 'meeting.scheduled',
        'zoomMeetingId': meetingData['id']?.toString() ?? '',
        'timestamp': FieldValue.serverTimestamp(),
      });

      return newLive;
    } catch (e) {
      log('Error scheduling live meeting in LiveRepoImpl: $e');
      
      // Log error to webhookLogs
      try {
        await firebaseFirestore.collection('webhookLogs').add({
          'type': 'error',
          'message': 'Failed to schedule meeting: $title',
          'event': 'meeting.error',
          'zoomMeetingId': '',
          'timestamp': FieldValue.serverTimestamp(),
        });
      } catch (logError) {
        log('Failed to write error log: $logError');
      }
      
      rethrow;
    }
  }

  @override
  Future<void> endMeeting(String liveId) async {
    try {
      await firebaseFirestore.collection('live').doc(liveId).update({
        'status': 'completed',
        'endedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      log('Error ending meeting in LiveRepoImpl: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteMeeting(String liveId) async {
    try {
      await firebaseFirestore.collection('live').doc(liveId).delete();
    } catch (e) {
      log('Error deleting meeting in LiveRepoImpl: $e');
      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> fetchWebhookLogs() async {
    try {
      final snapshot = await firebaseFirestore
          .collection('webhookLogs')
          .orderBy('timestamp', descending: true)
          .limit(40)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'type': data['type'] ?? 'info',
          'message': data['message'] ?? '',
          'event': data['event'] ?? '',
          'zoomMeetingId': data['zoomMeetingId'] ?? '',
          'timestamp': data['timestamp'] != null
              ? (data['timestamp'] as Timestamp).toDate()
              : DateTime.now(),
        };
      }).toList();
    } catch (e) {
      log('Error fetching webhook logs in LiveRepoImpl: $e');
      rethrow;
    }
  }
}
