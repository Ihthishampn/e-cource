import 'package:e_cource/feature/cource/data/model/live_model.dart';
import 'package:e_cource/feature/settings/domain/model/zoom_account_model.dart';

abstract class LiveRepo {
  Future<List<ZoomAccountModel>> getZoomAccounts();
  Future<List<LiveModel>> fetchLivesForCourse(String courseId);
  Future<LiveModel> scheduleLive({
    required String courseId,
    required String courseName,
    required String title,
    required ZoomAccountModel zoomAccount,
    required DateTime scheduledAt,
    required int duration,
    required String passcode,
  });
  Future<void> endMeeting(String liveId);
  Future<void> deleteMeeting(String liveId);
  Future<List<Map<String, dynamic>>> fetchWebhookLogs();
}
