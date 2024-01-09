import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'your_database_name.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        // Create your tables here
        await db.execute(
            'CREATE TABLE your_table_name(id INTEGER PRIMARY KEY, name TEXT)');
      },
    );
  }

  Future<void> insertData(String tableName, Map<String, dynamic> data) async {
    final Database db = await database;
    await db.insert(tableName, data,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> fetchData(String tableName) async {
    final Database db = await database;
    return await db.query(tableName);
  }
}
