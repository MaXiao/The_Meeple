
import 'dart:async';

import 'package:the_meeple/models/player.dart';

class PlayerEditScreenBloc {
  final StreamController<Player> _playerDeletionController = StreamController<Player>();
  final StreamController<String> _playerCreationController = StreamController<String>();
  final StreamController<String> _toastMessage = StreamController<String>();

  PlayerEditScreenBloc() {
    _playerDeletionController.stream.listen((player) async {
      final success = await player.delete();
      if (success) {

      }
    });
    
    _playerCreationController.stream.listen((name) {
      Player.checkAndcreateUser(name).then((created) {
        if (created) {

        } else {
          _toastMessage.sink.add("There is another recorded player named ${name}. ");
        }
      });
    });
  }

  dispose() {
    _playerDeletionController.close();
  }

  Sink<Player> get deletePlayer => _playerDeletionController.sink;
  Sink<String> get createPlayer => _playerCreationController.sink;

  Stream<String> get toast => _toastMessage.stream;
}