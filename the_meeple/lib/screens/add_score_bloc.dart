import 'dart:async';

class AddScoreScreenBloc {
  int _currentScore = 0;

  final StreamController<int> _currentScoreHolder = StreamController<int>();

  final StreamController<int> _changeScoreController = StreamController<int>();

  AddScoreScreenBloc() {


    _changeScoreController.stream.listen((delta) {
      _currentScore += delta;
      _currentScoreHolder.add(_currentScore);
    });
  }

  Sink<int> get changeScore => _changeScoreController.sink;

  Stream<int> get currentScore => _currentScoreHolder.stream;
}