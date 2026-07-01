import 'dart:developer';

import 'package:e_cource/feature/lesson/data/lesson_use_case/lesson_use_case.dart';
import 'package:e_cource/feature/lesson/data/model/lesson_model.dart';
import 'package:e_cource/general/enums/app_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';

@injectable
class LessonProvider with ChangeNotifier {
  final LessonUseCase useCase;
  LessonProvider(this.useCase);
  AppState addLessonState = AppState.initial;
  AppState updatePreviewState = AppState.initial;
  String? updatePreviewError;
  String? addLessonError;

  List<LessonModel> lessonList = [];

  Future<void> handleAddLesson(LessonModel model) async {
    if (addLessonState == AppState.loading) return;
    addLessonState = AppState.loading;
    addLessonError = null;
    notifyListeners();

    try {
      final res = await useCase.addLesson(model: model);

      lessonList.add(res);

      addLessonState = AppState.success;
    } catch (e) {
      log(
        "error from add,"
        "lesson provider : $e",
      );

      addLessonState = AppState.error;
      addLessonError = "$e";
    }

    notifyListeners();
  }

  AppState getLessonState = AppState.initial;

  Future<void> handleGetLesson(String courseId) async {
    if (getLessonState == AppState.loading) return;

    getLessonState = AppState.loading;
    lessonList.clear();
    notifyListeners();

    try {
      lessonList = await useCase.getLesson(courseId);
      getLessonState = AppState.success;
    } catch (e) {
      getLessonState = AppState.error;
    }

    notifyListeners();
  }

  void clear() {
    lessonList.clear();
    getLessonState = AppState.initial;
    notifyListeners();
  }

Future<bool> handleUpdatePreview({
  required bool val,
  required String lessonId,
  required String videoId,
}) async {
  final lessonIndex = lessonList.indexWhere((l) => l.lessonId == lessonId);

  if (lessonIndex == -1) return false;

  final oldLesson = lessonList[lessonIndex];

  final updatedVideos = oldLesson.videos.map((v) {
    if (v.videoId == videoId) {
      return v.copyWith(isPreview: val);
    }
    return v;
  }).toList();

  lessonList[lessonIndex] = oldLesson.copyWith(videos: updatedVideos);
  notifyListeners();

  try {
    final success = await useCase.changeIsPreviewUsecase(
      val: val,
      lesssonId: lessonId,
      videoId: videoId,
    );

    if (!success) {
      lessonList[lessonIndex] = oldLesson;
      notifyListeners();
      return false;
    }

    return true;
  } catch (e) {
    lessonList[lessonIndex] = oldLesson;
    notifyListeners();

    log("error from change preview provider: $e");
    return false;
  }
}
}
