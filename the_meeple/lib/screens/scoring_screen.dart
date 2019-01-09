import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:the_meeple/models/player.dart';
import 'package:the_meeple/models/record.dart';
import 'package:the_meeple/screens/add_player_screen.dart';
import 'package:the_meeple/screens/add_score_screen.dart';
import 'package:the_meeple/screens/scoring_bloc.dart';
import 'package:the_meeple/utils/MeepleColors.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ScoringInherited extends InheritedWidget {
  final ScoringBloc bloc;

  ScoringInherited({Key key, @required this.bloc, @required Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return false;
  }

  static ScoringInherited of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(ScoringInherited);
}

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
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScoringInherited(
      bloc: _bloc,
      child: Scaffold(
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
    return StreamBuilder<Record>(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            decoration: BoxDecoration(color: MeepleColors.paleGray),
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: _PlayerList(snapshot.data, () {
                _showAddPlayers(context, snapshot.data.players);
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
      stream: _bloc.record,
    );
  }

  void _showAddPlayers(BuildContext context, List<Player> players) async {
    var players = List<Player>();
//    players.add(Player("Aric", DateTime.now(), DateTime.now()));
//    players.add(Player("Xiao", DateTime.now(), DateTime.now()));
//    players.add(Player("Q", DateTime.now(), DateTime.now()));

    final result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => PlayerScreen(players)));

    if (result is List<Player>) {
      _bloc.selectPlayers.add(result);
    }
  }
}

class _PlayerListEmptyView extends StatelessWidget {
  final VoidCallback _onAddPlayersCallback;

  _PlayerListEmptyView(this._onAddPlayersCallback);

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      TopImage(),
      PromptLabel(),
      addButton(context),
    ]);
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

class PromptLabel extends StatelessWidget {
  const PromptLabel({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 45.0),
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
}

class TopImage extends StatelessWidget {
  const TopImage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 56, bottom: 18),
      child: Container(
        height: 65,
        width: 146,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/img_score.png'))),
      ),
    );
  }
}

class _PlayerList extends StatelessWidget {
  final Record _record;
  final VoidCallback _onAddPlayersCallback;

  _PlayerList(this._record, this._onAddPlayersCallback);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: ListView.separated(
              itemBuilder: (context, index) {
                final p = _record.players[index];
                return GestureDetector(
                    onTap: () {
                      _updateScore(context, _record, p);
                    },
                    child: _PlayerCell(p, _record.scores[p]));
              },
              separatorBuilder: (context, index) {
                return Container(
                  height: 8,
                  decoration: BoxDecoration(color: Colors.transparent),
                );
              },
              itemCount: _record.players.length,
              shrinkWrap: true,
            )),
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

  void _updateScore(BuildContext context, Record record, Player player) async {
    final bloc = ScoringInherited.of(context).bloc;
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddScoreScreen(_record, player)));

    if (result is Record) {
      bloc.updateScore.add(record.scores);
    }
  }
}

class _PlayerCell extends StatelessWidget {
  final Player _player;
  final int _score;

  _PlayerCell(this._player, this._score);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      delegate: SlidableScrollDelegate(),
      secondaryActions: <Widget>[
        SlideAction(
          child: Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Container(
              decoration: BoxDecoration(
                  color: MeepleColors.actionYellow,
                  borderRadius: BorderRadius.all(const Radius.circular(6.0))),
              child: Center(child: Text("Reset", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),)),
            ),
          ),
          onTap: () {},
        ),
        SlideAction(
          child: Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Container(
              decoration: BoxDecoration(
                  color: MeepleColors.actionRed,
                  borderRadius: BorderRadius.all(const Radius.circular(6.0))),
              child: Center(child: Text("Delete", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),)),
            ),
          ),
          onTap: () {},
        ),
      ],
      child: Column(
        children: <Widget>[
          Container(
              height: 51.0,
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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    )),
                    Text(
                      "$_score",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: MeepleColors.primaryBlue,
                      ),
                    )
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
