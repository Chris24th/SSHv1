import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database;
  static const String usersTable = 'Users';
  static const String sensorsTable = 'Sensors';

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    // Initialize the sqflite databaseFactory
    await _initDatabaseFactory();

    _database = await initDatabase();
    return _database!;
  }

  Future<void> _initDatabaseFactory() async {
    try {
      // You can initialize other settings here if needed
    } catch (e) {
      print("Error initializing databaseFactory: $e");
    }
  }

  Future<Database> initDatabase() async {
    final String path = join(await getDatabasesPath(), 'your_database.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE $usersTable (
            userID INTEGER PRIMARY KEY,
            password TEXT,
            phoneNumber INTEGER,
            username TEXT,
            isVerified INTEGER
          )
        ''');

        await db.execute('''
          CREATE TABLE $sensorsTable (
            userID INTEGER,
            dataID INTEGER PRIMARY KEY,
            tempVal REAL,
            mq135Val REAL,
            isImpactDetected INTEGER,
            timeRead TEXT,
            FOREIGN KEY (userID) REFERENCES $usersTable(userID)
          )
        ''');
      },
    );
  }

  Future<int> insertUser(Map<String, dynamic> user) async {
    final Database db = await database;
    return await db.insert(usersTable, user);
  }

  Future<int> insertSensor(Map<String, dynamic> sensor) async {
    final Database db = await database;
    return await db.insert(sensorsTable, sensor);
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    final Database db = await database;
    return await db.query(usersTable);
  }

  Future<List<Map<String, dynamic>>> getSensors() async {
    final Database db = await database;
    return await db.query(sensorsTable);
  }
}
