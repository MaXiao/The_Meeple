import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:the_meeple/models/Player.dart';

class ScoringBloc {
  final List<Player> _players = List();

  final BehaviorSubject<List<Player>> _playersHolder = BehaviorSubject<List<Player>>();
  final StreamController<List<Player>> _selectPlayers = StreamController<List<Player>>();
  final StreamController<Player> _removePlayer = StreamController<Player>();

  ScoringBloc() {
    _selectPlayers.stream.listen((players) {
      _players.clear();
      _players.addAll(players);
      _playersHolder.add(_players);
    });
  }

  Stream<List<Player>> get players => _playersHolder.stream;

  Sink<List<Player>> get selectPlayers => _selectPlayers.sink;
  Sink<Player> get removePlayer => _removePlayer.sink;
}