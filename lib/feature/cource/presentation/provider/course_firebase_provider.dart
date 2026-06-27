import 'dart:developer';

import 'package:e_cource/feature/cource/data/model/add_main_category_model.dart';
import 'package:e_cource/feature/cource/data/use_case/course_category_use_case.dart';
import 'package:e_cource/general/enums/app_state.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@injectable
class CourseFirebaseProvider with ChangeNotifier {
  final CourseCategoryUseCase useCase;
  CourseFirebaseProvider(this.useCase);
  AppState addCategoryState = AppState.initial;
  AppState getCategoryState = AppState.initial;
  AppState searchCategoryState = AppState.initial;
  String? addCatgoryerror;
  String? getCatgoryerror;
  String? searchCatgoryerror;
  // main category list
  List<AddMainCategoryModel> mcList = [];
  List<AddMainCategoryModel> searchList = [];

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
      final res = await useCase.addMainCategory(
        name: name,
        imageFile: imageFile,
      );
      mcList.add(res);
      addCategoryState = AppState.success;

      log("add category completed");
    } catch (e) {
      log("error occured while add category : $e");

      addCategoryState = AppState.error;
    }
    notifyListeners();
  }

  // get

  Future<void> handleFetchMainCategory() async {
    if (getCategoryState == AppState.loading) return;
    getCategoryState = AppState.loading;
    getCatgoryerror = null;
    notifyListeners();
    try {
      mcList.clear();
      final res = await useCase.getCategoryList();
      mcList = res;
      getCategoryState = AppState.success;
      log("fetch complted : main category");
    } catch (e) {
      log("fetch error : main category : $e");
      getCategoryState = AppState.error;
    }
    notifyListeners();
  }

  Future<void> handleSearchCat({required String q}) async {
    if (searchCategoryState == AppState.loading) return;
    searchCategoryState = AppState.loading;
    searchCatgoryerror = null;
    notifyListeners();

    try {
      final res = await useCase.searchCategoryList(q: q);
      searchList = res;
      searchCategoryState = AppState.success;
      log("search runned complete");
    } catch (e) {
      searchCategoryState = AppState.error;
      log("erro while search category : $e");
    }
    notifyListeners();
  }

  void clearSearch() {
  searchList.clear();
  searchCategoryState = AppState.initial;
  notifyListeners();
}
}
