import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:touchdown/presentaition/first_view/first_top_page.dart';
import 'package:touchdown/presentaition/auth/forgot_password/forgot_password_model.dart';
import 'package:touchdown/utils/dialog_helper.dart';
import 'package:provider/provider.dart';

class ForgotPassword extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ForgotPageModel>(
      create: (_) => ForgotPageModel(),
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: Text(
                "パスワード再設定",
              ),
            ),
            body: Consumer<ForgotPageModel>(builder: (context, model, child) {
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
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(1),
                                borderSide: BorderSide(
                                    color: Colors.redAccent, width: 2.0)),
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
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 40.0, left: 40.0, top: 40),
                      child: ConstrainedBox(
                        constraints:
                            const BoxConstraints(minWidth: double.infinity),
                        child: ElevatedButton(
                          child: Text(
                            "送信",
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
                                await model.resetPassword();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.green,
                                    content: Text(
                                      "入力されたメールアドレスにパスワード再設定用のメールが送信されました",
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
                                showAlertDialog(
                                    context, "入力されたメールアドレスは登録されていません");
                              } finally {
                                model.endLoading();
                              }
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
          Consumer<ForgotPageModel>(
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
