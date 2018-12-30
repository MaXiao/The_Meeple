import 'dart:async';

import 'package:the_meeple/models/player.dart';
import 'package:the_meeple/models/record.dart';

class AddScoreScreenBloc {
  final Record _record;
  final Player _player;

  final StreamController<Record> _recordHolder = StreamController<Record>();
  final StreamController<int> _changeScoreController = StreamController<int>();

  AddScoreScreenBloc(this._record, this._player) {
    _changeScoreController.stream.listen((delta) {
      _record.scores[_player] += delta;
      _recordHolder.add(_record);
    });
  }

  dispose() {
    _recordHolder.close();
    _changeScoreController.close();
  }

  Sink<int> get changeScore => _changeScoreController.sink;

  Stream<Record> get currentRecord => _recordHolder.stream;
}