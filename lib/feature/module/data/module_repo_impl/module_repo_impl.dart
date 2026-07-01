import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cource/feature/module/data/model/module_model.dart';
import 'package:e_cource/feature/module/domain/module_repo.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ModuleRepo)
class ModuleRepoImpl implements ModuleRepo {
  final FirebaseFirestore firestore;

  ModuleRepoImpl(this.firestore);

  @override
  Future<ModuleModel> addModule({
    required ModuleModel model,
  }) async {
    try {
      final doc = firestore.collection("module").doc();

      final newModel = model.copyWith(
        moduleId: doc.id,
      );

      await doc.set(newModel.toMap());

      return newModel;
    } catch (e) {
      log("error while adding module : $e");
      rethrow;
    }
  }

  @override
  Future<List<ModuleModel>> getModules(String courseId) async {
    try {
      final snapshot = await firestore
          .collection("module")
          .where("courseId", isEqualTo: courseId)
          .orderBy("createdAt")
          .get();

      return snapshot.docs
          .map(
            (doc) => ModuleModel.fromMap(
              doc.data(),
              doc.id,
            ),
          )
          .toList();
    } catch (e) {
      log("error while fetching modules : $e");
      rethrow;
    }
  }
}