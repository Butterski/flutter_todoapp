import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper.internal();
  factory DBHelper() => _instance;
  DBHelper.internal();

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDb();
    return _db!;
  }

  initDb() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'todos.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE Todo(id INTEGER PRIMARY KEY, user TEXT, task TEXT)');
  }

  Future<int> saveTask(String user, String task) async {
    var dbClient = await db;
    var result = await dbClient.insert("Todo", {'user': user, 'task': task});
    return result;
  }

  Future<List<Map<String, dynamic>>> getAllTasks(String user) async {
    var dbClient = await db;
    var result = await dbClient.query("Todo", where: 'user = ?', whereArgs: [user]);
    return result.toList();
  }

  Future<int> deleteTask(int id) async {
    var dbClient = await db;
    return await dbClient.delete("Todo", where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateTask(int id, String task) async {
    var dbClient = await db;
    return await dbClient.update("Todo", {'task': task},
        where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> initDesktop() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  static Future<void> initMobile() async {
  }
}
