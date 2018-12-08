import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:the_meeple/dataprovider/DBHelper.dart';
import 'package:the_meeple/models/Player.dart';
import 'package:the_meeple/screens/addPlayer.dart';
import 'package:the_meeple/screens/scoring_bloc.dart';
import 'package:the_meeple/utils/MeepleColors.dart';

class ScoringScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ScoringScreenState();
  }
}

class ScoringScreenState extends State<ScoringScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _bloc = ScoringBloc();

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
    return StreamBuilder<List<Player>>(
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data.isNotEmpty) {
          return Container(
            decoration: BoxDecoration(color: MeepleColors.paleGray),
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: _PlayerList(snapshot.data, () {
                _showAddPlayers(context, snapshot.data);
              }),
            ),
          );
        } else {
          return Expanded(
            child: Container(
              decoration: BoxDecoration(color: MeepleColors.paleGray),
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: _PlayerListEmptyView(() {
                  _showAddPlayers(context, List());
                }),
              ),
            ),
          );
        }
      },
      stream: _bloc.players,
    );
  }

  void _showAddPlayers(BuildContext context, List<Player> players) async {
    final result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddPlayerScreen()));

    if (result is List<Player>) {
      _bloc.selectPlayers.add(result);
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

class _PlayerListEmptyView extends StatelessWidget {
  final VoidCallback _onAddPlayersCallback;

  _PlayerListEmptyView(this._onAddPlayersCallback);

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      promptLabel(),
      addButton(context),
    ]);
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
            onPressed: _onAddPlayersCallback),
      ),
    );
  }
}

class _PlayerList extends StatelessWidget {
  final List<Player> _players;
  final VoidCallback _onAddPlayersCallback;

  _PlayerList(this._players, this._onAddPlayersCallback);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: ListView.builder(
            itemBuilder: (context, index) {
              return _PlayerCell(_players[index]);
            },
            itemCount: _players.length,
            shrinkWrap: true,
          ),
        ),
        FlatButton(
          child: Text(
            '\u{FF0B} Add player',
            style: TextStyle(
              color: MeepleColors.primaryBlue,
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: _onAddPlayersCallback,
          padding: EdgeInsets.all(0),
        )
      ],
    );
  }
}

class _PlayerCell extends StatelessWidget {
  final Player _player;

  _PlayerCell(this._player);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
            height: 54.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(const Radius.circular(4.0)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                      child: Text(
                    _player.name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  )),
                  Text(
                    "0",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: MeepleColors.primaryBlue,
                    ),
                  )
                ],
              ),
            )),
        // divider
        Container(
          height: 8,
          decoration: BoxDecoration(color: Colors.transparent),
        )
      ],
    );
  }
}
