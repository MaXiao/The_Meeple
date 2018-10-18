import 'dart:async';
import 'dart:io' as io;
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:the_meeple/models/Player.dart';


class DBHelper {
  static Database _db;

  Future<Database> get db async {
    if(_db == null) {
      _db = await initDB();
    }
    return _db;
  }

  initDB() async {
    io.Directory docDirectory = await getApplicationDocumentsDirectory();
    String path = p.join(docDirectory.path, "meeple.db");
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int version) async {
    //create the table when creating db
    await db.execute(
        "CREATE TABLE Player(id INTEGER PRIMARY KEY, name TEXT, created INTEGER, lastPlayed INTEGER )"
    );
  }

  void savePlayer(Player p) async {
    var dbClient = await db;
    
    await dbClient.transaction((txn) async {
      return await txn.rawInsert('INSERT INTO Player(name, created, lastPlayed) VALUES(\"${p.name}\", ${p.created.millisecondsSinceEpoch}, ${p.lastPlayed.millisecondsSinceEpoch})');
    });
  }

  Future<List<Player>> getPlayers() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM Player');
    List<Player> players = List();
    list.forEach((map) =>
        players.add(Player(map['name'],
            DateTime.fromMillisecondsSinceEpoch(map['created']),
            DateTime.fromMillisecondsSinceEpoch(map['lastPlayed'])))
    );
    return players;
  }
}