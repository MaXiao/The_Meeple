import 'package:the_meeple/models/player.dart';

class PlayerRecord {
  Player player;
  int score;
  String note;

  PlayerRecord(Player p) {
    this.player = p;
    score = 0;
  }
}