import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:the_meeple/models/player.dart';

class AddRecordBloc extends ChangeNotifier {
  final dateFormat = DateFormat.yMMMd();

  final StreamController<DateTime> _selectedDate = StreamController<DateTime>();

  final List<Player> _players = [];
  UnmodifiableListView<Player> get players => UnmodifiableListView(_players);

  String dateString(DateTime date) {
    return dateFormat.format(date);
  }

  dispose() {
    _selectedDate.close();
  }

  void add(List<Player> players) {
    _players.addAll(players);
    notifyListeners();
  }

  Sink<DateTime> get selectDate => _selectedDate.sink;

  Stream<DateTime> get selectedDate => _selectedDate.stream;
}