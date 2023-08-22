import 'package:cost_handler/domain/user_entity.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class UsersDatabaseHelper {
  static const _databaseName = 'users_database.db';
  static const table = 'USERS';

  final String userNameColumn = "userName";
  // make this a singleton class
  UsersDatabaseHelper._privateConstructor();
  static final UsersDatabaseHelper instance = UsersDatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;
  Future<Database> get database async {
    if(_database == null || !_database!.isOpen) {
      await _initDatabase();
    }
    return _database!;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    final documentsDirectory = await getDatabasesPath();
    final path = join(documentsDirectory, _databaseName);
    _database = await openDatabase(path, onCreate: _onCreate, version: 1);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    // await db.execute('''CREATE TABLE COSTS(value Double, description VARCHAR(200), destinationUserName VARCHAR(50), ID int, PRIMARY KEY (id));''');
    await db.execute('''CREATE TABLE USERS($userNameColumn VARCHAR(100), PRIMARY KEY($userNameColumn));''');
  }

  Future<int> delete(String username) async {
    try{
      final db = await instance.database;
      final res = await db.delete(table, where: "$userNameColumn == \"$username\"");
      return res;
    }catch(_){return 0;}
  }

  Future<int> deleteAll() async {
    try{
      final db = await instance.database;
      final res = await db.delete(table);
      return res;
    }catch(_){return 0;}
  }

    Future<int> insert(String newUserName) async {
    try{
      final db = await instance.database;
      return await db.insert(table, {userNameColumn: newUserName});
    }catch(_){
      return 0;
    }
  }

  Future<List<UserEntity>> queryAllRows() async {
    final db = await instance.database;
    final res = (await db.query(table)).map((e) => UserEntity.fromJson(e)).toList();
    db.close();
    return res;
  }
}
