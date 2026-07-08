import 'dart:developer';
import 'package:e_cource/feature/cource/data/model/live_model.dart';
import 'package:e_cource/feature/cource/data/use_case/live_use_case.dart';
import 'package:e_cource/feature/settings/domain/model/zoom_account_model.dart';
import 'package:e_cource/general/enums/app_state.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:universal_html/html.dart' as html;

@injectable
class LiveProvider with ChangeNotifier {
  final LiveUseCase liveUseCase;

  LiveProvider(this.liveUseCase);

  // States
  AppState fetchState = AppState.initial;
  AppState createLiveState = AppState.initial;
  AppState zoomAccountsState = AppState.initial;
  AppState logsState = AppState.initial;

  List<LiveModel> lives = [];
  List<ZoomAccountModel> zoomAccounts = [];
  List<Map<String, dynamic>> webhookLogs = [];
  String? errorMessage;

  /// Fetch all active Zoom accounts for scheduling selection
  Future<void> fetchZoomAccounts() async {
    zoomAccountsState = AppState.loading;
    notifyListeners();

    try {
      zoomAccounts = await liveUseCase.getZoomAccounts();
      zoomAccountsState = AppState.success;
    } catch (e) {
      log('Error fetching Zoom accounts in LiveProvider: $e');
      zoomAccountsState = AppState.error;
    }
    notifyListeners();
  }

  /// Fetch live meetings for a specific course
  Future<void> fetchLivesForCourse(String courseId) async {
    fetchState = AppState.loading;
    errorMessage = null;
    notifyListeners();

    try {
      lives = await liveUseCase.fetchLivesForCourse(courseId);
      fetchState = AppState.success;
    } catch (e) {
      log('Error fetching lives for course in LiveProvider: $e');
      errorMessage = e.toString();
      fetchState = AppState.error;
    }
    notifyListeners();
  }

  /// Create/Schedule a Live meeting
  Future<bool> scheduleLive({
    required String courseId,
    required String courseName,
    required String title,
    required ZoomAccountModel zoomAccount,
    required DateTime scheduledAt,
    required int duration,
    required String passcode,
  }) async {
    createLiveState = AppState.loading;
    errorMessage = null;
    notifyListeners();

    try {
      final newLive = await liveUseCase.scheduleLive(
        courseId: courseId,
        courseName: courseName,
        title: title,
        zoomAccount: zoomAccount,
        scheduledAt: scheduledAt,
        duration: duration,
        passcode: passcode,
      );

      // Update local state
      lives.insert(0, newLive);
      createLiveState = AppState.success;
      notifyListeners();
      return true;
    } catch (e) {
      log('Error scheduling live meeting in LiveProvider: $e');
      errorMessage = e.toString().replaceFirst('Exception: ', '');
      createLiveState = AppState.error;
      notifyListeners();
      return false;
    }
  }

  /// Launch the host URL to start the meeting in a new browser tab
  void startMeeting(LiveModel live) {
    if (live.startUrl.isNotEmpty) {
      html.window.open(live.startUrl, '_blank');
    }
  }

  /// Mark meeting as completed
  Future<void> endMeeting(String liveId) async {
    try {
      await liveUseCase.endMeeting(liveId);

      // Update local item status
      final index = lives.indexWhere((l) => l.id == liveId);
      if (index != -1) {
        lives[index] = lives[index].copyWith(
          status: 'completed',
          endedAt: DateTime.now(),
        );
      }
      notifyListeners();
    } catch (e) {
      log('Error ending meeting in LiveProvider: $e');
    }
  }

  /// Delete meeting from Firestore
  Future<void> deleteMeeting(String liveId) async {
    try {
      await liveUseCase.deleteMeeting(liveId);
      lives.removeWhere((l) => l.id == liveId);
      notifyListeners();
    } catch (e) {
      log('Error deleting meeting in LiveProvider: $e');
    }
  }

  /// Fetch Zoom webhook logs for visual confirmation
  Future<void> fetchWebhookLogs() async {
    logsState = AppState.loading;
    notifyListeners();

    try {
      webhookLogs = await liveUseCase.fetchWebhookLogs();
      logsState = AppState.success;
    } catch (e) {
      log('Error fetching webhook logs in LiveProvider: $e');
      logsState = AppState.error;
    }
    notifyListeners();
  }
}
