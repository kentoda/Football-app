import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:touchdown/presentaition/first_view/first_top_page.dart';
import 'profile_setting_model.dart';
import 'package:provider/provider.dart';

class ProfileSettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProfileSettingModel>(
      create: (_) => ProfileSettingModel()..initState(),
      child: Scaffold(
        body: Consumer<ProfileSettingModel>(
          builder: (context, model, child) {
            return !model.loadingDate
                ? ListView(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      ListTile(
                        title: Text(
                          model.teamName,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('タップしてチーム名を編集'),
                        trailing: Icon(FontAwesomeIcons.userFriends),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('チーム名編集'),
                                content: TextField(
                                  decoration:
                                      InputDecoration(hintText: model.teamName),
                                  onChanged: (value) {
                                    model.editName = value;
                                  },
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('キャンセル'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  TextButton(
                                    child: Text('更新'),
                                    onPressed: () async {
                                      if (model.editName != '') {
                                        await model.editTeamName();
                                        Navigator.pop(context);
                                      } else {
                                        showAlertDialog(context, '入力をしてください');
                                      }
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      Divider(),
                      ListTile(
                        title: Text(
                          'ログアウト',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: Icon(
                          FontAwesomeIcons.running,
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('ログアウトしますか？'),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('キャンセル'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  TextButton(
                                    child: Text('OK'),
                                    onPressed: () async {
                                      await model.logOut();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          backgroundColor: Colors.green,
                                          content: Text(
                                            "ログアウトしました",
                                            style: TextStyle(fontSize: 20.0),
                                          ),
                                        ),
                                      );
                                      await Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                FirstTopPage(),
                                          ),
                                          (_) => false);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      Divider(),
                    ],
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

  void showAlertDialog(BuildContext context, String s) {}
}
