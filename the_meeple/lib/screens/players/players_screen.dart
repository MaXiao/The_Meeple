import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:the_meeple/models/player.dart';
import 'package:the_meeple/screens/players/player_screen.dart';
import 'package:the_meeple/screens/players/players_bloc.dart';
import 'package:the_meeple/screens/players/profile_edit_screen.dart';
import 'package:the_meeple/utils/MeepleColors.dart';
import 'package:the_meeple/utils/Views/empty_view.dart';

class PlayersScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PlayersScreenState();
  }
}

class _PlayersScreenState extends State<PlayersScreen> with RouteAware {
  final PlayersScreenBloc _bloc = PlayersScreenBloc();
  final RouteObserver<PageRoute> routeObserver = RouteObserver();

  @override
  void initState() {
    super.initState();
    _bloc.refresh();
  }

  @override
  void didPushNext() {
    debugPrint("push next");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        automaticallyImplyLeading: false,
        middle: Text("Players"),
      ),
      body: SafeArea(
          child: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<List<Player>>(
              stream: _bloc.players,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return EmptyView();
                }

                if (snapshot.hasData && snapshot.data.isNotEmpty) {
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {
                          final updated = await Navigator.push(context, CupertinoPageRoute(builder: (context) => PlayerScreen(player: snapshot.data[index])));
                          if (updated == true) {
                            _bloc.refresh();
                          }
                        },
                        child: _PlayerCell(
                          bloc: _bloc,
                          player: snapshot.data[index],
                        ),
                      );
                    },
                    itemCount: snapshot.data.length,
                  );
                } else {
                  return _EmptyPage();
                }
              },
            ),
          ),
          Container(
            height: 80,
            color: Colors.white,
            child: Center(
              child: FlatButton(
                  onPressed: () async {
                    final added = await Navigator.push(context, CupertinoPageRoute(builder: (context) => PlayerEditScreen(isCreating: true,)));
                    if (added) {
                      _bloc.refresh();
                    }
                  },
                  child: Container(
                    height: 54,
                    decoration: BoxDecoration(
                        color: MeepleColors.primaryBlue,
                        borderRadius: BorderRadius.circular(6)),
                    child: Center(
                      child: Text("\u{FF0B} Add new player",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                    ),
                  )),
            ),
          )
        ],
      )),
    );
  }
}

class _EmptyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 45, bottom: 20),
          child: Center(child: Image.asset("assets/images/img_player.png")),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 60, right: 60),
          child: Text(
            "It’s a bit lonely here. Add some friends?",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: MeepleColors.textLightGray),
          ),
        )
      ],
    );
  }
}

class _PlayerCell extends StatelessWidget {
  const _PlayerCell({
    Key key,
    @required this.player,
    @required this.bloc,
  }) : super(key: key);

  final Player player;
  final PlayersScreenBloc bloc;

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
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Text(player.avatar, style: TextStyle(fontSize: 30),),
              ),

              Expanded(
                child: Text(
                  player.name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: MeepleColors.primaryBlue,
              )
            ],
          )),
    );
  }
}
