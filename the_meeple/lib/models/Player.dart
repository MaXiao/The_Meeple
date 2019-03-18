import 'package:the_meeple/dataprovider/DBHelper.dart';

class Player {
  String name;
  DateTime created;
  DateTime lastPlayed;

  Player(this.name, this.created, this.lastPlayed);

  @override
  bool operator ==(other) =>
      (other is Player) && (other.name.toLowerCase() == name.toLowerCase());

  @override
  int get hashCode => name.hashCode;

  static Future<bool> checkAndcreateUser(String name) async {
    var player = Player(name, DateTime.now(), DateTime.now());
    final db = DBHelper();

    final players = await db.getPlayers();

    if (players.contains(player)) {
      return false;
    } else {
      db.savePlayer(player);
      return true;
    }
  }

  static void createUser(String name) {
    var player = Player(name, DateTime.now(), DateTime.now());
    final db = DBHelper();
    db.savePlayer(player);
  }

  Future<bool> delete() async {
    final db = DBHelper();
    return db.removePlayer(this);
  }
}
