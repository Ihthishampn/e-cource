import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cource/feature/cource/data/model/add_main_category_model.dart';
import 'package:e_cource/feature/cource/domain/course_repo.dart';
import 'package:e_cource/general/core/services/upload_firestore_image_services.dart';
import 'package:e_cource/general/widgets/build_search_keywords.dart';
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
      final imageUrl = await uplodFirebaseImageService(imageFile);
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
}
