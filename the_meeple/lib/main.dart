import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:the_meeple/screens/addPlayer.dart';
import 'package:the_meeple/screens/home.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Meeple',
      theme: ThemeData(
        fontFamily: "Manrope",
        scaffoldBackgroundColor: Colors.white,
        backgroundColor: Colors.white,
        primaryColor: Colors.white,
      ),
      home: HomeScreen(),
    );
  }
}