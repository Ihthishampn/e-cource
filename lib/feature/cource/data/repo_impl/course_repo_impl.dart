import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cource/feature/cource/data/model/add_main_category_model.dart';
import 'package:e_cource/feature/cource/domain/course_repo.dart';
import 'package:e_cource/general/core/services/upload_firestore_image_services.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: CourseRepo)
class CourseRepoImpl implements CourseRepo {
  
  final FirebaseFirestore firebaseFirestore;
  CourseRepoImpl(this.firebaseFirestore);


  @override
  Future<void> addMainCategory({required String name,required Uint8List imageFile})async {
try {
      final imageUrl = await uplodFirebaseImageService(imageFile);

      final DocumentReference doc = firebaseFirestore
          .collection("main_category")
          .doc();
      if (imageUrl != null && imageUrl.isNotEmpty) {
        final category = AddMainCategoryModel(
          id: doc.id,
          name: name,
          image: imageUrl,
        );

        await doc.set(category.toMap());
      }
    } on FirebaseException catch (e) {
      log("firebase error while add main category : $e");
    } catch (e) {
      rethrow;
    }
  }


  @override
  Future<List<AddMainCategoryModel>> getCategoryList() {
    // TODO: implement getCategoryList
    throw UnimplementedError();
  }
  
}
