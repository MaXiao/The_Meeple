import 'dart:async';
import 'dart:collection';

import 'package:rxdart/rxdart.dart';
import 'package:the_meeple/models/record.dart';
import 'package:the_meeple/models/player.dart';


class ScoringBloc {
  final Record _record = Record();

  final BehaviorSubject<Record> _recordHolder = BehaviorSubject<Record>();
  final StreamController<List<Player>> _selectPlayers = StreamController<List<Player>>();
  final StreamController<Player> _removePlayer = StreamController<Player>();
  final StreamController<LinkedHashMap<Player, int>> _updateScores = StreamController<LinkedHashMap<Player, int>>();

  ScoringBloc() {
    _selectPlayers.stream.listen((players) {
      _record.reAddPlayers(players);
      _recordHolder.add(_record);
    });

    _updateScores.stream.listen((scores) {
      _record.scores = scores;
      _recordHolder.add(_record);
    });
  }

  dispose() {
    _recordHolder.close();
    _selectPlayers.close();
    _removePlayer.close();
  }

  Stream<Record> get record => _recordHolder.stream;

  Sink<List<Player>> get selectPlayers => _selectPlayers.sink;
  Sink<Player> get removePlayer => _removePlayer.sink;
  Sink<LinkedHashMap<Player, int>> get updateScore => _updateScores.sink;
}