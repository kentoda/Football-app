import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:touchdown/presentaition/auth/login/login_page.dart';
import 'package:touchdown/presentaition/paint/drawer_screen.dart';
import 'package:touchdown/presentaition/paint/brush_model.dart';
import 'package:touchdown/presentaition/paint/strokes_model.dart';

import 'first_top_model.dart';
import 'package:touchdown/presentaition/register_team/register_team_page.dart';
import 'package:provider/provider.dart';

class FirstTopPage extends StatelessWidget {
  final List<String> _tabNames = ["試合", "選手", "ハドル"];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FirstTopModel>(
      create: (_) => FirstTopModel(),
      child: Consumer<FirstTopModel>(
        builder: (context, model, child) {
          return Scaffold(
            body: _topPageBody(context, model),
            bottomNavigationBar: SizedBox(
              child: BottomNavigationBar(
                selectedItemColor: Colors.redAccent,
                onTap: model.onTabTapped,
                currentIndex: model.currentIndex,
                type: BottomNavigationBarType.fixed,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(FontAwesomeIcons.footballBall),
                    label: _tabNames[0],
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(FontAwesomeIcons.users),
                    label: _tabNames[1],
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(FontAwesomeIcons.clipboard),
                    label: _tabNames[2],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _topPageBody(BuildContext context, FirstTopModel model) {
    final currentIndex = model.currentIndex;

    return Stack(
      children: <Widget>[
        _tabPage(
          currentIndex,
          0,
          Container(
            child: Scaffold(
              appBar: AppBar(
                title: Text("試合"),
              ),
              body: Container(
                decoration: new BoxDecoration(
                  image: new DecorationImage(
                    image: new AssetImage('images/view.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                  child: Text("試合を記録しよう"),
                ),
              ),
              floatingActionButton: Column(
                verticalDirection: VerticalDirection.up,
                children: [
                  FloatingActionButton.extended(
                    backgroundColor: Colors.orangeAccent,
                    label: Text(
                      '試合追加',
                      style: TextStyle(color: Colors.white),
                    ),
                    heroTag: 'hero1',
                    onPressed: () async {
                      if (model.authRepository!.isLogin) {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterTagPage(),
                          ),
                        );
                      } else {
                        showLoginDialog(context);
                      }
                    },
                    icon: const Icon(Icons.add, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
        _tabPage(
          currentIndex,
          2,
          MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (BuildContext context) => BrushModel(),
              ),
              ChangeNotifierProvider(
                create: (BuildContext context) => StrokesModel(),
              ),
            ],
            child: DrawerScreen(),
          ),
        ),
        _tabPage(
          currentIndex,
          1,
          Container(
            child: Scaffold(
              appBar: AppBar(
                title: Text("選手"),
              ),
              body: Container(
                decoration: new BoxDecoration(
                  image: new DecorationImage(
                    image: new AssetImage('images/player.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                  child: Text("選手を追加しよう"),
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
                    heroTag: 'hero3',
                    onPressed: () async {
                      if (model.authRepository!.isLogin) {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterTagPage(),
                          ),
                        );
                      } else {
                        showLoginDialog(context);
                      }
                    },
                    icon: const Icon(Icons.add, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  showCategoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('カテゴリーが未選択です'),
          actions: <Widget>[
            TextButton(
              child: Text('キャンセル'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('選択'),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegisterTagPage(),
                  ),
                );
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _tabPage(int currentIndex, int tabIndex, StatelessWidget page) {
    return Visibility(
      visible: currentIndex == tabIndex,
      maintainState: true,
      child: page,
    );
  }

  showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('ログインが必要です'),
          actions: <Widget>[
            TextButton(
              child: Text('キャンセル'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('ログイン'),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
