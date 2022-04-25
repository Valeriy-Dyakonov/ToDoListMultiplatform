import 'dart:async';
import 'dart:io';

import 'package:ios_android_flutter/rest/sqlite/task_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  late Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "database");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE IF NOT EXISTS notes ("
          "id INTEGER PRIMARY KEY,"
          "name TEXT,"
          "category TEXT,"
          "date TEXT,"
          "content TEXT,"
          "done TEXT"
          ")");
    });
  }

  newTask(Task task) async {
    final db = await database;
    var raw = await db.rawInsert(
        "INSERT Into notes (name,category,date,content,done)"
        " VALUES (?,?,?,?)",
        [task.name, task.category, task.date, task.content, task.done]);
    return raw;
  }

  changeStatus(Task task) async {
    final db = await database;
    var values = <String, dynamic>{};
    values.putIfAbsent("done", () => task.done);
    var res =
        await db.update("notes", values, where: "id = ?", whereArgs: [task.id]);
    return res;
  }

  updateTask(Task task) async {
    final db = await database;
    var res = await db
        .update("notes", task.toMap(), where: "id = ?", whereArgs: [task.id]);
    return res;
  }

  deleteAll(List<Task> tasks) async {
    final db = await database;
    for (var task in tasks) {
      db.rawDelete("Delete * from notes  WHERE id = ?", [task.id]);
    }
  }
}
