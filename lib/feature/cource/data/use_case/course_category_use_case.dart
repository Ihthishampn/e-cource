
import 'dart:typed_data';

import 'package:e_cource/feature/cource/data/model/add_main_category_model.dart';
import 'package:e_cource/feature/cource/domain/course_repo.dart';

import 'package:injectable/injectable.dart';

@lazySingleton
class CourseCategoryUseCase {
  final CourseRepo repo;
  CourseCategoryUseCase(this.repo);

  Future<void> addMainCategory({
    required String name,
    required Uint8List imageFile,
  }) async {
    return await repo.addMainCategory(name: name, imageFile: imageFile);
  }

  @override
  Future<List<AddMainCategoryModel>> getCategoryList() {
    // TODO: implement getCategoryList
    throw UnimplementedError();
  }
}
