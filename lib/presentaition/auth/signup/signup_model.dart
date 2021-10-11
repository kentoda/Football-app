import 'package:flutter/cupertino.dart';
import 'package:touchdown/repository/auth_repository.dart';
import 'package:touchdown/repository/teams_repository.dart';

class SignUpPageModel extends ChangeNotifier {
  final _authRepository = AuthRepository.instance;
  final _userRepository = TeamsRepository.instance;
  String teamName = '';
  String email = '';
  String password = '';
  String? userID;

  bool isLoading = false;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  void onChangedDisplayName(String val) {
    teamName = val;
    notifyListeners();
  }

  void onChangedEmail(String val) {
    email = val;
    notifyListeners();
  }

  void onChangedPassword(String val) {
    password = val;
    notifyListeners();
  }

  Future signUp() async {
    final team = await _authRepository!.signUp(email: email, password: password);
    _userRepository!.registerTeam(
      uid: team!.uid,
      email: team.email,
      displayName: teamName,
    );

    print('登録完了');
  }
}
