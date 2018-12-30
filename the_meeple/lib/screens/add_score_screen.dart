import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:the_meeple/models/player.dart';
import 'package:the_meeple/models/record.dart';
import 'package:the_meeple/screens/add_score_bloc.dart';
import 'package:the_meeple/utils/MeepleColors.dart';

class AddScoreInherited extends InheritedWidget {
  final Record record;
  final Player player;
  final AddScoreScreenBloc bloc;

  AddScoreInherited({
    Key key,
    @required this.record,
    @required this.player,
    @required this.bloc,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return false;
  }

  static AddScoreInherited of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(AddScoreInherited);
  }
}

class AddScoreScreen extends StatefulWidget {
  final Record _record;
  final Player _player;

  AddScoreScreen(this._record, this._player);

  @override
  State<StatefulWidget> createState() {
    return AddScoreScreenState(_record, _player);
  }
}

class AddScoreScreenState extends State<AddScoreScreen> {
  final Record _record;
  final Player _player;
  final AddScoreScreenBloc _bloc = AddScoreScreenBloc();

  AddScoreScreenState(this._record, this._player) {
    _bloc.changeScore.add(_record.scores[_player]);
  }

  @override
  Widget build(BuildContext context) {
    return AddScoreInherited(
      record: _record,
      player: _player,
      bloc: _bloc,
      child: Scaffold(
        appBar: _navbar(context),
        body: SafeArea(child: _ScoreBody()),
      ),
    );
  }

  Widget _navbar(BuildContext context) {
    return CupertinoNavigationBar(
      leading: FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            "Next Player",
            style: TextStyle(
                color: MeepleColors.primaryBlue,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          )),
      middle: Text("Add Score"),
      trailing: FlatButton(
          onPressed: () {},
          child: Text(
            "Done",
            style: TextStyle(
                color: MeepleColors.primaryBlue,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          )),
      padding: const EdgeInsetsDirectional.only(start: 0, end: 0),
    );
  }
}

class _ScoreBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final player = AddScoreInherited.of(context).player;
    final record = AddScoreInherited.of(context).record;
    final bloc = AddScoreInherited.of(context).bloc;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            "${player.name}'s score",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 20),
            child: StreamBuilder(
              stream: bloc.currentScore,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  record.scores[player] = snapshot.data;
                }
                String score = "${record.scores[player]}";
                return Text(
                  "$score",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                );
              },
            ),
          ),
          _AddButtons(),
          _ScoreInputField(),
        ],
      ),
    );
  }
}

class _ScoreInputField extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ScoreInputFieldState();
  }
}

class _ScoreInputFieldState extends State<_ScoreInputField> {
  final _editController = TextEditingController();
  final _focus = FocusNode();

  @override
  Widget build(BuildContext context) {
    final bloc = AddScoreInherited.of(context).bloc;

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Container(
        height: 156,
        decoration: BoxDecoration(
            color: MeepleColors.paleGray,
            borderRadius: BorderRadius.all(Radius.circular(6))),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                height: 54,
                child: CupertinoTextField(
                  decoration: BoxDecoration(color: Colors.white),
                  placeholder: 'Enter score',
                  focusNode: _focus,
                  controller: _editController,
                  onSubmitted: (name) {
                    _editController.clear();
                    FocusScope.of(context).requestFocus(_focus);
                  },
                  keyboardType: TextInputType.number,
                ),
              ),
              Row(
                children: <Widget>[
                  Flexible(
                    flex: 2,
                    child: GestureDetector(
                        onTap: () {
                          if (_editController.text.isNotEmpty) {
                            bloc.changeScore
                                .add(-int.parse(_editController.text));
                          }
                        },
                        child: _SignButton(sign: "-")),
                  ),
                  Container(
                    width: 12,
                  ),
                  Flexible(
                      flex: 3,
                      child: GestureDetector(
                          onTap: () {
                            if (_editController.text.isNotEmpty) {
                              bloc.changeScore
                                  .add(int.parse(_editController.text));
                            }
                          },
                          child: _SignButton(sign: "+"))),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _SignButton extends StatelessWidget {
  final String sign;

  const _SignButton({
    Key key,
    @required this.sign,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      decoration: BoxDecoration(
          color: MeepleColors.bgGray,
          borderRadius: BorderRadius.all(Radius.circular(6))),
      child: Center(
        child: Text(
          sign,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 30),
        ),
      ),
    );
  }
}

class _AddButtons extends StatelessWidget {
  const _AddButtons({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 78,
      decoration: BoxDecoration(
        color: MeepleColors.paleGray,
        borderRadius: BorderRadius.all(Radius.circular(7)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _AddButton(1),
            Container(
              width: 10,
            ),
            _AddButton(5),
            Container(
              width: 10,
            ),
            _AddButton(10),
          ],
        ),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  final int _delta;

  _AddButton(this._delta);

  @override
  Widget build(BuildContext context) {
    final bloc = AddScoreInherited.of(context).bloc;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          bloc.changeScore.add(_delta);
        },
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(6))),
          child: Center(
            child: Text(
              "+$_delta",
              style: TextStyle(
                color: MeepleColors.primaryBlue,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
