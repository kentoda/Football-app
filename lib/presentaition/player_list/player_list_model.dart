import 'package:flutter/material.dart';
import 'package:touchdown/domain/category.dart';
import 'package:touchdown/domain/player.dart';
import 'package:touchdown/domain/teams.dart';
import 'package:touchdown/repository/teams_repository.dart';

class PlayerListModel extends ChangeNotifier {
  final _teamsRepository = TeamsRepository.instance;
  List<Player> playerList = [];
  Team? team;
  late Categorys category;
  String? uniformNumber = "";
  String playerName = "";
  String position = 'QB';
  List<String> positionList = ['QB', 'OL', 'RB', 'WR', 'TE'];
  bool loadingData = false;
  bool isEnable = true;

  Future initState(Categorys category) async {
    startLoading();
    this.category = category;
    team = await _teamsRepository!.fetch();
    print(team!.uid);
    playerList = await _teamsRepository!.getPlayer(category);
    print(playerList);
    initValue();
    endLoading();
    notifyListeners();
  }

  Future getPlayer() async {
    playerList = await _teamsRepository!.getPlayer(category);

    notifyListeners();
  }

  void startLoading() {
    loadingData = true;
    notifyListeners();
  }

  void endLoading() {
    loadingData = false;
    notifyListeners();
  }

  void initValue() {
    position = 'QB';
    playerName = '';
    uniformNumber = '';
    notifyListeners();
  }

  void onSelectedPosition(int index) {
    position = positionList[index];
    notifyListeners();
  }

  void clearTextField() {
    uniformNumber = null;
    playerName = '';
    notifyListeners();
  }

  Future addPlayer(BuildContext context) async {
    try {
      final number = int.parse(uniformNumber!);
      await _teamsRepository!.addPlayer(number, playerName, position, category);
    } catch (e) {
      showAlertDialog(context, '数字を入力してください');
    }
    notifyListeners();
  }

  Future deletePlayer(Player player) async {
    await _teamsRepository!
        .deletePlayer(team: team!, category: category, player: player);
    notifyListeners();
  }

  Future updatePlayer(Player player, BuildContext context) async {
    try {
      final number = int.parse(uniformNumber!);
      await _teamsRepository!.updatePlayer(
          uniformNumber: number,
          playerName: playerName,
          position: position,
          category: category,
          player: player);
    } catch (e) {
      showAlertDialog(context, '数字を入力してください');
    }
    notifyListeners();
  }

  void enablePush() {
    isEnable = true;
    notifyListeners();
  }

  void disablePush() {
    isEnable = false;
    notifyListeners();
  }

  void showAlertDialog(BuildContext context, String s) {}
}
