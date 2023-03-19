import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class UsersDatabaseHelper {
  static const _databaseName = 'users_database.db';
  static const table = 'users_table';

  final String userNameColumn = "userName";
  // make this a singleton class
  UsersDatabaseHelper._privateConstructor();
  static final UsersDatabaseHelper instance = UsersDatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;
  Future<Database> get database async {
    return _database ??= await _initDatabase();
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    final documentsDirectory = await getDatabasesPath();
    final path = join(documentsDirectory, _databaseName);
    return await openDatabase(path, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    // await db.execute('''CREATE TABLE COSTS(value Double, description VARCHAR(200), destinationUserName VARCHAR(50), ID int, PRIMARY KEY (id));''');
    await db.execute('''CREATE TABLE USERS($userNameColumn VARCHAR(75), PRIMARY KEY (receiverUserName));''');
  }

  // Helper methods
  Future<int> insert(String newUserName) async {
    final db = await instance.database;
    return await db.insert(table, {userNameColumn: newUserName});
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    final db = await instance.database;
    return await db.query(table);
  }
}
