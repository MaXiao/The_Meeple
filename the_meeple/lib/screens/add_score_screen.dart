import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:the_meeple/models/player.dart';
import 'package:the_meeple/models/record.dart';
import 'package:the_meeple/screens/add_score_bloc.dart';
import 'package:the_meeple/utils/MeepleColors.dart';
import 'package:the_meeple/utils/Views/empty_view.dart';

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
  AddScoreScreenBloc _bloc;

  AddScoreScreenState(this._record, this._player) {
    _bloc = AddScoreScreenBloc(_record);
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
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
      backgroundColor: Colors.white,
      leading: FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            "Cancel",
            style: TextStyle(
                color: MeepleColors.primaryBlue,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          )),
      middle: Text("Add Score"),
      trailing: FlatButton(
          onPressed: () {
            Navigator.pop(context, _record);
          },
          child: Text(
            "Save",
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
    final selectedPlayer = AddScoreInherited.of(context).player;
    final record = AddScoreInherited.of(context).record;
    final bloc = AddScoreInherited.of(context).bloc;
    final focusNodes = Map<int, FocusNode>();

    return StreamBuilder(
        stream: bloc.currentRecord,
        initialData: record,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final controller = PageController(
                initialPage: record.players.indexOf(selectedPlayer));

            return PageView.builder(
              controller: controller,
              itemBuilder: (context, position) {
                final player = record.players[position % record.players.length];
                final focus = FocusNode();
                focusNodes[position] = focus;

                return Padding(
                  padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      _TopRow(controller: controller, player: player, position: position),
                      Text(
                        "${record.scores[player]}",
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      _ScoreInputField(player, focus),
                      _AddButtons(player: player),
                    ],
                  ),
                );
              },
              itemCount: null,
              onPageChanged: (position) {
                final focus = focusNodes[position];
                if (focus != null) {
                  FocusScope.of(context).requestFocus(focus);
                }
              },
            );
          } else {
            return EmptyView();
          }
        });
  }
}

class _TopRow extends StatelessWidget {
  const _TopRow({
    Key key,
    @required this.controller,
    @required this.player,
    @required this.position,
  }) : super(key: key);

  final PageController controller;
  final Player player;
  final int position;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Visibility(
          visible: position != 0,
          maintainState: true,
          maintainAnimation: true,
          maintainSize: true,
          child: IconButton(
            padding: EdgeInsets.fromLTRB(0, 8, 16, 8),
            icon: Transform.rotate(
                angle: pi, child: Image.asset('assets/images/chevron_right.png')),
            onPressed: () {
              controller.previousPage(
                  duration: Duration(milliseconds: 300),
                  curve: ElasticInOutCurve());
            },
          ),
        ),
        Text(
          "${player.name}'s score",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        IconButton(
          padding: EdgeInsets.fromLTRB(16, 8, 0, 8),
          icon: Image.asset('assets/images/chevron_right.png'),
          onPressed: () {
            controller.nextPage(
                duration: Duration(milliseconds: 300),
                curve: ElasticInOutCurve());
          },
        ),
      ],
    );
  }
}

class _ScoreInputField extends StatefulWidget {
  final Player _player;
  final FocusNode _focus;

  _ScoreInputField(this._player, this._focus);

  @override
  State<StatefulWidget> createState() {
    return _ScoreInputFieldState(_player, _focus);
  }
}

class _ScoreInputFieldState extends State<_ScoreInputField> {
  final _editController = TextEditingController();
  final FocusNode _focus;
  final Player _player;

  _ScoreInputFieldState(this._player, this._focus);

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
                width: 160,
                child: CupertinoTextField(
                  autofocus: true,
                  decoration: BoxDecoration(color: Colors.white),
                  placeholder: 'Enter score',
                  focusNode: _focus,
                  controller: _editController,
                  keyboardType: TextInputType.number,
                  onChanged: (newValue) {
                    setState(() {});
                  },
                ),
              ),
              Row(
                children: <Widget>[
                  Flexible(
                    flex: 2,
                    child: _SignButton(
                      sign: "-",
                      isEnabled: _editController.text.isNotEmpty,
                      onPressed: () {
                        if (_editController.text.isNotEmpty) {
                          bloc.changeScore
                              .add({_player: -int.parse(_editController.text)});
                          _editController.clear();
                          setState(() {});
                        }
                      },
                    ),
                  ),
                  Container(
                    width: 12,
                  ),
                  Flexible(
                      flex: 3,
                      child: _SignButton(
                          sign: "+",
                          isEnabled: _editController.text.isNotEmpty,
                          onPressed: () {
                            if (_editController.text.isNotEmpty) {
                              bloc.changeScore.add(
                                  {_player: int.parse(_editController.text)});
                              _editController.clear();
                              setState(() {});
                            }
                          })),
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
  final bool isEnabled;
  final VoidCallback onPressed;

  const _SignButton({
    Key key,
    @required this.sign,
    @required this.isEnabled,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.expand(height: 54),
      child: FlatButton(
        color: MeepleColors.primaryBlue,
        disabledColor: MeepleColors.bgGray,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        child: Text(
          sign,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 30),
        ),
        onPressed: isEnabled ? onPressed : null,
      ),
    );
  }
}

class _AddButtons extends StatelessWidget {
  final Player player;

  const _AddButtons({
    Key key,
    @required this.player,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 78,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _AddButton(1, player),
            Container(
              width: 10,
            ),
            _AddButton(5, player),
            Container(
              width: 10,
            ),
            _AddButton(10, player),
          ],
        ),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  final int _delta;
  final Player _player;

  _AddButton(this._delta, this._player);

  @override
  Widget build(BuildContext context) {
    final bloc = AddScoreInherited.of(context).bloc;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          bloc.changeScore.add({_player: _delta});
        },
        child: Container(
          decoration: BoxDecoration(
              color: MeepleColors.paleBlue,
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
