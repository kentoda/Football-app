import 'package:flutter/material.dart';
import 'package:touchdown/repository/auth_repository.dart';

class FirstTopModel extends ChangeNotifier {
  int currentIndex = 0;
  final authRepository = AuthRepository.instance;

  void onTabTapped(int index) async {
    currentIndex = index;

    notifyListeners();
  }
}
