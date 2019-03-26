import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:the_meeple/models/player.dart';
import 'package:the_meeple/screens/players/profile_edit_screen.dart';
import 'package:the_meeple/utils/MeepleColors.dart';
import 'package:the_meeple/utils/emojis.dart';

class PlayerScreen extends StatelessWidget {
  PlayerScreen({Key key, @required this.player}) : assert(player != null), super(key: key);

  final Player player;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text("Player"),
        trailing: FlatButton(
            onPressed: () {
              Navigator.push(context, CupertinoPageRoute(builder: (context) => PlayerEditScreen(player: this.player, isCreating: false,)));
            },
            child: Text(
              "Edit",
              style: TextStyle(
                  color: MeepleColors.primaryBlue,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            )),
      ),
      body: _buildBody(),
    );
  }

  Column _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 24),
          child: SizedBox(
            width: 64,
            height: 64,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Container(
                  child: Text(Emojis.list[4], style: TextStyle(fontSize: 50))),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 6, bottom: 24),
          child: Text(player.name,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: Container(
            color: MeepleColors.paleGray,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Center(
                    child: Container(
                      width: 255,
                      child: Text(
                        "You don’t have play records with ${player.name} yet.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: MeepleColors.textGray,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
