import 'package:flutter/material.dart';
import 'package:touchdown/domain/category.dart';
import 'package:touchdown/domain/teams.dart';
import 'package:touchdown/repository/teams_repository.dart';

class RegisterTeamTagModel extends ChangeNotifier {
  final _teamsRepository = TeamsRepository.instance;
  List<Categorys> categoryList = [];
  Team? team;
  String categoryName = '';
  bool loadingDate = false;

  Future initState() async {
    startLoading();

    team = await _teamsRepository!.fetch();
    print(team!.uid);
    await getCategory();
    endLoading();
    notifyListeners();
  }

  Future getCategory() async {
    categoryList = await _teamsRepository!.getCategory();
    print(categoryList);
    notifyListeners();
  }

  void initValue() {
    categoryName = '';
    notifyListeners();
  }

  Future addCategory() async {
    _teamsRepository!.addCategory(categoryName, team!);
    notifyListeners();
  }

  Future deleteCategory(Categorys category) async {
    _teamsRepository!.deleteCategory(team: team!, category: category);
    notifyListeners();
  }

  Future updateCategory(Categorys category) async {
    _teamsRepository!.updateCategory(
        categoryName: categoryName, team: team!, category: category);
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
