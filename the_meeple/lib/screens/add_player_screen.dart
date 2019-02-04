import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:the_meeple/models/player.dart';
import 'package:the_meeple/screens/add_player_bloc.dart';
import 'package:the_meeple/utils/MeepleColors.dart';
import 'package:the_meeple/utils/Views/empty_view.dart';

class AddPlayerInherited extends InheritedWidget {
  final List<Player> selectedPlayers;
  final AddPlayerScreenBloc bloc;


  AddPlayerInherited(
      {Key key, @required this.bloc, @required this.selectedPlayers, @required Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(AddPlayerInherited oldWidget) =>
      selectedPlayers != oldWidget.selectedPlayers;

  static AddPlayerInherited of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(AddPlayerInherited);
  }
}

class PlayerScreen extends StatefulWidget {
  final List<Player> _selectedPlayers;

  PlayerScreen(this._selectedPlayers);

  @override
  State<StatefulWidget> createState() {
    return AddPlayerScreenState(_selectedPlayers);
  }
}

class AddPlayerScreenState extends State<PlayerScreen> {
  final _bloc = AddPlayerScreenBloc();
  List<Player> _selectedPlayers;

  AddPlayerScreenState(this._selectedPlayers);

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _bloc.selectPlayers.add(_selectedPlayers);

    return AddPlayerInherited(
      bloc: _bloc,
      selectedPlayers: _selectedPlayers,
      child: Scaffold(
        appBar: _navbar(),
        body: SafeArea(
            child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(color: MeepleColors.paleGray),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 12, bottom: 12),
                child: new _AddPlayerField(),
              ),
            ),
            Expanded(
              child: _PlayerList(),
            ),
          ],
        )),
      ),
    );
  }

  Widget _navbar() {
    return CupertinoNavigationBar(
      automaticallyImplyLeading: false,
      leading: StreamBuilder(
        stream: _bloc.showCancelBtn,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return snapshot.data ? FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(
                      color: MeepleColors.primaryBlue,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                )) : EmptyView();
          } else {
            return EmptyView();
          }
        },
      ),
      middle: Text("All Player"),
      trailing: StreamBuilder<List<Player>>(
        stream: _bloc.selectedPlayers,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data.isNotEmpty) {
            final count = snapshot.data.length;
            return FlatButton(
              child: Text(
                "Done($count)",
                style: TextStyle(
                    color: MeepleColors.primaryBlue,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.pop(context, snapshot.data);
              },
            );
          } else {
            return EmptyView();
          }
        },
      ),
      padding: const EdgeInsetsDirectional.only(start: 0, end: 0),
    );
  }
}

class _AddPlayerField extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddPlayerFieldState();
  }
}

class _AddPlayerFieldState extends State<_AddPlayerField> {
  final _editController = TextEditingController();
  final _focus = FocusNode();
  OverlayEntry _cover;

  @override
  void initState() {
    super.initState();

    _focus.addListener(() {
      final bloc = AddPlayerInherited.of(context).bloc;

      if (_cover == null) {
        _cover = _createCover();
      }

      if (_focus.hasFocus) {
        Overlay.of(context).insert(_cover);
        bloc.toggleCancelBtn.add(false);
      } else {
        _cover.remove();
        bloc.toggleCancelBtn.add(true);
      }
    });
  }

  OverlayEntry _createCover() {
    RenderBox renderBox = context.findRenderObject();
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
        builder: (context) => Positioned(
          left: 0,
          top: offset.dy + size.height + 10,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: GestureDetector(
            onTap: () {
              _focus.unfocus();
            },
            child: Container(
              decoration: BoxDecoration(
                color: MeepleColors.overlayGrey,
              ),
            ),
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    final _bloc = AddPlayerInherited.of(context).bloc;

    return CupertinoTextField(
      decoration: BoxDecoration(color: Colors.white),
      placeholder: 'Add new player',
      focusNode: _focus,
      controller: _editController,
      onSubmitted: (name) {
        _editController.clear();
        _bloc.createPlayer.add(name);
        FocusScope.of(context).requestFocus(_focus);
      },
      textInputAction: TextInputAction.go,
    );
  }
}

class _PlayerList extends StatelessWidget {
  const _PlayerList();

  @override
  Widget build(BuildContext context) {
    final _bloc = AddPlayerInherited.of(context).bloc;
    final _selectedPlayers = AddPlayerInherited.of(context).selectedPlayers;

    return StreamBuilder<List<Player>>(
      stream: _bloc.players,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data.isNotEmpty) {
          return ListView.builder(
            itemBuilder: (context, index) {
              return StreamBuilder(
                  stream: _bloc.selectedPlayers,
                  builder: (context, snapshot2) {
                    if (snapshot2.hasData) {
                      _selectedPlayers.clear();
                      _selectedPlayers.addAll(snapshot2.data);
                    }

                    final player = snapshot.data[index];
                    return GestureDetector(
                      onTap: () {
                        _bloc.toggleSelection.add(player);
                      },
                      child: _PlayerCell(
                          player: player,
                          selected: snapshot2.hasData && snapshot2.data.contains(player)),
                    );
                  });
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
          decoration: BoxDecoration(
              border: Border(
                  bottom:
                      BorderSide(color: MeepleColors.paleGray, width: 2.0))),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  player.name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
              selected
                  ? Image.asset('assets/images/btn_added.png')
                  : Image.asset('assets/images/btn_add.png'),
            ],
          )),
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton();

  @override
  Widget build(BuildContext context) {
    final _bloc = AddPlayerInherited.of(context).bloc;
    final _selectedPlayers = AddPlayerInherited.of(context).selectedPlayers;

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
              disabledColor: MeepleColors.bgGray,
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(6.0)),
              onPressed: count == 0 ? null : () {
                Navigator.pop(context, _selectedPlayers);
              },
            );
          },
        ),
      ),
    );
  }
}
