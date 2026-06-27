import 'dart:developer';

import 'package:e_cource/feature/cource/data/use_case/course_category_use_case.dart';
import 'package:e_cource/general/enums/app_state.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@injectable
class CourseFirebaseProvider with ChangeNotifier {
  final CourseCategoryUseCase useCase;
  CourseFirebaseProvider(this.useCase);
  AppState addCategoryState = AppState.initial;
  String? addCatgoryerror;

  // add category

  Future<void> handleAddCatrgory({
    required String name,
    required Uint8List imageFile,
  }) async {
    if (addCategoryState == AppState.loading) return;
    addCategoryState = AppState.loading;
    addCatgoryerror = null;
    notifyListeners();
    try {
      await useCase.addMainCategory(name: name, imageFile: imageFile);
      addCategoryState = AppState.success;
      log("add category completed");
    } catch (e) {
      log("error occured while add category : $e");

      addCategoryState = AppState.error;
    }
    notifyListeners();
  }
}
