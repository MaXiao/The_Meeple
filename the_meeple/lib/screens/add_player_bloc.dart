import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:the_meeple/models/Player.dart';

class AddPlayerScreenBloc {
  final List<Player> _players = List();
  final List<int> _selectionState = List();

  final BehaviorSubject<List<Player>> _playersHolder = BehaviorSubject<List<Player>>();
  final StreamController<List<Player>> _playersSelectionController = StreamController<List<Player>>();
  final StreamController<Player> _playerUnselectionController = StreamController<Player>();
  final StreamController<String> _playerCreationController = StreamController<String>();

  AddPlayerScreenBloc() {
    _playersSelectionController.stream.listen((players) {
      _players.clear();
      _players.addAll(players);
      _playersHolder.add(_players);
    });

    _playerUnselectionController.stream.listen((player) {
      _players.remove(player);
      _playersHolder.add(_players);
    });
    _playerCreationController.stream.listen((name) {
      final player = Player(name, DateTime.now(), DateTime.now());
      _players.insert(0, player);
      _playersHolder.add(_players);
    });
  }

  dispose() {
    _playersHolder.close();
    _playersSelectionController.close();
    _playerUnselectionController.close();
    _playerCreationController.close();
  }

  Sink<List<Player>> get selectPlayers => _playersSelectionController.sink;
  Sink<Player> get unselectPlayer => _playerUnselectionController.sink;
  Sink<String> get createPlayer => _playerCreationController.sink;

  Stream<List<Player>> get selectedPlayers => _playersHolder.stream;
}