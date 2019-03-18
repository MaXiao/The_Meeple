import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:the_meeple/models/player.dart';
import 'package:the_meeple/models/record.dart';
import 'package:the_meeple/screens/add_player_screen.dart';
import 'package:the_meeple/screens/add_score_screen.dart';
import 'package:the_meeple/screens/scoring_bloc.dart';
import 'package:the_meeple/utils/MeepleColors.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:the_meeple/utils/Views/SlidableCell.dart';
import 'package:the_meeple/utils/Views/emoji_picker_view.dart';
import 'package:the_meeple/utils/Views/meeple_alert_view.dart';
import 'package:the_meeple/utils/Views/meeple_bottom_sheet.dart';
import 'package:the_meeple/utils/Views/toast.dart';

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
      padding: const EdgeInsets.only(left: 16.0, top: 30.0, bottom: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Scoring',
            style: TextStyle(
                fontSize: 28.0,
                color: Colors.black,
                fontWeight: FontWeight.w900),
          ),
          FlatButton(
            child: Container(
              width: 100,
              height: 40,
              decoration: BoxDecoration(
                  color: MeepleColors.primaryBlue,
                  borderRadius: BorderRadius.all(Radius.circular(6))),
              child: Center(
                  child: Text(
                "Start new",
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )),
            ),
            onPressed: () {
//              showModalBottomSheet(
//                  context: context,
//                  builder: (BuildContext context) {
//                    return MeepleBottomSheet(
//                      content: EmojiPickerView(),
//                    );
//                  });
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return _RestartAlert(bloc: _bloc);
                  });
//            showToast(context, "Player Added");
            },
          )
        ],
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
        if (snapshot.hasData && snapshot.data.scores.isNotEmpty) {
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
    final result = await Navigator.push(
        context,
        CupertinoPageRoute(
            fullscreenDialog: true,
            builder: (context) => PlayerScreen(players)));

    if (result is List<Player>) {
      _bloc.selectPlayers.add(result);
    }
  }
}

class _RestartAlert extends StatelessWidget {
  const _RestartAlert({
    Key key,
    @required ScoringBloc bloc,
  })  : _bloc = bloc,
        super(key: key);

  final ScoringBloc _bloc;

  @override
  Widget build(BuildContext context) {
    return MeepleAlert(
      title: "Just in case \u{1F600}",
      content: "Are you sure you want to start a new game? All current scores will be lost.",
      positiveAction: () { _bloc.startNew.add(null); },
      positiveLabel: "Yes, start new",
      bottomComponent: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: _BottomButton(
          image: AssetImage('assets/images/ic_action_save.png'),
          title: 'Save score to record',
          pressCallback: () {},
        ),
      ),
    ) ;
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
        child: FlatButton(
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
        new _BottomButtons(onAddPlayersCallback: _onAddPlayersCallback)
      ],
    );
  }

  void _updateScore(BuildContext context, Record record, Player player) async {
    final bloc = ScoringInherited.of(context).bloc;
    final result = await Navigator.push(
        context,
        CupertinoPageRoute(
            fullscreenDialog: true,
            builder: (context) => AddScoreScreen(_record, player)));

    if (result is Record) {
      bloc.updateScore.add(record.scores);
    }
  }
}

class _BottomButtons extends StatelessWidget {
  const _BottomButtons({
    Key key,
    @required onAddPlayersCallback,
  })  : _onAddPlayersCallback = onAddPlayersCallback,
        super(key: key);

  final _onAddPlayersCallback;

  @override
  Widget build(BuildContext context) {
    final bloc = ScoringInherited.of(context).bloc;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _BottomButton(
          image: AssetImage('assets/images/ic_action_save.png'),
          title: 'Save to record',
          pressCallback: () {},
        ),
        _BottomButton(
          image: AssetImage('assets/images/ic_manage.png'),
          title: 'Manage',
          pressCallback: () {
            showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return MeepleBottomSheet(
                    content: ListView(
                      shrinkWrap: true,
                      children: <Widget>[
                        _ActionCell(
                          image: AssetImage("assets/images/ic_action_reset.png"),
                          title: "Reset all to 0",
                          color: MeepleColors.actionYellow,
                          pressCallback: () {
                            bloc.resetScores.add(null);
                            Navigator.pop(context);
                          },
                        ),
                        _ActionCell(
                          image: AssetImage("assets/images/ic_action_add.png"),
                          title: "Add player",
                          color: MeepleColors.actionGreen,
                          pressCallback: () {
                            Navigator.pop(context);
                            _onAddPlayersCallback();
                          },
                        ),
                        _ActionCell(
                          image: AssetImage("assets/images/ic_action_rank.png"),
                          title: "Rank by score",
                          color: MeepleColors.primaryBlue,
                          pressCallback: () {
                            bloc.rankScores.add(null);
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  );
                });
          },
        ),
      ],
    );
  }
}

class _BottomButton extends StatelessWidget {
  const _BottomButton({
    Key key,
    @required this.image,
    @required this.title,
    @required this.pressCallback,
  }) : super(key: key);

  final VoidCallback pressCallback;
  final AssetImage image;
  final String title;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image(
            image: image,
            color: MeepleColors.primaryBlue,
          ),
          Container(
            width: 4,
          ),
          Text(title,
              style: TextStyle(
                color: MeepleColors.primaryBlue,
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              )),
        ],
      ),
      onPressed: pressCallback,
      padding: EdgeInsets.all(0),
    );
  }
}

class _ActionCell extends StatelessWidget {
  const _ActionCell({
    Key key,
    @required this.image,
    @required this.title,
    @required this.color,
    @required this.pressCallback,
  }) : super(key: key);

  final VoidCallback pressCallback;
  final ImageProvider image;
  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: FlatButton(
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        child: Container(
          height: 51,
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 8),
                child: ImageIcon(
                  image,
                  color: Colors.white,
                ),
              ),
              Text(title,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  )),
            ],
          ),
        ),
        onPressed: pressCallback,
        padding: EdgeInsets.all(0),
      ),
    );
  }
}

class _PlayerCell extends StatelessWidget {
  final Player _player;
  final int _score;

  _PlayerCell(this._player, this._score);

  @override
  Widget build(BuildContext context) {
    final bloc = ScoringInherited.of(context).bloc;

    return Slidable(
      delegate: SlidableScrollDelegate(),
      secondaryActions: <Widget>[
        SlideAction(
          child: ActionButton(
            color: MeepleColors.actionYellow,
            text: "Reset",
          ),
          onTap: () {
            bloc.resetPlayer.add(_player);
          },
        ),
        SlideAction(
          child: ActionButton(
            color: MeepleColors.actionRed,
            text: "Delete",
          ),
          onTap: () {
            bloc.removePlayer.add(_player);
          },
        ),
      ],
      child: Container(
          height: 51.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 8, right: 24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                    child: Text(
                  _player.name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
    );
  }
}


