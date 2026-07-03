import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cource/feature/exam/data/model/exam_model.dart';
import 'package:e_cource/feature/exam/domain/repo/exam_firebase_repo.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ExamFirebaseRepo)
class ExamFirebaseRepoImpl implements ExamFirebaseRepo {
  final FirebaseFirestore firebaseFirestore;

  ExamFirebaseRepoImpl(this.firebaseFirestore);

  @override
  Future<ExamModel> addExam({required ExamModel model}) async {
    try {
      final doc = firebaseFirestore.collection("exams").doc();
      final newModel = model.copyWith(examId: doc.id);
      await doc.set(newModel.toMap());
      return newModel;
    } catch (e) {
      log("error while adding exam : $e");
      rethrow;
    }
  }

  @override
  Future<List<ExamModel>> getExams({required String courseId, String? moduleId}) async {
    try {
      var query = firebaseFirestore
          .collection("exams")
          .where("courseId", isEqualTo: courseId);

      if (moduleId != null && moduleId.isNotEmpty) {
        query = query.where("moduleId", isEqualTo: moduleId);
      }

      final snapshot = await query.orderBy("createdAt", descending: true).get();

      return snapshot.docs
          .map((doc) => ExamModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      log("error while getting exams : $e");
      rethrow;
    }
  }

  @override
  Future<void> updateExamStatus({required String examId, required bool isEnabled}) async {
    try {
      await firebaseFirestore
          .collection("exams")
          .doc(examId)
          .update({"isEnabled": isEnabled});
    } catch (e) {
      log("error updating exam status : $e");
      rethrow;
    }
  }

  @override
  Future<void> deleteExam({required String examId}) async {
    try {
      await firebaseFirestore.collection("exams").doc(examId).delete();
    } catch (e) {
      log("error deleting exam : $e");
      rethrow;
    }
  }
}
