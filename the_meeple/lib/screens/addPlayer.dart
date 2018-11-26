import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:the_meeple/models/Player.dart';
import 'package:the_meeple/screens/addPlayerBloc.dart';
import 'package:the_meeple/utils/MeepleColors.dart';

class AddPlayerScreen extends StatelessWidget {
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: InputField(),
        ),
      ),
    );
  }
}

class InputField extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return InputFieldState();
  }
}

class InputFieldState extends State<InputField> {
  final bloc = AddPlayerBloc();
  final _controller = TextEditingController();
  final _focus = FocusNode();

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              onSubmitted: (newString) {
                _controller.clear();
                FocusScope.of(context).requestFocus(_focus);
                bloc.playerAddition.add(newString);
              },
            ),
          ),
          _playerList()
        ],
      ),
    );
  }

  Widget _playerList() {
    return Expanded(
      child: StreamBuilder<List<Player>>(
        stream: bloc.items,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data.isNotEmpty) {
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                final player = snapshot.data[index];
                return PlayerCell(player.name, () {
                  bloc.playerRemoval.add(index);
                });
              },
              itemCount: snapshot.data.length,
            );
          }
          return Text("Add Player");
        },
      ),
    );
  }
}

class PlayerCell extends StatelessWidget {
  final String _title;
  final VoidCallback _onDismissCallback;

  PlayerCell(String this._title, VoidCallback this._onDismissCallback);

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
                  ),i
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
