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
  final StreamController<Player> _resetPlayer = StreamController<Player>();
  final StreamController<Null> _startNew = StreamController();

  ScoringBloc() {
    _selectPlayers.stream.listen((players) {
      _record.reAddPlayers(players);
      _recordHolder.add(_record);
    });

    _updateScores.stream.listen((scores) {
      _record.scores = scores;
      _recordHolder.add(_record);
    });
    _removePlayer.stream.listen((player) {
      _record.scores.remove(player);
      _recordHolder.add(_record);
    });
    _resetPlayer.stream.listen((player) {
      _record.scores[player] = 0;
      _recordHolder.add(_record);
    });
    _startNew.stream.listen((_) {
      _record.reset();
      _recordHolder.add(_record);
    });
  }

  dispose() {
    _recordHolder.close();
    _selectPlayers.close();
    _removePlayer.close();
    _updateScores.close();
    _resetPlayer.close();
    _startNew.close();
  }

  Stream<Record> get record => _recordHolder.stream;

  Sink<List<Player>> get selectPlayers => _selectPlayers.sink;
  Sink<Player> get removePlayer => _removePlayer.sink;
  Sink<LinkedHashMap<Player, int>> get updateScore => _updateScores.sink;
  Sink<Player> get resetPlayer => _resetPlayer.sink;
  Sink<Null> get startNew => _startNew.sink;
}