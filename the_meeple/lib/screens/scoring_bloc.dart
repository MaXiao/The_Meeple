import 'dart:async';
import 'dart:collection';

import 'package:rxdart/rxdart.dart';
import 'package:the_meeple/models/player_record.dart';
import 'package:the_meeple/models/record.dart';
import 'package:the_meeple/models/player.dart';


class ScoringBloc {
  final Record _record = Record();

  final BehaviorSubject<Record> _recordHolder = BehaviorSubject<Record>();

  final StreamController<List<Player>> _selectPlayers = StreamController<List<Player>>();
  final StreamController<Player> _removePlayer = StreamController<Player>();
  final StreamController<List<PlayerRecord>> _updateScores = StreamController<List<PlayerRecord>>();
  final StreamController<Player> _resetPlayer = StreamController<Player>();
  final StreamController<Null> _startNew = StreamController();
  final StreamController<Null> _resetScores = StreamController();
  final StreamController<Null> _rankScores = StreamController();

  ScoringBloc() {
    _selectPlayers.stream.listen((players) {
      _record.reAddPlayers(players);
      _recordHolder.add(_record);
    });

    _updateScores.stream.listen((records) {
      _record.playerRecords = records;
      _recordHolder.add(_record);
    });
    _removePlayer.stream.listen((player) {
      _record.removePlayer(player);
      _recordHolder.add(_record);
    });
    _resetPlayer.stream.listen((player) {
      _record.resetScoreFor(player);
      _recordHolder.add(_record);
    });
    _startNew.stream.listen((_) {
      _record.reset();
      _recordHolder.add(_record);
    });
    _resetScores.stream.listen((_) {
      _record.resetScore();
      _recordHolder.add(_record);
    });
    _rankScores.stream.listen((_) {
      _record.sortByScore();
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
    _resetScores.close();
    _rankScores.close();
  }

  Stream<Record> get record => _recordHolder.stream;

  Sink<List<Player>> get selectPlayers => _selectPlayers.sink;
  Sink<Player> get removePlayer => _removePlayer.sink;
  Sink<List<PlayerRecord>> get updateScore => _updateScores.sink;
  Sink<Player> get resetPlayer => _resetPlayer.sink;
  Sink<Null> get startNew => _startNew.sink;
  Sink<Null> get resetScores => _resetScores.sink;
  Sink<Null> get rankScores => _rankScores.sink;
}