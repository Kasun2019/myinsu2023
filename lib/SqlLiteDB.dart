import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlLiteDB {
 
  SqlLiteDB._privateConstructor();
  static final SqlLiteDB instance = SqlLiteDB._privateConstructor();

  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await initDatabase();
    return _database;
  }
  initDatabase() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'myInsu.db');

 
    var database = await openDatabase(path, version: 1, onCreate: _onCreate);
    return database;
  }
  void _onCreate(Database db, int version) async {
 
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY,
        name TEXT,
        email TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE customers (
        code TEXT PRIMARY KEY,
        name TEXT,
        address TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE insu (
        policyNumber TEXT PRIMARY KEY,
        cType TEXT,
        cLongitude TEXT,
        cLatitude TEXT
      )
    ''');


  




  }
}
