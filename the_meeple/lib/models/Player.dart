import 'package:the_meeple/dataprovider/DBHelper.dart';

class Player {
  String name;
  DateTime created;
  DateTime lastPlayed;

  Player(this.name, this.created, this.lastPlayed);

  @override
  bool operator ==(other) => (other is Player) && (other.name == name);

  @override
  int get hashCode => name.hashCode;

  void saveUser(String name) {
    print(name);

    var player = Player(name, DateTime.now(), DateTime.now());
    var db;
    db = DBHelper();

    db.savePlayer(player);
  }
}