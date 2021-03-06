import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:touchdown/domain/category.dart';
import 'package:touchdown/presentaition/auth/login/login_page.dart';
import 'package:touchdown/presentaition/register_team/register_team_model.dart';
import 'package:touchdown/presentaition/top/top_page.dart';
import 'package:touchdown/utils/dialog_helper.dart';
import 'package:provider/provider.dart';

class RegisterTagPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RegisterTeamTagModel>(
      create: (_) => RegisterTeamTagModel()..initState(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'ð·ã¿ã°ç»é²',
            style: TextStyle(fontSize: 20),
          ),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Consumer<RegisterTeamTagModel>(
          builder: (context, model, child) {
            return !model.loadingDate
                ? model.categoryList.isNotEmpty
                    ? Container(
                        child: Scrollbar(
                          child: ListView(
                            children: friendList(model, context),
                          ),
                        ),
                      )
                    : Center(
                        child: Text('ã¾ãã¯ã¿ã°ãä½æãã¦\nè©¦åã®æç¸¾ãé¸æãè¨é²ããã'),
                      )
                : Center(
                    child: CircularProgressIndicator(
                      color: Colors.redAccent,
                    ),
                  );
          },
        ),
        floatingActionButton: Consumer<RegisterTeamTagModel>(
          builder: (context, model, child) {
            return FloatingActionButton.extended(
              label: Text(
                'ã¿ã°ãä½æ',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.orangeAccent,
              onPressed: () async {
                showAddCategoryDialog(context, model);
              },
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> friendList(RegisterTeamTagModel model, BuildContext context) {
    final friendList = model.categoryList
        .map(
          (category) => Slidable(
            actionExtentRatio: 0.2,
            actionPane: SlidableScrollActionPane(),
            secondaryActions: [
              IconSlideAction(
                caption: 'åé¤',
                color: Colors.red,
                icon: Icons.delete,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('æ¬å½ã«åé¤ãã¾ããï¼'),
                        actions: [
                          TextButton(
                            child: Text('OK'),
                            onPressed: () async {
                              Navigator.pop(context);
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('æ¬å½ã®æ¬å½ã«åé¤ãã¾ããï¼'),
                                    actions: [
                                      TextButton(
                                        child: Text('OK'),
                                        onPressed: () async {
                                          Navigator.pop(context);
                                          await model.deleteCategory(category);
                                          model.getCategory();
                                        },
                                      ),
                                      TextButton(
                                        child: Text('ã­ã£ã³ã»ã«'),
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
                            child: Text('ã­ã£ã³ã»ã«'),
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
            child: InkWell(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TopPage(
                        category: category,
                      ),
                    ),
                    (_) => false);
              },
              child: Column(
                children: [
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  height: 60,
                                  padding: EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Container(
                                      child: Text(
                                        category.categoryName!,
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () async {
                                showEditGameDialog(context, model, category);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 0,
                    thickness: 2,
                    color: Theme.of(context).dividerColor,
                  ),
                ],
              ),
            ),
          ),
        )
        .toList();
    return friendList;
  }

  showAddCategoryDialog(BuildContext context, RegisterTeamTagModel model) {
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
              height: 180,
              width: 300,
              child: Column(
                children: [
                  Container(
                    height: 30,
                    child: Text(
                      'ã¿ã°ãè¿½å ãã',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 250,
                    child: TextField(
                      onChanged: (value) {
                        model.categoryName = value;
                      },
                      decoration: InputDecoration(
                        hintText: 'ã¿ã°',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        child: Text(
                          'ã­ã£ã³ã»ã«',
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      TextButton(
                        child: Text(
                          'è¿½å ',
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () async {
                          if (model.categoryName != "") {
                            Navigator.pop(context);
                            await model.addCategory();
                            await model.getCategory();
                          } else {
                            showAlertDialog(context, 'å¥åãã¦ãã ãã');
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

  showEditGameDialog(
      BuildContext context, RegisterTeamTagModel model, Categorys category) {
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
              height: 180,
              width: 300,
              child: Column(
                children: [
                  Container(
                    height: 30,
                    child: Text(
                      'ç·¨éãã',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 250,
                    child: TextField(
                      onChanged: (value) {
                        model.categoryName = value;
                      },
                      decoration: InputDecoration(
                        hintText: category.categoryName,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        child: Text(
                          'ã­ã£ã³ã»ã«',
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      TextButton(
                        child: Text(
                          'æ´æ°',
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () async {
                          if (model.categoryName != "") {
                            Navigator.pop(context);
                            await model.updateCategory(category);
                            await model.getCategory();
                          } else {
                            showAlertDialog(context, 'å¥åãã¦ãã ãã');
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

  showLoginDialog(BuildContext context, RegisterTeamTagModel model) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('ã­ã°ã¤ã³ãå¿è¦ã§ã'),
          actions: <Widget>[
            TextButton(
              child: Text('ã­ã£ã³ã»ã«'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('OK'),
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
