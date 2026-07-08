import 'package:e_cource/feature/cource/data/model/live_model.dart';
import 'package:e_cource/feature/cource/domain/live_repo.dart';
import 'package:e_cource/feature/settings/domain/model/zoom_account_model.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class LiveUseCase {
  final LiveRepo repo;

  LiveUseCase(this.repo);

  Future<List<ZoomAccountModel>> getZoomAccounts() async {
    return await repo.getZoomAccounts();
  }

  Future<List<LiveModel>> fetchLivesForCourse(String courseId) async {
    return await repo.fetchLivesForCourse(courseId);
  }

  Future<LiveModel> scheduleLive({
    required String courseId,
    required String courseName,
    required String title,
    required ZoomAccountModel zoomAccount,
    required DateTime scheduledAt,
    required int duration,
    required String passcode,
  }) async {
    return await repo.scheduleLive(
      courseId: courseId,
      courseName: courseName,
      title: title,
      zoomAccount: zoomAccount,
      scheduledAt: scheduledAt,
      duration: duration,
      passcode: passcode,
    );
  }

  Future<void> endMeeting(String liveId) async {
    return await repo.endMeeting(liveId);
  }

  Future<void> deleteMeeting(String liveId) async {
    return await repo.deleteMeeting(liveId);
  }

  Future<List<Map<String, dynamic>>> fetchWebhookLogs() async {
    return await repo.fetchWebhookLogs();
  }
}
