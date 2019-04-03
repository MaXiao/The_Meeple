import 'dart:collection';

import 'package:the_meeple/models/game.dart';
import 'package:the_meeple/models/player.dart';
import 'package:the_meeple/models/player_record.dart';

class Record {
  DateTime date;
  Game game;
  List<PlayerRecord> playerRecords;

  List<Player> get players => playerRecords.map((record) => record.player).toList();

  Record() {
    date = DateTime.now();
    playerRecords = List();
  }

  removePlayer(Player p) {
    playerRecords.removeWhere((record) => record.player == p);
  }

  addPlayers(List<Player> players) {
    players.forEach((p) {
      if (!this.players.contains(p)) {
        playerRecords.add(PlayerRecord(p));
      }
    });
  }

  reAddPlayers(List<Player> players) {
    reset();
    addPlayers(players);
  }

  changeScore(Player p, int delta) {
    playerRecords.firstWhere((record) => record.player == p).score += delta;
  }

  resetScore() {
    playerRecords.forEach((record) {
      record.score = 0;
      record.note = null;
    });
  }

  resetScoreFor(Player p) {
    playerRecords.firstWhere((record) => record.player == p).score = 0;
  }

  scoreFor(Player p) {
    return playerRecords.firstWhere((record) => record.player == p).score;
  }

  reset() {
    playerRecords.clear();
  }

  sortByScore() {
    playerRecords.sort((a, b) => a.score.compareTo(b.score));
  }
}