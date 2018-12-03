import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:the_meeple/dataprovider/DBHelper.dart';
import 'package:the_meeple/models/Player.dart';
import 'package:the_meeple/screens/addPlayer.dart';
import 'package:the_meeple/utils/MeepleColors.dart';

class ScoringScreen extends StatelessWidget {
  final nameController = TextEditingController();
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              titleLabel(),
              toggleRow(),
              byPlayer(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget titleLabel() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 30.0),
      child: Text(
        'Scoring',
        style: TextStyle(
            fontSize: 28.0, color: Colors.black, fontWeight: FontWeight.w900),
      ),
    );
  }

  Widget toggleRow() {
    return Padding(
      padding: const EdgeInsets.only(top: 34.0, bottom: 10.0),
      child: Row(
        children: <Widget>[
          toggleText('By player'),
          toggleText('By template'),
        ],
      ),
    );
  }

  Widget toggleText(String text) {
    return Container(
      margin: EdgeInsets.only(left: 30.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14.0,
        ),
      ),
    );
  }

  Widget byPlayer(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(color: MeepleColors.paleGray),
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Column(
            children: <Widget>[
              promptLabel(),
              addButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget promptLabel() {
    return Container(
      margin: EdgeInsets.only(left: 45.0, top: 140.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Add players to start scoring for your game.',
          style: TextStyle(
            fontSize: 16.0,
            color: MeepleColors.textGray,
          ),
          textAlign: TextAlign.left,
        ),
      ),
    );
  }

  Widget addButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50.0),
      child: ConstrainedBox(
        constraints: BoxConstraints.expand(height: 56.0),
        child: RaisedButton(
          child: Text(
            '\u{FF0B} Add player',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          color: MeepleColors.primaryBlue,
          textColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0)),
          onPressed: () {
            _showAddPlayers(context);
          },
        ),
      ),
    );
  }
  
  void _showAddPlayers(BuildContext context) async {
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => AddPlayerScreen()));

    if (result is List<Player> && result.isNotEmpty) {
      print(result);
    }
  }

  void _saveUser(String name) {
    print(name);

    var player = Player(name, DateTime.now(), DateTime.now());
    var db = DBHelper();

    db.savePlayer(player);
    scaffoldKey.currentState
        .showSnackBar(SnackBar(content: Text('Player saved')));
  }
}
