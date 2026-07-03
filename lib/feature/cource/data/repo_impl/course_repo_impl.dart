import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cource/feature/cource/data/model/add_main_category_model.dart';
import 'package:e_cource/feature/cource/data/model/course_model.dart';
import 'package:e_cource/feature/cource/domain/course_repo.dart';
import 'package:e_cource/general/core/services/upload_firestore_image_services.dart';
import 'package:e_cource/general/widgets/build_search_keywords.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:injectable/injectable.dart';


@LazySingleton(as: CourseRepo)
class CourseRepoImpl implements CourseRepo {
  final FirebaseFirestore firebaseFirestore;
  CourseRepoImpl(this.firebaseFirestore);

  @override
  Future<AddMainCategoryModel> addMainCategory({
    required String name,
    required Uint8List imageFile,
  }) async {
    try {
      final imageUrl = await uplodFirebaseImageCategoryService(imageFile);
      if (imageUrl == null || imageUrl.isEmpty) {
        throw Exception('Image upload failed');
      }
      final DocumentReference doc = firebaseFirestore
          .collection("main_category")
          .doc();
      final keyw = keywordsBuilder(name);
      final category = AddMainCategoryModel(
        id: doc.id,
        name: name,
        image: imageUrl,
        keywords: keyw,
      );

      await doc.set(category.toMap());

      return AddMainCategoryModel(
        id: doc.id,
        name: name,
        image: imageUrl,
        keywords: keyw,
      );
    } on FirebaseException catch (e) {
      log("firebase error while add main category : $e");

      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<AddMainCategoryModel>> getCategoryList() async {
    try {
      final res = await firebaseFirestore.collection("main_category").get();

      return res.docs
          .map((e) => AddMainCategoryModel.fromMap(e.data(), e.id))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<AddMainCategoryModel>> searchCategory({
    required String query,
  }) async {
    try {
      final res = await firebaseFirestore
          .collection("main_category")
          .where('keywords', arrayContains: query.trim().toLowerCase())
          .get();

      return res.docs
          .map((e) => AddMainCategoryModel.fromMap(e.data(), e.id))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<CourseModel> addCourse({
    required CourseModel model,
    required Uint8List imageFile,
  }) async {
    try {
      final imageUrl = await uplodFirebaseImageCourseService(imageFile);
      if (imageUrl == null || imageUrl.isEmpty) {
        throw Exception("image url is empty cant add a course , try again");
      }

      final DocumentReference<Map<String, dynamic>> doc = firebaseFirestore
          .collection("main_course")
          .doc();
      final newCOurse = model.copyWith(id: doc.id, image: imageUrl);

      await doc.set(newCOurse.toMap());

      return newCOurse;
    } catch (e) {
      log("error while add a course :$e");
      rethrow;
    }
  }

  @override
  Future<List<CourseModel>> getCourse() async {
    try {
      final res = await firebaseFirestore.collection("main_course").get();
      return res.docs.map((e) => CourseModel.fromMap(e.data(), e.id)).toList();
    } catch (e) {
      log("error while fetch courses");
      rethrow;
    }
  }

  @override
  Future<List<CourseModel>> searchCourse({required String query}) async {
    try {
      final res = await firebaseFirestore
          .collection("main_course")
          .where("keywords", arrayContains: query)
          .get();

      return res.docs.map((e) => CourseModel.fromMap(e.data(), e.id)).toList();
    } catch (e) {
      log("error while fetch courses");
      rethrow;
    }
  }

  @override
  Future<void> deleteCourse({
    required String courseId,
    required String imageUrl,
  }) async {
    try {
      // 1. Check whether the course has any modules
      final modulesSnapshot = await firebaseFirestore
          .collection("module")
          .where("courseId", isEqualTo: courseId)
          .limit(1)
          .get();

      if (modulesSnapshot.docs.isNotEmpty) {
        throw Exception(
          "This course contains modules. Please delete all modules inside this course before deleting the course.",
        );
      }

      // 2. Delete Firestore document
      await firebaseFirestore.collection("main_course").doc(courseId).delete();

      // 3. Delete image from Firebase Storage
      try {
        final ref = FirebaseStorage.instance.refFromURL(imageUrl);
        await ref.delete();
      } catch (storageErr) {
        // Storage deletion is best-effort; log but don't fail the whole operation
        log("warning: could not delete course image from storage: $storageErr");
      }

      log("course deleted successfully: $courseId");
    } on FirebaseException catch (e) {
      log("firebase error while deleting course: $e");
      rethrow;
    } catch (e) {
      log("error while deleting course: $e");
      rethrow;
    }
  }
}
