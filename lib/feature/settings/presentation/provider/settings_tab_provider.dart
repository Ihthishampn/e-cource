import 'package:flutter/material.dart';

class SettingsTabProvider with ChangeNotifier {
  int selctedIndex = 0;





  void changeIndexSettings(int index) {
    selctedIndex = index;
    notifyListeners();
  }
}
