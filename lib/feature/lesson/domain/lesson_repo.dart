import 'package:e_cource/feature/lesson/data/model/lesson_model.dart';

abstract class LessonRepo {
  Future<LessonModel> addLesson({required LessonModel model});

  Future<List<LessonModel>> getLesson(String courseId);
}
