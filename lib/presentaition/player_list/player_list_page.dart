import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:touchdown/domain/category.dart';
import 'package:touchdown/domain/player.dart';
import 'package:touchdown/presentaition/player_list/player_list_model.dart';
import 'package:touchdown/utils/show_modal_picker.dart';
import 'package:provider/provider.dart';

class PlayerListPage extends StatelessWidget {
  PlayerListPage({required this.category});

  final Categorys category;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PlayerListModel>(
      create: (_) => PlayerListModel()..initState(category),
      child: Consumer<PlayerListModel>(builder: (context, model, child) {
        return Scaffold(
          body: !model.loadingData
              ? model.playerList.isNotEmpty
                  ? Container(
                      child: Scrollbar(
                        child: ListView(
                          children: playerList(model, context),
                        ),
                      ),
                    )
                  : Center(
                      child: Text('選手を追加しよう'),
                    )
              : Center(
                  child: CircularProgressIndicator(
                    color: Colors.redAccent,
                  ),
                ),
          floatingActionButton: Column(
            verticalDirection: VerticalDirection.up, // childrenの先頭を下に配置
            children: [
              FloatingActionButton.extended(
                backgroundColor: Colors.orangeAccent,
                label: Text(
                  '選手追加',
                  style: TextStyle(color: Colors.white),
                ),
                heroTag: 'hero2',
                onPressed: () async {
                  model.initValue();
                  showPlayerDialog(context, model);
                },
                icon: const Icon(Icons.add, color: Colors.white),
              ),
            ],
          ),
        );
      }),
    );
  }

  List<Widget> playerList(PlayerListModel model, BuildContext context) {
    final playerList = model.playerList
        .map(
          (player) => InkWell(
            child: Slidable(
              actionExtentRatio: 0.2,
              actionPane: SlidableScrollActionPane(),
              secondaryActions: [
                IconSlideAction(
                  caption: '削除',
                  color: Colors.red,
                  icon: Icons.delete,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('本当に削除しますか？'),
                          actions: [
                            TextButton(
                              child: Text('OK'),
                              onPressed: () async {
                                Navigator.of(context).pop();
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('oh...seriously?'),
                                      actions: [
                                        TextButton(
                                          child: Text('OK'),
                                          onPressed: () async {
                                            Navigator.of(context).pop();
                                            await model.deletePlayer(player);
                                            model.getPlayer();
                                          },
                                        ),
                                        TextButton(
                                          child: Text('キャンセル'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        )
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                            TextButton(
                              child: Text('キャンセル'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
              child: Column(
                children: [
                  Container(
                    child: Container(
                      height: 60,
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                child: Text(
                                  player.uniformNumber.toString(),
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                child: Text(
                                  player.playerName!,
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                child: Text(
                                  player.position!,
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () async {
                              model.initValue();
                              showEditDialog(context, model, player);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    height: 0,
                  ),
                ],
              ),
            ),
          ),
        )
        .toList();
    return playerList;
  }

  showPlayerDialog(BuildContext context, PlayerListModel model) {
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
        return Stack(
          children: [
            model.isEnable
                ? Container(
                    width: double.infinity,
                    decoration: new BoxDecoration(
                      color: Color.fromRGBO(0, 0, 0, 0.6),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircularProgressIndicator(
                            valueColor:
                                new AlwaysStoppedAnimation<Color>(Colors.white))
                      ],
                    ),
                  )
                : Container(),
            Center(
              child: Material(
                type: MaterialType.transparency,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white),
                  padding:
                      EdgeInsets.only(right: 10, left: 10, top: 10, bottom: 10),
                  height: 250,
                  width: 300,
                  child: Column(
                    children: [
                      Text('選手'),
                      TextField(
                        onChanged: (value) {
                          model.playerName = value;
                        },
                        decoration: InputDecoration(hintText: "名前"),
                      ),
                      TextField(
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          model.uniformNumber = value;
                        },
                        decoration: InputDecoration(hintText: "背番号"),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: 200,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue, //ボタンの背景色
                          ),
                          child: Text(
                            model.position,
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            showModalSelectPicker(context, model.positionList,
                                model.onSelectedPosition);
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            child: Text(
                              'キャンセル',
                              style: TextStyle(color: Colors.black),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          TextButton(
                            child: Text(
                              '追加',
                              style: TextStyle(color: Colors.black),
                            ),
                            onPressed: () async {
                              if (model.playerName != "" &&
                                  model.uniformNumber != "") {
                                Navigator.pop(context);
                                await model.addPlayer(context);
                                await model.initState(category);
                                model.clearTextField();
                              } else {
                                showAlertDialog(context, '入力してください');
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  showEditDialog(BuildContext context, PlayerListModel model, Player player) {
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
              height: 250,
              width: 300,
              child: Column(
                children: [
                  Text('編集する'),
                  TextField(
                    onChanged: (value) {
                      model.playerName = value;
                    },
                    decoration: InputDecoration(hintText: player.playerName),
                  ),
                  TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      model.uniformNumber = value;
                    },
                    decoration: InputDecoration(
                        hintText: player.uniformNumber.toString()),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue, //ボタンの背景色
                      ),
                      child: Text(
                        model.position,
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        showModalSelectPicker(context, model.positionList,
                            model.onSelectedPosition);
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        child: Text(
                          'キャンセル',
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      TextButton(
                        child: Text(
                          '追加',
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () async {
                          if (model.playerName != "" &&
                              model.uniformNumber != "") {
                            Navigator.pop(context);
                            await model.updatePlayer(player, context);
                            await model.initState(category);
                            model.clearTextField();
                          } else {
                            showAlertDialog(context, '入力してください');
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

  void showAlertDialog(BuildContext context, String s) {}
}
