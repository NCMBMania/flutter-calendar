import 'dart:html';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ncmb/ncmb.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import './login_page.dart';
import './calendar_page.dart';

void main() async {
  NCMB('9170ffcb91da1bbe0eff808a967e12ce081ae9e3262ad3e5c3cac0d9e54ad941',
      '9e5014cd2d76a73b4596deffdc6ec4028cfc1373529325f8e71b7a6ed553157d');
  await initializeDateFormatting("ja");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'カレンダー',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isLogin = false;

  void _onLogin() async {
    var login = await NCMBUser.currentUser();
    setState(() {
      _isLogin = login != null;
    });
  }

  @override
  void initState() {
    super.initState();
    _onLogin();
  }

  @override
  Widget build(BuildContext context) {
    return _isLogin ? const CalendarPage() : LoginPage(onLogin: _onLogin);
  }
}
