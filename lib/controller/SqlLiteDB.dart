
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class SqlLiteDB {
 
  SqlLiteDB._privateConstructor();
  static final SqlLiteDB instance = SqlLiteDB._privateConstructor();

  static Database? _database ;
  Future<Database?> get db async {

    if (_database != null ) {_onInsert(_database, 1);return _database;}

    _database = await initDatabase();
    return _database;
  }
  initDatabase() async {
    String databasesPath = await getDatabasesPath();
    
    String path = join(databasesPath, 'myInsu.db');

    // await (await openDatabase(path)).close();
     //await deleteDatabase(path);

 
    var database = await openDatabase(path, version: 1, onCreate: _onCreate);
    
    return database;
  }
  Future _onCreate(Database db, int version) async {

print("re create db");
try{
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
        id TEXT PRIMARY KEY,
        policyNumber TEXT,
        cType TEXT,
        cLongitude TEXT,
        cLatitude TEXT,
        vehicle_no TEXT,
        chassis_number TEXT,
        effective_date TEXT,
        submit_date TEXT,
        offline INTEGER,
        status TEXT
      )
    ''');
  

}catch(e){
  print(e);
}
    // int id2 = await db.rawInsert(
    //   'INSERT IGNORE INTO customers(code, name, address) VALUES(?, ?, ?)',
    //   ['another name', 12345678, 3.1416]);

  }
  void _onInsert(Database? db, int version) async{
        try {
  
        final firestore = FirebaseFirestore.instance;

        QuerySnapshot querySnapshot = await firestore.collection('Customer').get();

        for (QueryDocumentSnapshot document in querySnapshot.docs) {
       
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;

          //await db.insert('customers', data);
          
          await db?.rawInsert(
            'INSERT OR IGNORE INTO customers(code, name, address) VALUES(?, ?, ?)',
            [data['code'], data['name'], data['address']]);
        }


        QuerySnapshot querySnapshot1 = await firestore.collection('insu').get();

        for (QueryDocumentSnapshot document1 in querySnapshot1.docs) {
       
          Map<String, dynamic> data1 = document1.data() as Map<String, dynamic>;

          //await db.insert('customers', data);
          
          await db?.rawInsert(
            'INSERT OR IGNORE INTO insu(id,policyNumber,cType,cLongitude,cLatitude,vehicle_no,chassis_number,effective_date,submit_date,status,offline) '
            'VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) ON CONFLICT(id) DO UPDATE SET status=excluded.status',
            [document1.id, data1['policyNumber'], data1['cType'],data1['cLongitude'],data1['cLatitude'],
             data1['vehicle_no'],data1['chassis_number'],data1['effective_date'],"",data1['status'],0]
             
             );
        }

     
      } catch (e) {
        print('Error fetching and storing data: $e');
       
      }
  }
}
