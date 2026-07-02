import 'dart:typed_data';
import 'package:e_cource/feature/lesson/data/model/lesson_model.dart';

abstract class LessonRepo {
  Future<LessonModel> addLesson({
    required LessonModel model,
    Uint8List? videoBytes,
    String? fileName,
    void Function(double progress)? onProgress,
  });

  Future<List<LessonModel>> getLesson(String courseId);

  Future<bool> changeIspreView({
    required bool val,
    required String lesssonId,
    required String videoId,
  });
}
