import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:the_meeple/models/Player.dart';
import 'package:the_meeple/screens/addPlayerBloc.dart';
import 'package:the_meeple/utils/MeepleColors.dart';
import 'package:intl/intl.dart';
import 'package:the_meeple/utils/Views/empty_view.dart';


class AddPlayerScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return InputFieldState();
  }
}

class InputFieldState extends State<AddPlayerScreen> {
  final _bloc = AddPlayerBloc();
  final _controller = TextEditingController();
  final _focus = FocusNode();
  final _dateFormatter = DateFormat('MM dd, yyyy');
  List<Player> _players;

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
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
        middle: StreamBuilder<List<Player>>(
          stream: _bloc.addedPlayers,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data.isNotEmpty) {
              _players = snapshot.data;
              return Text("Add Player (${snapshot.data.length})");
            }
            return Text("Add Player");
          },
        ),
        trailing: FlatButton(
          onPressed: () {
            Navigator.pop(context, _players);
          },
          child: Text(
            "Done",
            style: TextStyle(
                color: MeepleColors.primaryBlue,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
        ),
        padding: const EdgeInsetsDirectional.only(start: 0, end: 0),
      ),
      body: SafeArea(
        child: Container(
          child: _body(),
        ),
      ),
    );
  }

  Widget _body() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Colors.black, width: 2.0))),
            child: TextField(
              focusNode: _focus,
              controller: _controller,
              autofocus: true,
              onChanged: (newString) {
                _bloc.searchPlayers.add(newString);
              },
              onSubmitted: (newString) {
                // clear input field
                _controller.clear();
                // hide autocomplete dropdown
                _bloc.searchPlayers.add("");
                // keep the keyboard
                FocusScope.of(context).requestFocus(_focus);
                _bloc.playerCreation.add(newString);
              },
              textInputAction: TextInputAction.done,
            ),
          ),
          Expanded(child: Stack(children: [_playerList(), _autocomplete()])),
        ],
      ),
    );
  }

  Widget _autocomplete() {
    return StreamBuilder<List<Player>>(
      stream: _bloc.possiblePlayers,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data.isNotEmpty) {
          return DecoratedBox(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: MeepleColors.borderGray)),
            child: ListView.builder(
              itemBuilder: (context, index) {
                final player = snapshot.data[index];
                return AutoCompleteCell(player, _dateFormatter, () {
                  // clear input field
                  _controller.clear();
                  _bloc.searchPlayers.add("");
                  _bloc.addPlayer.add(player);
                });
              },
              itemCount: snapshot.data.length,
              shrinkWrap: true,
            ),
          );
        } else {
          return EmptyView();
        }
      },
    );
  }

  Widget _playerList() {
    return StreamBuilder<List<Player>>(
      stream: _bloc.addedPlayers,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data.isNotEmpty) {
          _players = snapshot.data;
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              final player = snapshot.data[index];
              return PlayerCell(player.name, () {
                _bloc.playerRemoval.add(index);
              });
            },
            itemCount: snapshot.data.length,
          );
        }
        return EmptyView();
      },
    );
  }
}

class PlayerCell extends StatelessWidget {
  final String _title;
  final VoidCallback _onDismissCallback;

  PlayerCell(this._title, this._onDismissCallback);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 54.0,
        child: DecoratedBox(
          decoration: BoxDecoration(
              border: Border(
                  bottom:
                      BorderSide(color: MeepleColors.paleGray, width: 2.0))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Text(
                  _title,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: MeepleColors.textLightGray,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.clear,
                  color: MeepleColors.textLightGray,
                ),
                alignment: Alignment.centerRight,
                padding: EdgeInsets.all(0.0),
                onPressed: _onDismissCallback,
              )
            ],
          ),
        ));
  }
}

class AutoCompleteCell extends StatelessWidget {
  final Player _player;
  final DateFormat _formatter;
  final VoidCallback _onTapCallback;

  AutoCompleteCell(this._player, this._formatter, this._onTapCallback);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTapCallback,
      child: Container(
        height: 54.0,
        child: Padding(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  _player.name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                  ),
                ),
              ),
              Text(
                _dateString(),
                style:
                    TextStyle(color: MeepleColors.textLightGray, fontSize: 12.0),
              )
            ],
          ),
        ),
      ),
    );
  }

  String _dateString() {
    return "last played on ${_formatter.format(_player.lastPlayed)}";
  }
}
