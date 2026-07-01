import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cource/feature/lesson/data/model/lesson_model.dart';
import 'package:e_cource/feature/lesson/domain/lesson_repo.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: LessonRepo)
class LessonRepoImpl implements LessonRepo {
  final FirebaseFirestore firebaseFirestore;
  LessonRepoImpl(this.firebaseFirestore);

  @override
  Future<LessonModel> addLesson({required LessonModel model}) async {
    try {

      // take bunny vdo here and erturn needed things...




      // .....................//
      final DocumentReference doc = firebaseFirestore
          .collection("lessons")
          .doc();

      final newLesson = model.copyWith(lessonId: doc.id);

      await doc.set(newLesson.toMap());

      return newLesson;
    } catch (e) {
      log("error while add lesson $e");

      rethrow;
    }
  }

@override
Future<List<LessonModel>> getLesson(String courseId) async {
  try {
    final res = await firebaseFirestore
        .collection("lessons")
        .where("courseId", isEqualTo: courseId)
        .orderBy("createdAt")
        .get();

    return res.docs
        .map((e) => LessonModel.fromMap(e.data(), e.id))
        .toList();
  } catch (e) {
    log("error while get lessons $e");
    rethrow;
  }
}
}
