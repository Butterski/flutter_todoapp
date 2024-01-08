import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<Database> initDatabase() async {
  sqfliteFfiInit();

  String databasePath = join(await getDatabasesPath(), 'todos.db');

  return await databaseFactoryFfi.openDatabase(databasePath, options: OpenDatabaseOptions(
    version: 1,
    onCreate: (db, version) async {
      await db.execute('CREATE TABLE Todo(id INTEGER PRIMARY KEY, user TEXT, task TEXT)');
    },
  ));
}
