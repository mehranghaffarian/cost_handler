import 'package:cost_handler/domain/cost_entity.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SessionDatabaseHelper {
  static const _databaseName = 'costs_database.db';
  static const table = 'COSTS';

  // make this a singleton class
  SessionDatabaseHelper._privateConstructor();

  static final SessionDatabaseHelper instance =
      SessionDatabaseHelper._privateConstructor();

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
    await db.execute(
        '''CREATE TABLE COSTS(spenderUserName VARCHAR(50), cost Double, description VARCHAR(200), receiverUsersNames VARCHAR(2000));''');
  }

  // Helper methods
  Future<int> insert(CostEntity cost) async {
    final db = await instance.database;
    final res = await db.insert(table, cost.toJson());
    db.close();
    return res;
  }

  Future<List<CostEntity>> queryAllRows() async {
    final db = await instance.database;
    final res = (await db.query(table)).map((e) => CostEntity.fromJson(e)).toList();
    db.close();
    return res;
  }
}
