import 'package:flutter/material.dart';
import 'package:touchdown/domain/teams.dart';
import 'package:touchdown/repository/auth_repository.dart';
import 'package:touchdown/repository/teams_repository.dart';

class ProfileSettingModel extends ChangeNotifier {
  final _teamsRepository = TeamsRepository.instance;
  final _authRepository = AuthRepository.instance;
  Team? team;
  String teamName = '';
  String editName = '';
  bool loadingDate = false;

  Future initState() async {
    startLoading();
    team = await _teamsRepository!.fetch();
    print('${team!.uid} init');
    teamName = team!.teamName!;
    endLoading();
    notifyListeners();
  }

  Future logOut() async {
    await _authRepository!.signOut();
    _teamsRepository!.deleteLocalCache();
    print('ログアウト');
    notifyListeners();
  }

  Future editTeamName() async {
    await _teamsRepository!.updateTeamName(teamName: editName, team: team!);
    print('更新です');
    teamName = editName;
    notifyListeners();
  }

  void startLoading() {
    loadingDate = true;
    notifyListeners();
  }

  void endLoading() {
    loadingDate = false;
    notifyListeners();
  }
}
