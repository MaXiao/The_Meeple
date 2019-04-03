import 'dart:async';
import 'dart:io' as io;
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:the_meeple/models/player.dart';


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
        "CREATE TABLE Player(id INTEGER PRIMARY KEY, name TEXT, created INTEGER, last_played INTEGER, avatar TEXT )"
    );
  }

  Future<bool> savePlayer(Player p) async {
    var dbClient = await db;
    final result = await dbClient.insert("Player", p.toMap());
    return result > 0;
  }

  Future<bool> removePlayer(Player p) async {
    var dbClient = await db;
    final result = await dbClient.delete("Player", where: "id = ?", whereArgs: [p.id]);
    return result > 0;
  }

  Future<bool> updatePlayer(Player p) async {
    var dbClient = await db;
    final result = await dbClient.update("Player", p.toMap(), where: "id = ?", whereArgs: [p.id]);
    return result > 0;
  }

  Future<List<Player>> getPlayers() async {
    var dbClient = await db;
    //var result = await database.query("Player", columns: ["id", "name", "created", "last_played"]);
    List<Map> list = await dbClient.rawQuery('SELECT * FROM Player');
    return list.map((json) => Player.fromMap(json)).toList();
  }
}