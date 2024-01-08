import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> initDatabase() async {
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'todos.db');
  var db = await openDatabase(path, version: 1, onCreate: (db, version) {
    db.execute('CREATE TABLE Todo(id INTEGER PRIMARY KEY, user TEXT, task TEXT)');
  });
  return db;
}
