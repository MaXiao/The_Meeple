
import 'dart:async';

import 'package:the_meeple/dataprovider/DBHelper.dart';
import 'package:the_meeple/models/player.dart';

class PlayersScreenBloc {
  List<Player> _players = List();

  final StreamController<List<Player>> _playersHolder = StreamController<List<Player>>();
  final StreamController<Player> _playerAdditionController = StreamController<Player>();

  PlayersScreenBloc() {
    _playerAdditionController.stream.listen((player) {
      _players.add(player);
      _playersHolder.add(_players);
    });
  }

  void addPlayer(Player p) {
    _playerAdditionController.add(p);
  }

  void refresh() {
    DBHelper().getPlayers().then((players) {
      _playersHolder.add(players);
      _players = players;
    });
  }

  dispose() {
    _playersHolder.close();
  }

  Stream<List<Player>> get players => _playersHolder.stream;
}