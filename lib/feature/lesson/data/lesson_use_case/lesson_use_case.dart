import 'package:e_cource/feature/lesson/data/model/lesson_model.dart';
import 'package:e_cource/feature/lesson/domain/lesson_repo.dart';
import 'package:injectable/injectable.dart';
@lazySingleton
class LessonUseCase {
  final LessonRepo repo;
  LessonUseCase(this.repo);

  Future<LessonModel> addLesson({required LessonModel model}) async {
    return await repo.addLesson(model: model);
  }
Future<List<LessonModel>> getLesson(String courseId) async {
  return repo.getLesson(courseId);
}
}


