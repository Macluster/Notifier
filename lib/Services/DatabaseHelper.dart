import 'dart:async';
import 'dart:io';

import 'package:notifier/Models/NotificationModel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  String tabelName = "Notifications";
  String DatabaseName = "Notifier";

  static Database? database;

  DatabaseHelper.constructor();
  static final DatabaseHelper instance = DatabaseHelper.constructor();

  Future<Database?> get db async {
    if (database != null) return database;

    database = await initDb();
    return database;
  }

  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, DatabaseName);
    var db = await openDatabase(path, version: 1, onCreate: oncreate);
    return db;
  }

  oncreate(Database db, int version) async {
    await db.execute(
        "create table $tabelName(title Text ,date Text,time Text,id Integer)");
  }

  Future<int> insert(String title, String date, String time, int id) async {
    Database? db = await instance.db;

    await db!.execute("insert into $tabelName values('" +
        title +
        "','" +
        date +
        "','" +
        time +
        "'," +
        id.toString() +
        ")");

    return 1;
  }

  Future<List<NotificationModel>> getData() async {
    Database? db = await instance.db;

    var map = await db?.rawQuery('select * from $tabelName');

    List<NotificationModel> list = [];

    if (map != null)
      map.forEach((element) {
        NotificationModel model = new NotificationModel.fromMap(element);

        list.add(model);
      });

    return list;
  }

  Future<int> DeleteRecord(String title) async {
    Database? db = await instance.db;

    db!.execute("delete from $tabelName where title='" + title + "'");
    return 1;
  }
}
