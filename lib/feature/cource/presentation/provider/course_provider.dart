import 'package:e_cource/feature/cource/data/model/add_main_category_model.dart';
import 'package:flutter/material.dart';

class CourseProvider extends ChangeNotifier {
  int _selectedTabIndex = 0;
  int get selectedTabIndex => _selectedTabIndex;

  void setTabIndex(int index) {
    _selectedTabIndex = index;
    notifyListeners();
  }

  final List<String> _tags = [];
  List<String> get tags => _tags;

  void addTag(String tag) {
    final trimmed = tag.trim();
    if (trimmed.isNotEmpty && !_tags.contains(trimmed)) {
      _tags.add(trimmed);
      notifyListeners();
    }
  }

  void removeTag(String tag) {
    _tags.remove(tag);
    notifyListeners();
  }

  void clearTags() {
    _tags.clear();
    notifyListeners();
  }

  // --- Selected Category ---
  AddMainCategoryModel? _selectedCategory;
  AddMainCategoryModel? get selectedCategory => _selectedCategory;

  void setSelectedCategory(AddMainCategoryModel category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void clearSelectedCategory() {
    _selectedCategory = null;
    notifyListeners();
  }

  // --- Radio toggles ---
  bool _hasLiveClasses = true;
  bool get hasLiveClasses => _hasLiveClasses;

  bool _hasStudyMaterials = false;
  bool get hasStudyMaterials => _hasStudyMaterials;

  bool _availableOnPC = false;
  bool get availableOnPC => _availableOnPC;

  bool _isPopular = false;
  bool get isPopular => _isPopular;

  bool _listOnIOS = false;
  bool get listOnIOS => _listOnIOS;

  bool _isLifeLong = true;
  bool get isLifeLong => _isLifeLong;

  void toggleLiveClasses(bool val) {
    _hasLiveClasses = val;
    notifyListeners();
  }

  void toggleStudyMaterials(bool val) {
    _hasStudyMaterials = val;
    notifyListeners();
  }

  void toggleAvailableOnPC(bool val) {
    _availableOnPC = val;
    notifyListeners();
  }

  void togglePopular(bool val) {
    _isPopular = val;
    notifyListeners();
  }

  void toggleListOnIOS(bool val) {
    _listOnIOS = val;
    notifyListeners();
  }

  void toggleLifeLong(bool val) {
    _isLifeLong = val;
    notifyListeners();
  }
}
