import 'package:flutter/cupertino.dart';
import 'package:touchdown/repository/auth_repository.dart';

class ForgotPageModel extends ChangeNotifier {
  String email = '';

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

  Future resetPassword() async {
    await _authRepository!.resetPassword(email: email);
  }
}
