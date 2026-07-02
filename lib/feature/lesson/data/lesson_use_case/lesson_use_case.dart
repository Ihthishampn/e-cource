import 'package:e_cource/feature/lesson/data/model/lesson_model.dart';
import 'package:e_cource/feature/lesson/domain/lesson_repo.dart';
import 'package:injectable/injectable.dart';
import 'dart:typed_data';

@lazySingleton
class LessonUseCase {
  final LessonRepo repo;
  LessonUseCase(this.repo);

  Future<LessonModel> addLesson({
    required LessonModel model,
    Uint8List? videoBytes,
    String? fileName,
    void Function(double progress)? onProgress,
  }) async {
    return await repo.addLesson(
      model: model,
      videoBytes: videoBytes,
      fileName: fileName,
      onProgress: onProgress,
    );
  }

  Future<List<LessonModel>> getLesson(String courseId) async {
    return repo.getLesson(courseId);
  }

  Future<bool> changeIsPreviewUsecase({
    required bool val,
    required String lesssonId,
    required String videoId,
  }) async {
    return await repo.changeIspreView(
      val: val,
      lesssonId: lesssonId,
      videoId: videoId,
    );
  }
}
