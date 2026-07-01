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
}
