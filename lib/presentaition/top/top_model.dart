import 'package:flutter/material.dart';
import 'package:touchdown/domain/category.dart';

class TopModel extends ChangeNotifier {
  bool saveDone = false;
  bool deleteDone = false;

  void initState(Categorys category) {
    print(category.categoryName);
    notifyListeners();
  }

  void changeSaveDone(bool bool) {
    saveDone = bool;
    notifyListeners();
  }

  void changeDeleteDone(bool bool) {
    deleteDone = bool;
    notifyListeners();
  }

  int currentIndex = 0;

  void onTabTapped(int index) async {
    currentIndex = index;

    notifyListeners();
  }
}
