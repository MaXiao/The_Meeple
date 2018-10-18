import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:the_meeple/dataprovider/DBHelper.dart';
import 'package:the_meeple/models/Player.dart';

class ScoringScreen extends StatelessWidget {
  final nameController = TextEditingController();
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Padding(
          padding: const EdgeInsets.only(
              left: 20.0, top: 60.0, right: 20.0, bottom: 0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                'Scoring',
                style: TextStyle(
                  fontSize: 28.0,
                  color: Color.fromARGB(255, 10, 10, 10),
                ),
              ),
              TextField(controller: nameController,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 200.0,
                  height: 50.0,
                  child: RaisedButton(
                    child: Text('Save'),
                    color: Colors.blue,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    onPressed: () {
                      _saveUser(nameController.text);
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _saveUser(String name) {
    print(name);

    var player = Player(name, DateTime.now(), DateTime.now());
    var db = DBHelper();

    db.savePlayer(player);
    scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Player saved')));
  }
}
