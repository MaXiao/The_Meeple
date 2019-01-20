import 'dart:collection';

import 'package:the_meeple/models/game.dart';
import 'package:the_meeple/models/Group.dart';
import 'package:the_meeple/models/player.dart';

class Record {
  DateTime playDate;
  Game game;
  LinkedHashMap<Player, int> scores;

  List<Player> get players => scores.keys.toList();

  Record() {
    playDate = DateTime.now();
    scores = LinkedHashMap();
  }

  removePlayer(Player p) {
    scores.remove(p);
  }

  addPlayers(List<Player> players) {
    players.forEach((p) {
      if (!scores.containsKey(p)) {
        scores[p] = 0;
      }
    });
  }

  reAddPlayers(List<Player> players) {
    scores.clear();
    addPlayers(players);
  }

  changeScore(Player p, int delta) {
    scores[p] += delta;
  }

  resetScore() {
    scores.forEach((p, _) {
      scores[p] = 0;
    });
  }

  reset() {
    scores.clear();
  }

  sortByScore() {
    scores = LinkedHashMap.fromEntries(scores.entries.toList()..sort((e1, e2) =>
        e1.value.compareTo(e2.value)));
  }
}