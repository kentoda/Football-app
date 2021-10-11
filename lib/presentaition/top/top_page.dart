import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:touchdown/domain/category.dart';
import 'package:touchdown/presentaition/paint/drawer_screen.dart';
import 'package:touchdown/presentaition/paint/brush_model.dart';
import 'package:touchdown/presentaition/paint/strokes_model.dart';
import 'package:touchdown/presentaition/profile/profile_setting_page.dart';
import 'package:touchdown/presentaition/register_team/register_team_page.dart';
import 'input_page.dart';
import 'package:touchdown/presentaition/player_list/player_list_page.dart';
import 'package:touchdown/presentaition/top/top_model.dart';
import 'package:provider/provider.dart';

class TopPage extends StatelessWidget {
  TopPage({required this.category});
  final Categorys category;

  final List<String> _tabNames = [
    "試合",
    "選手",
    "ハドル",
    "マイページ",
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TopModel>(
      create: (_) => TopModel()..initState(category),
      child: Consumer<TopModel>(
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
                    icon: Icon(
                      FontAwesomeIcons.footballBall,
                    ),
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
                  BottomNavigationBarItem(
                    icon: Icon(FontAwesomeIcons.userCog),
                    label: _tabNames[3],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _topPageBody(BuildContext context, TopModel model) {
    final currentIndex = model.currentIndex;
    return Stack(
      children: <Widget>[
        _tabPage(
          currentIndex,
          0,
          Container(
            child: Scaffold(
              appBar: AppBar(
                actions: [
                  IconButton(
                    icon: const Icon(Icons.dehaze),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                RegisterTagPage(),
                            fullscreenDialog: true),
                      );
                    },
                  ),
                ],
                centerTitle: true,
                title: Text(
                  category.categoryName!,
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
              body: InputPage(
                category: category,
              ),
            ),
          ),
        ),
        _tabPage(
          currentIndex,
          1,
          Container(
            child: Scaffold(
              appBar: AppBar(
                actions: [
                  IconButton(
                    icon: const Icon(Icons.dehaze),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                RegisterTagPage(),
                            fullscreenDialog: true),
                      );
                    },
                  ),
                ],
                centerTitle: true,
                title: Text(
                  category.categoryName!,
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
              body: PlayerListPage(
                category: category,
              ),
            ),
          ),
        ),
        _tabPage(
            currentIndex,
            2,
            MultiProvider(providers: [
              ChangeNotifierProvider(
                create: (BuildContext context) => BrushModel(),
              ),
              ChangeNotifierProvider(
                create: (BuildContext context) => StrokesModel(),
              ),
            ], child: DrawerScreen())),
        _tabPage(
          currentIndex,
          3,
          Container(
            child: Scaffold(
              appBar: AppBar(
                actions: [
                  IconButton(
                    icon: const Icon(Icons.dehaze),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                RegisterTagPage(),
                            fullscreenDialog: true),
                      );
                    },
                  ),
                ],
                centerTitle: true,
                title: Text(
                  "マイページ",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
              body: ProfileSettingPage(),
            ),
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
