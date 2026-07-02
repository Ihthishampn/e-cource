import 'dart:typed_data';

import 'package:e_cource/feature/cource/data/model/add_main_category_model.dart';
import 'package:e_cource/feature/cource/data/model/course_model.dart';

abstract class CourseRepo {
  // main category
  // add
  Future<AddMainCategoryModel> addMainCategory({
    required String name,
    required Uint8List imageFile,
  });
  //get
  Future<List<AddMainCategoryModel>> getCategoryList();
  // search
  Future<List<AddMainCategoryModel>> searchCategory({required String query});

  // add a course repo start here //
  Future<CourseModel> addCourse({
    required CourseModel model,
    required Uint8List imageFile,
  });

  // get
  Future<List<CourseModel>> getCourse();

  // search a course

  Future<List<CourseModel>> searchCourse({required String query});
}
