import 'package:flutter/material.dart';
import 'package:touchdown/domain/category.dart';
import 'package:touchdown/domain/game.dart';
import 'package:touchdown/domain/teams.dart';
import 'package:touchdown/repository/teams_repository.dart';

class InputModel extends ChangeNotifier {
  DateTime? gameDate;
  String opponentName = '';
  final _teamsRepository = TeamsRepository.instance;
  Team? teams;
  List<Game> gameList = [];
  Categorys? _category;
  bool loadingData = false;

  Future initState(Categorys category) async {
    startLoading();
    _category = category;
    teams = await _teamsRepository!.fetch();
    await getGame();
    endLoading();
    notifyListeners();
  }

  Future getGame() async {
    gameList = await _teamsRepository!.getGame(_category!);
    print(gameList);
    notifyListeners();
  }

  Future deleteGame(Game game) async {
    await _teamsRepository!
        .deleteGame(team: teams, category: _category!, game: game);
    print(gameList);
    notifyListeners();
  }

  Future updatgeGame(Game game) async {
    await _teamsRepository!.updateGame(
        gameDate: gameDate!,
        opponentName: opponentName,
        category: _category!,
        game: game);
    print(gameList);
    notifyListeners();
  }

  void clearTextField() {
    gameDate = null;
    opponentName = "";
    notifyListeners();
  }

  void getDate(DateTime dateTime) {
    gameDate = dateTime;
    notifyListeners();
  }

  Future addGame() async {
    await _teamsRepository!.addGame(gameDate!, opponentName, _category!);
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
}
