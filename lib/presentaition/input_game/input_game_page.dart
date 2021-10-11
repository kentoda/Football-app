import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:touchdown/domain/category.dart';
import 'package:touchdown/domain/game.dart';
import 'package:touchdown/presentaition/input_game/input_game_model.dart';
import 'player_stats_page.dart';
import 'team_game_page.dart';
import 'package:provider/provider.dart';

class InputGamePage extends StatelessWidget {
  InputGamePage({required this.game, required this.category});
  final Game game;
  final Categorys category;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<InputGameModel>(
      create: (_) => InputGameModel(),
      child: Consumer<InputGameModel>(
        builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                '対 ${game.opponentName} 試合',
                style: TextStyle(fontSize: 20),
              ),
            ),
            body: _topPageBody(context),
          );
        },
      ),
    );
  }

  Widget _topPageBody(BuildContext context) {
    final model = Provider.of<InputGameModel>(context);
    final currentIndex = model.currentIndex;
    return Stack(
      children: <Widget>[
        _tabPage(
          currentIndex,
          0,
          TeamsStatsPage(
            game: game,
            category: category,
          ),
        ),
        _tabPage(
          currentIndex,
          1,
          PlayerStatsPage(
            game: game,
            category: category,
          ),
        ),
      ],
    );
  }

  Widget _tabPage(int currentIndex, int tabIndex, StatelessWidget page) {
    return Visibility(
      visible: currentIndex == tabIndex,
      maintainState: true,
      child: page,
    );
  }
}
