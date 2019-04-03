import 'dart:async';

import 'package:the_meeple/models/player.dart';
import 'package:the_meeple/models/record.dart';

class AddScoreScreenBloc {
  final Record _record;

  final StreamController<Record> _recordHolder = StreamController<Record>();
  final StreamController<Map<Player, int>> _changeScoreController = StreamController<Map<Player, int>>();

  AddScoreScreenBloc(this._record) {
    _changeScoreController.stream.listen((delta) {
      final player = delta.keys.first;
      _record.changeScore(player, delta[player]);
      _recordHolder.add(_record);
    });
  }

  dispose() {
    _recordHolder.close();
    _changeScoreController.close();
  }

  Sink<Map<Player, int>> get changeScore => _changeScoreController.sink;

  Stream<Record> get currentRecord => _recordHolder.stream;
}