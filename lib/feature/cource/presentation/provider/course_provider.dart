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
}
