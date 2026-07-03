import 'dart:developer';
import 'package:e_cource/feature/exam/data/model/exam_model.dart';
import 'package:e_cource/feature/exam/data/usse_case/exam_firebase_usecase.dart';
import 'package:e_cource/general/enums/app_state.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@injectable
class AddExamFirebaseProvider with ChangeNotifier {
  final ExamFirebaseUsecase usecase;
  AddExamFirebaseProvider(this.usecase);

  AppState addExamState = AppState.initial;
  String? addExamError;

  AppState fetchExamState = AppState.initial;
  String? fetchExamError;

  AppState deleteExamState = AppState.initial;
  String? deleteExamError;

  List<ExamModel> examList = [];

  Future<void> handleAddExam({required ExamModel model}) async {
    log("[ExamProvider] handleAddExam: starting execution. State set to loading.");
    if (addExamState == AppState.loading) return;
    addExamState = AppState.loading;
    addExamError = null;
    notifyListeners();

    try {
      final mapPayload = model.toMap();
      log("[ExamProvider] handleAddExam payload to Firestore: $mapPayload");
      
      final res = await usecase.addExam(model: model);
      examList.insert(0, res);
      addExamState = AppState.success;
      log("[ExamProvider] handleAddExam: success. Created examId=${res.examId}");
    } catch (e) {
      log("[ExamProvider] handleAddExam: failed with error: $e");
      addExamState = AppState.error;
      addExamError = e.toString();
    }
    notifyListeners();
  }

  Future<void> handleFetchExams({required String courseId, String? moduleId}) async {
    log("[ExamProvider] handleFetchExams: courseId=$courseId, moduleId=$moduleId");
    if (fetchExamState == AppState.loading) return;
    fetchExamState = AppState.loading;
    fetchExamError = null;
    notifyListeners();

    try {
      examList = await usecase.getExams(courseId: courseId, moduleId: moduleId);
      fetchExamState = AppState.success;
      log("[ExamProvider] handleFetchExams: success. Fetched ${examList.length} exams.");
      for (var exam in examList) {
        log("[ExamProvider] Fetched Exam ID: ${exam.examId}, duration=${exam.duration}m, marks=${exam.totalMarks}, questionsCount=${exam.questions.length}");
      }
    } catch (e) {
      log("[ExamProvider] handleFetchExams: failed with error: $e");
      fetchExamState = AppState.error;
      fetchExamError = e.toString();
    }
    notifyListeners();
  }

  Future<void> handleDeleteExam({required String examId}) async {
    log("[ExamProvider] handleDeleteExam: examId=$examId");
    if (deleteExamState == AppState.loading) return;
    deleteExamState = AppState.loading;
    deleteExamError = null;
    notifyListeners();

    try {
      await usecase.deleteExam(examId: examId);
      examList.removeWhere((e) => e.examId == examId);
      deleteExamState = AppState.success;
      log("[ExamProvider] handleDeleteExam: success for examId=$examId");
    } catch (e) {
      log("[ExamProvider] handleDeleteExam: failed with error: $e");
      deleteExamState = AppState.error;
      deleteExamError = e.toString();
    }
    notifyListeners();
  }

  Future<void> handleToggleExamStatus({required String examId, required bool isEnabled}) async {
    log("[ExamProvider] handleToggleExamStatus: examId=$examId, isEnabled=$isEnabled");
    try {
      await usecase.updateExamStatus(examId: examId, isEnabled: isEnabled);
      final idx = examList.indexWhere((e) => e.examId == examId);
      if (idx != -1) {
        examList[idx] = examList[idx].copyWith(isEnabled: isEnabled);
        log("[ExamProvider] handleToggleExamStatus: local list status updated successfully.");
        notifyListeners();
      }
    } catch (e) {
      log("[ExamProvider] handleToggleExamStatus: failed with error: $e");
    }
  }
}
