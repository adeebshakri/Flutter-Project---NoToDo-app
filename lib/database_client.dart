import 'dart:async';
import 'dart:io';
import 'package:notodo_app/nodo_item.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();//We are creating DatabaseHelper instance so that we dont have to continuosly create the object DatabaseHelper when we want to use it(singleton design pattern)

  factory DatabaseHelper() => _instance;

  final String tableName = "nodoTbl"; //will prevent use from making mistakes while coding
  final String columnId = "id";
  final String columnItemName = "itemName";
  final String columnDateCreated = "dateCreated";

  static Database _db; //created a static member: so that we can use it to return our db and initialize it so that it is ready to use it

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {  //initDb is called when we are asked to receive the database and sets everything up
    Directory documentDirectory = await getApplicationDocumentsDirectory(); //to get getApplicationDocumentsDirectory from android and ios
    String path = join(documentDirectory.path, "notodo_path.db");

    var _ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return _ourDb;
  }
  void _onCreate(Database db, int newVersion) async {
    await db.execute(
        "CREATE TABLE $tableName($columnId INTEGER PRIMARY KEY,$columnItemName TEXT, $columnDateCreated TEXT)");
    print("Table is created");
    /*
    id | username | password
    1  | Adeeb    | ad123
    2  | Dholu    | dh123
     */
  }
  //Insertion

  Future<int> saveItem(NoDoItem item) async {
    var dbClient = await db;
    int res = await dbClient.insert("$tableName", item.toMap());
    print(res.toString());
    return res;
  }

  //Get
  Future<List> getItems() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $tableName ORDER BY $columnItemName ASC");
    return result.toList();
  }

  //Get count
  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(
        await dbClient.rawQuery("SELECT COUNT(*) FROM $tableName"));
  }

  //Get one item from its id
  Future<NoDoItem> getItem(int id) async {
    var dbClient = await db;
    var result = await dbClient
        .rawQuery("SELECT * FROM $tableName WHERE $columnId = $id");
    if (result.length == 0) return null;
    return new NoDoItem.fromMap(result.first); //will give the first value from the table
  }

  //delete item
  Future<int> deleteItem(int id) async{
    var dbClient = await db;
    return await dbClient.delete(tableName, where: "$columnId=?",whereArgs: [id]);// just a different syntax
  }

  //update item
  Future<int> updateItem(NoDoItem user) async{
    var dbClient = await db;
    return await dbClient.update(tableName,user.toMap(),where: "$columnId = ?",whereArgs: [user.id]);
  }
  //close database
  Future close() async{
    var dbClient = await db;
    return dbClient.close();
  }
}


