import 'dart:typed_data';

import 'package:e_cource/feature/cource/data/model/add_main_category_model.dart';
import 'package:e_cource/feature/cource/data/model/course_model.dart';
import 'package:e_cource/feature/cource/domain/course_repo.dart';

import 'package:injectable/injectable.dart';

@lazySingleton
class CourseCategoryUseCase {
  final CourseRepo repo;
  CourseCategoryUseCase(this.repo);
// add main category ----------------- //

//add
  Future<AddMainCategoryModel> addMainCategory({
    required String name,
    required Uint8List imageFile,
  }) async {
    return await repo.addMainCategory(name: name, imageFile: imageFile);
  }
  // get

  Future<List<AddMainCategoryModel>> getCategoryList() async {
    return await repo.getCategoryList();
  }
// search category
  Future<List<AddMainCategoryModel>> searchCategoryList({
    required String q,
  }) async {
    return await repo.searchCategory(query: q);
  }
//    course seccionn ---------------//  
// add
  Future<CourseModel> addCourse({required CourseModel model,required  Uint8List imageFile}) async {
    return await repo.addCourse(model: model,imageFile: imageFile);
  }



  // get




}
