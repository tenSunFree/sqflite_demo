import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflitedemo/common/app.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isAlreadyLogged();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(children: <Widget>[
          Image.asset("assets/icon_login.png"),
          Column(children: <Widget>[
            Expanded(flex: 60, child: SizedBox()),
            buildEmailExpanded(),
            Expanded(flex: 10, child: SizedBox()),
            buildPasswordExpanded(),
            Expanded(flex: 23, child: SizedBox()),
            buildLoginExpanded(),
            Expanded(flex: 99, child: SizedBox())
          ])
        ]));
  }

  Expanded buildEmailExpanded() {
    return Expanded(
        flex: 18,
        child: Container(
            margin: EdgeInsets.only(left: 70),
            child: TextField(
                cursorColor: Colors.black,
                decoration: InputDecoration(border: InputBorder.none),
                controller: emailController)));
  }

  Expanded buildPasswordExpanded() {
    return Expanded(
        flex: 18,
        child: Container(
            margin: EdgeInsets.only(left: 70),
            child: TextField(
                cursorColor: Colors.black,
                decoration: InputDecoration(border: InputBorder.none),
                controller: passwordController)));
  }

  Expanded buildLoginExpanded() {
    return Expanded(
        flex: 20,
        child: GestureDetector(onTap: () {
          String correctEmail = 'abc@gmail.com';
          String correctPassword = '123';
          if (correctEmail == emailController.text &&
              correctPassword == passwordController.text) {
            save(correctEmail, correctPassword);
          } else {
            Fluttertoast.showToast(
                msg: "信箱或密碼輸入錯誤",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER);
          }
        }));
  }

  Future<void> isAlreadyLogged() async {
    var path = 'login.db';
    var db = await openDatabase(path);
    try {
      var list = await db.rawQuery('SELECT name FROM sqlite_master');
      if (list.length == 1) {
        var batch = db.batch();
        batch.execute(
            'CREATE TABLE AlreadyLogged (id INTEGER PRIMARY KEY, email TEXT, password TEXT)');
        await batch.commit();
      }
      var result = await db.query('AlreadyLogged');
      if (result.isNotEmpty) Navigator.of(context).pushNamed(App.home);
    } finally {
      await db?.close();
    }
  }

  Future<void> save(String email, String password) async {
    var path = 'login.db';
    var db = await openDatabase(path);
    try {
      var batch = db.batch();
      batch.rawInsert('INSERT INTO AlreadyLogged (email) VALUES (?)', [email]);
      batch.rawInsert(
          'INSERT INTO AlreadyLogged (password) VALUES (?)', [password]);
      await batch.commit();
      Navigator.of(context).pushNamed(App.home);
    } finally {
      await db?.close();
    }
  }
}
