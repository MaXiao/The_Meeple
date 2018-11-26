import 'dart:async';
import 'package:rxdart/subjects.dart';
import 'package:the_meeple/models/Player.dart';

class AddPlayerBloc {
  final List<Player> _players = List();

  final BehaviorSubject<List<Player>> _items = BehaviorSubject<List<Player>>();
  final StreamController<String> _playerAdditionController = StreamController<String>();
  final StreamController<int> _playerRemovalController = StreamController<int>();

  AddPlayerBloc() {
    _playerAdditionController.stream.listen((string) {
      _players.add(Player(string, DateTime.now(), DateTime.now()));
      _items.add(_players);
    });
    _playerRemovalController.stream.listen((index) {
      if (index <= _players.length) {
        _players.removeAt(index);
        _items.add(_players);
      }
    });
  }

  dispose() {
    _playerAdditionController.close();
    _playerRemovalController.close();
    _items.close();
  }

  Sink<String> get playerAddition => _playerAdditionController.sink;
  Sink<int> get playerRemoval => _playerRemovalController.sink;
  Stream<List<Player>> get items => _items.stream;
}