import 'package:flutter/material.dart';
import 'package:ncmb/ncmb.dart';

// ログイン画面用StatefulWidget
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.onLogin}) : super(key: key);
  final Function onLogin;
  @override
  State<LoginPage> createState() => _LoginPageState();
}

// ログイン画面用State
class _LoginPageState extends State<LoginPage> {
  var _userName = ''; // 入力してもらう表示名
  var _password = ''; // 入力してもらうパスワード

  void _login() async {
    try {
      // ユーザー登録処理
      await NCMBUser.signUpByAccount(_userName, _password);
    } catch (e) {}
    // 成功しても失敗してもそのままログイン処理
    await NCMBUser.login(_userName, _password);
    widget.onLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('ログイン&サインアップ')),
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
            SizedBox(
                height: 100,
                child: Text(
                  'ユーザー名とパスワードを入力してください',
                )),
          ]),
          SizedBox(
              height: 50,
              width: 250,
              child: TextField(
                decoration: const InputDecoration.collapsed(hintText: 'ユーザー名'),
                onChanged: (value) {
                  setState(() {
                    _userName = value;
                  });
                },
              )),
          SizedBox(
            width: 250,
            height: 100,
            child: TextField(
              obscureText: true,
              decoration: const InputDecoration.collapsed(hintText: 'パスワード'),
              onChanged: (value) {
                setState(() {
                  _password = value;
                });
              },
            ),
          ),
          TextButton(onPressed: _login, child: const Text("ログインする"))
        ]));
  }
}
