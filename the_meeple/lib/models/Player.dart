import 'package:the_meeple/dataprovider/DBHelper.dart';

class Player {
  int id;
  String name;
  DateTime created;
  DateTime lastPlayed;

  Player({this.id, this.name, this.created, this.lastPlayed});

  @override
  bool operator ==(other) =>
      (other is Player) && (other.name.toLowerCase() == name.toLowerCase());

  @override
  int get hashCode => name.hashCode;

  static Future<Player> checkAndcreateUser(String name) async {
    var player = Player(name: name, created: DateTime.now(), lastPlayed: DateTime.now());
    final db = DBHelper();

    final players = await db.getPlayers();

    if (players.contains(player)) {
      return null;
    } else {
      db.savePlayer(player);
      return player;
    }
  }

  static Future<Player> checkAndUpdateUser(Player player, String newName) async {
    final db = DBHelper();

    final players = await db.getPlayers();
    player.name = newName;

    if (players.contains(player)) {
      return null;
    } else {
      db.updatePlayer(player);
      return player;
    }
  }

  static void createUser(String name) {
    var player = Player(name: name, created: DateTime.now(), lastPlayed: DateTime.now());
    final db = DBHelper();
    db.savePlayer(player);
  }

  Future<bool> delete() async {
    final db = DBHelper();
    return db.removePlayer(this);
  }

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "created": created.millisecondsSinceEpoch,
    "last_played": lastPlayed.millisecondsSinceEpoch,
  };

  factory Player.fromMap(Map<String, dynamic> data) => Player(
    id: data["id"],
    name: data["name"],
    created: DateTime.fromMillisecondsSinceEpoch(data['created']),
    lastPlayed: DateTime.fromMillisecondsSinceEpoch(data['last_played']),
  );
}
