import 'package:the_meeple/dataprovider/DBHelper.dart';
import 'package:the_meeple/utils/emojis.dart';

class Player {
  int id;
  String name;
  DateTime created;
  DateTime lastPlayed;
  String avatar;

  Player({this.id, this.name, this.created, this.lastPlayed, this.avatar});

  @override
  bool operator ==(other) =>
      (other is Player) && (other.name.toLowerCase() == name.toLowerCase());

  @override
  int get hashCode => name.hashCode;

  static Future<Player> checkAndCreateUser({String name, String avatar}) async {
    var player = Player(name: name, created: DateTime.now(), lastPlayed: DateTime.now(), avatar:avatar);
    final db = DBHelper();

    final players = await db.getPlayers();

    if (players.contains(player)) {
      return null;
    } else {
      db.savePlayer(player);
      return player;
    }
  }

  static void createUser(String name) {
    var player = Player(name: name, created: DateTime.now(), lastPlayed: DateTime.now());
    final db = DBHelper();
    db.savePlayer(player);
  }

  Future<bool> checkAndUpdate() async {
    final db = DBHelper();
    final players = await db.getPlayers();

    if (players.contains(this)) {
      return null;
    } else {
      return update();
    }
  }

  Future<bool> delete() async {
    final db = DBHelper();
    return db.removePlayer(this);
  }

  Future<bool> update() async {
    final db = DBHelper();
    return db.updatePlayer(this);
  }

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "created": created.millisecondsSinceEpoch,
    "last_played": lastPlayed.millisecondsSinceEpoch,
    "avatar": avatar,
  };

  factory Player.fromMap(Map<String, dynamic> data) => Player(
    id: data["id"],
    name: data["name"],
    created: DateTime.fromMillisecondsSinceEpoch(data['created']),
    lastPlayed: DateTime.fromMillisecondsSinceEpoch(data['last_played']),
    avatar: data["avatar"],
  );
}
