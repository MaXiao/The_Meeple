import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:the_meeple/screens/home.dart';
import 'package:the_meeple/utils/MeepleColors.dart';

void main() => runApp(new MyApp());

final RouteObserver<PageRoute> routeObserver = new RouteObserver<PageRoute>();

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Meeple',
      navigatorObservers: <NavigatorObserver>[routeObserver],
      theme: ThemeData(
        fontFamily: "Manrope",
        scaffoldBackgroundColor: Colors.white,
        backgroundColor: Colors.white,
        primaryColor: MeepleColors.primaryBlue,
      ),
      home: HomeScreen(),
    );
  }
}