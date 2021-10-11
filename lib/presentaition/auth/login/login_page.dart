import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:touchdown/presentaition/auth/signup/signup_page.dart';
import 'package:touchdown/presentaition/first_view/first_top_page.dart';
import 'package:touchdown/policy.dart';
import 'login_model.dart';
import 'package:touchdown/utils/dialog_helper.dart';
import 'package:provider/provider.dart';
import 'package:touchdown/presentaition/auth/forgot_password/forgot_password_page.dart';

class LoginPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginPageModel>(
      create: (_) => LoginPageModel(),
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: Text(
                "ログイン",
              ),
            ),
            body: Consumer<LoginPageModel>(
              builder: (context, model, child) {
                return Form(
                  key: _formKey,
                  child: ListView(
                    children: <Widget>[
                      ConstrainedBox(
                        constraints: BoxConstraints(minWidth: double.infinity),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 32.0, right: 24.0, left: 24.0),
                          child: TextFormField(
                            autofocus: true,
                            textAlignVertical: TextAlignVertical.center,
                            textInputAction: TextInputAction.next,
                            onChanged: (String val) {
                              model.onChangeEmail(val);
                            },
                            style: TextStyle(fontSize: 18.0),
                            keyboardType: TextInputType.emailAddress,
                            cursorColor: Colors.redAccent,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.only(left: 16, right: 16),
                              hintText: "example@touchdown.com",
                              labelText: "メールアドレス",
                              icon: Icon(FontAwesomeIcons.at),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(1),
                                  borderSide: BorderSide(
                                      color: Colors.redAccent, width: 2.0)),
                              // border: OutlineInputBorder(
                              //   borderRadius: BorderRadius.circular(2),
                              // ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) return 'メールアドレスを入力してください';
                              if (!EmailValidator.validate(value))
                                return '正しいメールアドレスを入力しください';

                              return null;
                            },
                          ),
                        ),
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(minWidth: double.infinity),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 32.0, right: 24.0, left: 24.0),
                          child: TextFormField(
                            textAlignVertical: TextAlignVertical.center,
                            onChanged: (String val) {
                              model.onChangePassword(val);
                            },
                            onFieldSubmitted: (password) async {},
                            obscureText: true,
                            textInputAction: TextInputAction.done,
                            style: TextStyle(fontSize: 18.0),
                            cursorColor: Colors.redAccent,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.only(left: 16, right: 16),
                              hintText: "123456",
                              labelText: "パスワード",
                              icon: Icon(FontAwesomeIcons.key),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(2),
                                  borderSide: BorderSide(
                                      color: Colors.redAccent, width: 2.0)),
                              // border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) return 'パスワードを入力してください';
                              if (value.length < 6 || value.length > 20)
                                return 'パスワードは6文字以上20文字以内で入力してください';

                              return null;
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 40.0, left: 40.0, top: 40),
                        child: ConstrainedBox(
                          constraints:
                              const BoxConstraints(minWidth: double.infinity),
                          child: ElevatedButton(
                            child: Text(
                              "ログイン",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.redAccent,
                              padding: EdgeInsets.only(top: 12, bottom: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2),
                                  side: BorderSide(color: Colors.redAccent)),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                model.startLoading();
                                FocusScope.of(context).unfocus();
                                try {
                                  await model.login();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.green,
                                      content: Text(
                                        "ログインしました",
                                        style: TextStyle(fontSize: 18.0),
                                      ),
                                    ),
                                  );
                                  await Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => FirstTopPage(),
                                      ),
                                      (_) => false);
                                } catch (e) {
                                  showAlertDialog(context,
                                      "ログインに失敗しました。メールアドレスとパスワードを確認してください。");
                                } finally {
                                  model.endLoading();
                                }
                              }
                            },
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ForgotPassword(),
                            ),
                          )
                        },
                        child: Text(
                          'パスワードをお忘れですか？',
                          style: TextStyle(fontSize: 15.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 40.0, left: 40.0, top: 40),
                        child: ConstrainedBox(
                          constraints:
                              const BoxConstraints(minWidth: double.infinity),
                          child: ElevatedButton(
                            child: Text(
                              "アカウント作成はコチラ",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.orangeAccent,
                              padding: EdgeInsets.only(top: 12, bottom: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2),
                                  side: BorderSide(color: Colors.orangeAccent)),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignUpPage(),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 100),
                        child: TextButton(
                          onPressed: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserPolicyPage(),
                              ),
                            )
                          },
                          child: Text(
                            '利用規約',
                            style: TextStyle(fontSize: 15.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Consumer<LoginPageModel>(
            builder: (context, model, child) {
              return model.isLoading
                  ? Container(
                      child: Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.redAccent,
                        ),
                      ),
                    )
                  : SizedBox();
            },
          ),
        ],
      ),
    );
  }
}
