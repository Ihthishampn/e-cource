import 'dart:developer';

import 'package:e_cource/feature/cource/data/model/add_main_category_model.dart';
import 'package:e_cource/feature/cource/data/model/course_model.dart';
import 'package:e_cource/feature/cource/data/use_case/course_category_use_case.dart';
import 'package:e_cource/general/enums/app_state.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@injectable
class CourseFirebaseProvider with ChangeNotifier {
  final CourseCategoryUseCase useCase;
  CourseFirebaseProvider(this.useCase);

  // category state
  AppState addCategoryState = AppState.initial;
  AppState getCategoryState = AppState.initial;
  AppState searchCategoryState = AppState.initial;
  // category error
  String? addCatgoryerror;
  String? getCatgoryerror;
  String? searchCatgoryerror;
  // course state
  AppState addCourseState = AppState.initial;
  AppState fetchCourseState = AppState.initial;
  // delete course state
  AppState deleteCourseState = AppState.initial;
  String? deleteCourseError;
  // course error
  String? addCourseerror;
  String? fetchCourseerror;
  // main category list
  List<AddMainCategoryModel> mcList = [];
  List<AddMainCategoryModel> searchList = [];
  List<CourseModel> courseList = [];
  List<CourseModel> searchCourseList = [];

  // search course
  String searchQuery = "";
  AppState searchCourseState = AppState.initial;
  Future<void> handleSearchcourse({required String query}) async {
    searchQuery = query.trim();

    if (searchQuery.isEmpty) {
      searchCourseList.clear();
      searchCourseState = AppState.initial;
      notifyListeners();
      return;
    }

    searchCourseState = AppState.loading;
    notifyListeners();

    try {
      searchCourseList = await useCase.searchCOurse(
        query: searchQuery.toLowerCase(),
      );

      searchCourseState = AppState.success;
    } catch (e) {
      searchCourseList.clear();
      searchCourseState = AppState.error;
    }

    notifyListeners();
  }
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

  // ------------- course  seccion -------------------//

  // add

  Future<void> handleAddCourse({
    required CourseModel model,
    required Uint8List imageFile,
  }) async {
    if (addCourseState == AppState.loading) return;
    addCourseState = AppState.loading;
    addCourseerror = null;
    notifyListeners();
    try {
      final CourseModel res = await useCase.addCourse(
        model: model,
        imageFile: imageFile,
      );

      courseList.add(res);
      addCourseState = AppState.success;
    } catch (e) {
      log("error while add course provider file : $e");
      addCourseState = AppState.error;
    }
    notifyListeners();
  }

  // get

  Future<void> handleFetchCourse() async {
    if (fetchCourseState == AppState.loading) return;

    fetchCourseState = AppState.loading;

    fetchCourseerror = null;

    notifyListeners();

    try {
      courseList.clear();
      final res = await useCase.getCourse();

      courseList = res;
    } catch (e) {
      log("error while get course provider file : $e");
      addCourseState = AppState.error;
      fetchCourseerror = e.toString();
    }
    notifyListeners();
  }

  // delete

  /// Returns `null` on success, or a user-visible error/info message on failure.
  Future<String?> handleDeleteCourse(CourseModel course) async {
    if (deleteCourseState == AppState.loading) return null;
    deleteCourseState = AppState.loading;
    deleteCourseError = null;
    notifyListeners();

    try {
      await useCase.deleteCourse(
        courseId: course.id,
        imageUrl: course.image,
      );

      // Remove from local list immediately so the UI updates
      courseList.removeWhere((c) => c.id == course.id);
      searchCourseList.removeWhere((c) => c.id == course.id);

      deleteCourseState = AppState.success;
      notifyListeners();
      return null; // success — no error message
    } catch (e) {
      log("error while deleting course in provider: $e");
      deleteCourseError = e.toString();
      deleteCourseState = AppState.error;
      notifyListeners();
      // Return the exception message so the UI can display it
      return e.toString().replaceFirst("Exception: ", "");
    }
  }
}

