import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:touchdown/domain/category.dart';
import 'package:touchdown/domain/game.dart';
import 'package:touchdown/domain/game_detail.dart';
import 'package:touchdown/utils/dialog_helper.dart';
import 'package:touchdown/utils/show_modal_picker.dart';
import 'package:touchdown/presentaition/input_game/input_game_model.dart';
import 'package:provider/provider.dart';

class TeamsStatsPage extends StatelessWidget {
  TeamsStatsPage({required this.game, required this.category});
  final Game game;
  final Categorys category;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<InputGameModel>(
      create: (_) => InputGameModel()..initGameDetailState(category, game),
      child: Scaffold(
        body: Consumer<InputGameModel>(
          builder: (context, model, child) {
            return !model.loadingData
                ? Container(
                    child: Column(
                      children: [
                        Container(
                          height: 120,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 100,
                                width: 120,
                                child: Center(
                                  child: model.teamName != null
                                      ? Text(
                                          model.teamName!,
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                        )
                                      : SizedBox(),
                                ),
                              ),
                              Container(
                                height: 100,
                                width: 100,
                                child: Center(
                                  child: Text(
                                    'VS',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 100,
                                width: 100,
                                child: Center(
                                  child: Text(
                                    game.opponentName!,
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.deepOrange,
                              ),
                              child: Text('+'),
                              onPressed: () async {
                                showTokutenDialog(context, model);
                                model.initValue();
                              },
                            ),
                            SizedBox(
                              width: 100,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.blueAccent,
                              ),
                              child: Text('＋'),
                              onPressed: () async {
                                showShittenDialog(context, model);
                                model.initValue();
                              },
                            ),
                          ],
                        ),
                        Divider(
                          height: 0,
                          thickness: 1,
                        ),
                        model.gameDetailList.isNotEmpty
                            ? Expanded(
                                child: Container(
                                  child: Scrollbar(
                                    child: ListView(
                                      children: gameDetailList(model, context),
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox(
                                height: 0,
                              ),
                      ],
                    ),
                  )
                : Center(
                    child: CircularProgressIndicator(
                      color: Colors.redAccent,
                    ),
                  );
          },
        ),
      ),
    );
  }

  List<Widget> gameDetailList(InputGameModel model, BuildContext context) {
    final gameDetailList = model.gameDetailList
        .map(
          (gameDetail) => Column(
            children: [
              Container(
                height: 70,
                child: gameDetail.rnrs == '得点'
                    ? Slidable(
                        actionExtentRatio: 0.2,
                        actionPane: SlidableScrollActionPane(),
                        secondaryActions: [
                          IconSlideAction(
                            caption: '削除',
                            color: Colors.red,
                            icon: Icons.delete,
                            onTap: () {
                              _showDeleteDialog(context, model, gameDetail);
                            },
                          ),
                        ],
                        child: Container(
                          height: 70,
                          color: Colors.deepOrange[100],
                          child: Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                child: Text(
                                  gameDetail.tokutenTime!,
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Container(
                                child: Text(
                                  gameDetail.tokutenPlayer!,
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Container(
                                child: Text(
                                  gameDetail.tokutenPattern!,
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Slidable(
                        actionExtentRatio: 0.2,
                        actionPane: SlidableScrollActionPane(),
                        secondaryActions: [
                          IconSlideAction(
                            caption: '削除',
                            color: Colors.red,
                            icon: Icons.delete,
                            onTap: () {
                              _showDeleteDialog(context, model, gameDetail);
                            },
                          ),
                        ],
                        child: Container(
                          height: 70,
                          color: Colors.blue[100],
                          child: Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                child: Text(
                                  gameDetail.shittenTime!,
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Container(
                                child: Text(
                                  gameDetail.shittenPattern!,
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
              Divider(
                height: 0,
                thickness: 2,
                color: Colors.grey,
              ),
            ],
          ),
        )
        .toList();
    return gameDetailList;
  }

  void _showDeleteDialog(
      BuildContext context, InputGameModel model, GameDetail gameDetail) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('本当に削除しますか？'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () async {
                try {
                  await model.deleteDetail(gameDetail);
                  model.getGameDetail();
                } catch (e) {
                  showAlertDialog(context, e.toString());
                } finally {
                  Navigator.of(context).pop();
                }
              },
            ),
            TextButton(
                child: Text('キャンセル'),
                onPressed: () {
                  Navigator.of(context).pop();
                })
          ],
        );
      },
    );
  }

  showTokutenDialog(BuildContext context, InputGameModel model) {
    showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.3),
      transitionDuration: Duration(milliseconds: 100),
      barrierDismissible: true,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation1, animation2) {
        return Container();
      },
      transitionBuilder: (context, animation1, animation2, widget) {
        return Center(
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5), color: Colors.white),
              padding:
                  EdgeInsets.only(right: 10, left: 10, top: 10, bottom: 10),
              height: 260,
              width: 300,
              child: Column(
                children: [
                  Container(
                    height: 30,
                    child: Text(
                      '得点',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 250,
                    child: ElevatedButton(
                      child: Text(
                        '${model.half} ${model.minute} : ${model.second}',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        showModalTimePicker(
                          context,
                          model.minutes,
                          model.seconds,
                          model.halfs,
                          model.onSelectedMinutes,
                          model.onSelectedSeconds,
                          model.onSelectedHalf,
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    width: 250,
                    child: ElevatedButton(
                      child: Text(
                        model.goalPlayer!,
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        showModalSelectPicker(context, model.playerNameList,
                            model.onSelectedPlayers);
                      },
                    ),
                  ),
                  SizedBox(
                    width: 250,
                    child: ElevatedButton(
                      child: Text(
                        model.tokutenPattern!,
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        showModalSelectPicker(context, model.tokutenPatternList,
                            model.onSelectedTokutenPattern);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        child: Text('キャンセル'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      TextButton(
                        child: Text('追加'),
                        onPressed: () async {
                          if (model.goalPlayer != '選手を選ぶ' &&
                              model.tokutenPattern != 'パターンを選ぶ') {
                            Navigator.pop(context);
                            await model.addTokuetenDetail();
                            model.getGameDetail();
                          } else {
                            showAlertDialog(context, '未入力の項目があります');
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

// 失点
  showShittenDialog(BuildContext context, InputGameModel model) {
    showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.3),
      transitionDuration: Duration(milliseconds: 100),
      barrierDismissible: true,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation1, animation2) {
        return Container();
      },
      transitionBuilder: (context, animation1, animation2, widget) {
        return Center(
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5), color: Colors.white),
              padding:
                  EdgeInsets.only(right: 10, left: 10, top: 10, bottom: 10),
              height: 220,
              width: 300,
              child: Column(
                children: [
                  Container(
                    height: 30,
                    child: Text(
                      '失点',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 250,
                    child: ElevatedButton(
                      child: Text(
                        '${model.half} ${model.minute} : ${model.second}',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        showModalTimePicker(
                          context,
                          model.minutes,
                          model.seconds,
                          model.halfs,
                          model.onSelectedMinutes,
                          model.onSelectedSeconds,
                          model.onSelectedHalf,
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    width: 250,
                    child: ElevatedButton(
                      child: Text(
                        model.shittenPattern!,
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        showModalSelectPicker(
                          context,
                          model.shittenPatternList,
                          model.onSelectedShittenPattern,
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        child: Text('キャンセル'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      TextButton(
                        child: Text('追加'),
                        onPressed: () async {
                          if (model.shittenPattern != 'パターンを選ぶ') {
                            Navigator.pop(context);
                            await model.addShittenDetail();
                            model.getGameDetail();
                          } else {
                            showAlertDialog(context, '未入力の項目があります');
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
