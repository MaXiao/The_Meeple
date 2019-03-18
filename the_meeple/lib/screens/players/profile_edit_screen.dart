import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:the_meeple/models/player.dart';
import 'package:the_meeple/screens/players/player_edit_bloc.dart';
import 'package:the_meeple/utils/MeepleColors.dart';
import 'package:the_meeple/utils/Views/meeple_alert_view.dart';
import 'package:the_meeple/utils/emojis.dart';

class PlayerEditScreen extends StatefulWidget {
  PlayerEditScreen({Key key, this.isCreating, this.player}) : super(key: key);

  final Player player;
  final bool isCreating;

  @override
  State<StatefulWidget> createState() {
    return PlayerEditState();
  }
}

class PlayerEditState extends State<PlayerEditScreen> {
  FocusNode _focus;
  TextEditingController _controller;
  PlayerEditScreenBloc _bloc;

  @override
  void initState() {
    super.initState();

    _focus = FocusNode();
    _controller = TextEditingController(text: "${widget.player.name}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text(widget.isCreating ? "Add Player" : "Edit Player"),
        trailing: FlatButton(
            onPressed: () {
              _bloc.createPlayer.add(_controller.text);
            },
            child: Text(
              "Done",
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
          child: Container(
          padding: const EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              color: MeepleColors.primaryBlue, // border color
              shape: BoxShape.circle,
            ),
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
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
            child: Container(
              decoration: BoxDecoration(
                  color: MeepleColors.paleGray,
                  borderRadius: BorderRadius.circular(6)),
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Container(
                  height: 56,
                  child: CupertinoTextField(
                    onEditingComplete: () {},
                    autofocus: true,
                    placeholder: "Username",
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6)),
                    controller: _controller,
                    focusNode: _focus,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )),
        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: FlatButton.icon(
                padding: const EdgeInsets.symmetric(vertical: 24),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return _DeleteAlert(
                          bloc: _bloc,
                          player: widget.player,
                        );
                      });
                },
                icon: Image.asset("assets/images/ic_delete_bin.png"),
                label: Text(
                  "Delete player",
                  style: TextStyle(color: MeepleColors.primaryBlue),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}

class _DeleteAlert extends StatelessWidget {
  const _DeleteAlert({
    Key key,
    @required this.bloc,
    @required this.player,
  }) : super(key: key);

  final PlayerEditScreenBloc bloc;
  final Player player;

  @override
  Widget build(BuildContext context) {
    return MeepleAlert(
      title: "Are you sure?",
      content: "Delete a player will remove all his/her records.",
      positiveAction: () {
        bloc.deletePlayer.add(player);
        Navigator.pop(context);
      },
      positiveLabel: "Yes",
    );
  }
}
