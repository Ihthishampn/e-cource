import 'package:e_cource/feature/exam/data/model/exam_model.dart';
import 'package:e_cource/feature/exam/domain/repo/exam_firebase_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class ExamFirebaseUsecase {
  final ExamFirebaseRepo repo;

  ExamFirebaseUsecase(this.repo);

  Future<ExamModel> addExam({required ExamModel model}) {
    return repo.addExam(model: model);
  }

  Future<List<ExamModel>> getExams({required String courseId, String? moduleId}) {
    return repo.getExams(courseId: courseId, moduleId: moduleId);
  }

  Future<void> updateExamStatus({required String examId, required bool isEnabled}) {
    return repo.updateExamStatus(examId: examId, isEnabled: isEnabled);
  }

  Future<void> deleteExam({required String examId}) {
    return repo.deleteExam(examId: examId);
  }
}
