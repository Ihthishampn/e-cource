
import 'dart:typed_data';

import 'package:e_cource/feature/cource/data/model/add_main_category_model.dart';

abstract class CourseRepo {
  // add  main category
  Future<void> addMainCategory({required String name,required Uint8List imageFile});
  //get
  Future<List<AddMainCategoryModel>> getCategoryList();
}
