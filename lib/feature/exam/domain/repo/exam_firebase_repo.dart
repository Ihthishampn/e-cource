import 'package:e_cource/feature/exam/data/model/exam_model.dart';

abstract class ExamFirebaseRepo {
  Future<ExamModel> addExam({required ExamModel model});
  Future<List<ExamModel>> getExams({required String courseId, String? moduleId});
  Future<void> updateExamStatus({required String examId, required bool isEnabled});
  Future<void> deleteExam({required String examId});
}