import 'package:flutter/material.dart';
import 'package:sqflitedemo/screen/home_screen.dart';
import 'package:sqflitedemo/screen/login_screen.dart';

// ignore: must_be_immutable
class App extends StatelessWidget {
  static const String login = '/login';
  static const String home = '/home';

  var routes = <String, WidgetBuilder>{
    login: (BuildContext context) => LoginScreen(),
    home: (BuildContext context) => HomeScreen()
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            primarySwatch: Colors.grey,
            visualDensity: VisualDensity.adaptivePlatformDensity),
        home: LoginScreen(),
        routes: routes);
  }
}
