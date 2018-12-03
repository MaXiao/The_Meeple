import 'dart:async';
import 'package:rxdart/subjects.dart';
import 'package:the_meeple/models/Player.dart';

class AddPlayerBloc {
  final List<Player> _players = List();
  final List<Player> _searchResult = List();

  final BehaviorSubject<List<Player>> _addedPlayers = BehaviorSubject<List<Player>>();
  final StreamController<String> _playerCreationController = StreamController<String>();
  final StreamController<int> _playerRemovalController = StreamController<int>();
  final StreamController<Player> _playerAdditionController = StreamController<Player>();

  final BehaviorSubject<List<Player>> _possiblePlayers = BehaviorSubject<List<Player>>();
  final StreamController<String> _searchPlayers = StreamController<String>();

  AddPlayerBloc() {
    _playerCreationController.stream.listen((string) {
      _players.add(Player(string, DateTime.now(), DateTime.now()));
      _addedPlayers.add(_players);
    });
    _playerRemovalController.stream.listen((index) {
      if (index <= _players.length) {
        _players.removeAt(index);
        _addedPlayers.add(_players);
      }
    });
    _searchPlayers.stream.listen((searchTerm) {
      _searchResult.clear();
      if (searchTerm.isEmpty) {
        _possiblePlayers.add(_searchResult);
      } else {
        _searchResult.add(Player("helen", DateTime.now(), DateTime.now()));
        _searchResult.add(Player("helena", DateTime.now(), DateTime.now()));
        _searchResult.add(Player("Halo", DateTime.now(), DateTime.now()));
        _possiblePlayers.add(_searchResult);
      }
    });
    _playerAdditionController.stream.listen((player) {
      _players.add(player);
      _addedPlayers.add(_players);
    });
  }

  dispose() {
    _playerCreationController.close();
    _playerRemovalController.close();
    _addedPlayers.close();
    _possiblePlayers.close();
  }

  Sink<String> get playerCreation => _playerCreationController.sink;
  Sink<int> get playerRemoval => _playerRemovalController.sink;
  Sink<Player> get addPlayer => _playerAdditionController.sink;
  Stream<List<Player>> get addedPlayers => _addedPlayers.stream;

  Stream<List<Player>> get possiblePlayers => _possiblePlayers.stream;
  Sink<String> get searchPlayers => _searchPlayers.sink;
}