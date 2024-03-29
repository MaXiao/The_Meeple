import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:the_meeple/dataprovider/DBHelper.dart';
import 'package:the_meeple/models/player.dart';

class AddPlayerScreenBloc {
  final List<Player> _players = List();
  final List<Player> _selectedPlayers = List();

  final BehaviorSubject<List<Player>> _playersHolder = BehaviorSubject<List<Player>>();
  final BehaviorSubject<List<Player>> _selectedPlayersHolder = BehaviorSubject<List<Player>>();

  final StreamController<String> _toastMessage = StreamController<String>();
  final StreamController<List<Player>> _playersSelectionController = StreamController<List<Player>>();
  final StreamController<Player> _playerSelectionToggleController = StreamController<Player>();
  final StreamController<String> _playerCreationController = StreamController<String>();
  final StreamController<bool> _toggleCancelButton = StreamController<bool>();

  AddPlayerScreenBloc() {
    DBHelper().getPlayers().then((players) {
      _players.clear();
      _players.addAll(players);
      _playersHolder.add(_players);
    });

    _playersSelectionController.stream.listen((players) {
      _selectedPlayers.clear();
      _selectedPlayers.addAll(players);
      _playersHolder.add(_players);
      _selectedPlayersHolder.add(_selectedPlayers);
    });

    _playerSelectionToggleController.stream.listen((player) {
      if (_selectedPlayers.contains(player)) {
        _selectedPlayers.remove(player);
      } else {
        _selectedPlayers.add(player);
      }
      _selectedPlayersHolder.add(_selectedPlayers);
    });

    _playerCreationController.stream.listen((name) {
      if (name.length == 0) {
        return;
      }

      final player = Player(name: name, created: DateTime.now(), lastPlayed: DateTime.now());
      
      if (_players.contains(player)) {
        _toastMessage.sink.add("There is another recorded player named ${player.name}. ");
      } else {
        Player.createUser(name);

        _players.insert(0, player);
        _selectedPlayers.add(player);
        _playersHolder.add(_players);
        _selectedPlayersHolder.add(_selectedPlayers);

        _toastMessage.sink.add("Player added");
      }
    });
  }

  dispose() {
    _playersHolder.close();
    _playersSelectionController.close();
    _playerSelectionToggleController.close();
    _playerCreationController.close();
    _toggleCancelButton.close();
    _toastMessage.close();
  }

  Sink<List<Player>> get selectPlayers => _playersSelectionController.sink;
  Sink<Player> get toggleSelection => _playerSelectionToggleController.sink;
  Sink<String> get createPlayer => _playerCreationController.sink;
  Sink<bool> get toggleCancelBtn => _toggleCancelButton.sink;

  Stream<List<Player>> get players => _playersHolder.stream;
  Stream<List<Player>> get selectedPlayers => _selectedPlayersHolder.stream;
  Stream<String> get toast => _toastMessage.stream;
  Stream<bool> get showCancelBtn => _toggleCancelButton.stream;
}