
import 'dart:async';

import 'package:the_meeple/dataprovider/DBHelper.dart';
import 'package:the_meeple/models/player.dart';

class PlayersScreenBloc {
  List<Player> _players = List();

  final StreamController<List<Player>> _playersHolder = StreamController<List<Player>>();
  final StreamController<Player> _playerAdditionController = StreamController<Player>();

  PlayersScreenBloc() {
    DBHelper().getPlayers().then((players) {
      _playersHolder.add(players);
      _players = players;
    });

    _playerAdditionController.stream.listen((player) {
      _players.add(player);
      _playersHolder.add(_players);
    });
  }

  void addPlayer() {
    final p = Player("test", DateTime.now(), DateTime.now());
    _playerAdditionController.add(p);
  }

  dispose() {
    _playersHolder.close();
  }

  Stream<List<Player>> get players => _playersHolder.stream;
}