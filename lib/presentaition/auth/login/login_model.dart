import 'package:flutter/cupertino.dart';
import 'package:touchdown/repository/auth_repository.dart';

class LoginPageModel extends ChangeNotifier {
  String email = '';
  String password = '';

  bool isLoading = false;
  final _authRepository = AuthRepository.instance;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  void onChangeEmail(String val) {
    email = val;
    notifyListeners();
  }

  void onChangePassword(String val) {
    password = val;
    notifyListeners();
  }

  Future login() async {
    await _authRepository!.login(email: email, password: password);
  }
}
