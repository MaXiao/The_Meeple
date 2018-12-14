import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:the_meeple/models/Player.dart';
import 'package:the_meeple/screens/add_player_bloc.dart';
import 'package:the_meeple/utils/MeepleColors.dart';
import 'package:the_meeple/utils/Views/empty_view.dart';

class PlayerScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddPlayerScreenState();
  }
}

class AddPlayerScreenState extends State<PlayerScreen> {
  final _bloc = AddPlayerScreenBloc();
  final _editController = TextEditingController();
  final _focus = FocusNode();
  List<Player> _players;
  List<Player> _selectedPlayers;

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _navbar(),
      body: SafeArea(
          child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: MeepleColors.paleGray),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 12, bottom: 12),
              child: CupertinoTextField(
                decoration: BoxDecoration(color: Colors.white),
                placeholder: 'Add new player',
                focusNode: _focus,
                controller: _editController,
                onSubmitted: (name) {
                  _editController.clear();
                  _bloc.createPlayer.add(name);
                  FocusScope.of(context).requestFocus(_focus);
                },
                textInputAction: TextInputAction.done,
              ),
            ),
          ),
          Expanded(
            child: _PlayerList(bloc: _bloc),
          ),
          _AddButton(bloc: _bloc),
        ],
      )),
    );
  }

  Widget _navbar() {
    return CupertinoNavigationBar(
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
      middle: Text("All Player"),
      padding: const EdgeInsetsDirectional.only(start: 0, end: 0),
    );
  }
}

class _PlayerList extends StatelessWidget {
  const _PlayerList({
    Key key,
    @required AddPlayerScreenBloc bloc,
  })  : _bloc = bloc,
        super(key: key);

  final AddPlayerScreenBloc _bloc;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Player>>(
      stream: _bloc.selectedPlayers,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data.isNotEmpty) {
          return ListView.builder(
            itemBuilder: (context, index) {
              final player = snapshot.data[index];
              return _PlayerCell(player: player, selected: true,);
            },
            itemCount: snapshot.data.length,
          );
        } else {
          return EmptyView();
        }
      },
    );
  }
}

class _PlayerCell extends StatelessWidget {
  const _PlayerCell({
    Key key,
    @required this.player,
    @required this.selected,
  }) : super(key: key);

  final Player player;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Container(
          height: 54,
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: MeepleColors.paleGray, width: 2.0))),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  player.name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
              selected ? Image.asset('assets/images/btn_added.png') : Image.asset('assets/images/btn_add.png'),
            ],
          )),
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({
    Key key,
    @required AddPlayerScreenBloc bloc,
  })  : _bloc = bloc,
        super(key: key);

  final AddPlayerScreenBloc _bloc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 40, 16, 40),
      child: ConstrainedBox(
        constraints: BoxConstraints.expand(height: 56.0),
        child: StreamBuilder<List<Player>>(
          stream: _bloc.selectedPlayers,
          builder: (context, snapshot) {
            final count = (snapshot.hasData && snapshot.data.isNotEmpty)
                ? snapshot.data.length
                : 0;
            return FlatButton(
              child: Text(
                count > 0 ? "Add selected ($count)" : "Add selected",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              textColor: Colors.white,
              disabledTextColor: Colors.white,
              color: MeepleColors.primaryBlue,
              disabledColor: MeepleColors.primaryBlue.withAlpha(126),
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(6.0)),
              onPressed: count == 0 ? null : () {},
            );
          },
        ),
      ),
    );
  }
}
