
import 'package:sqflite/sqflite.dart';

class DB
{
  DB._init();

  static final DB instance = DB._init();

  static Database? _database;

  Future<Database> get database async 
  {
    if(_database != null)
    {
      return _database!;
    }
    else
    {
      _database = await _initDatabase("glove.db");
      return _database!;
    }

  }

  Future<Database> _initDatabase(String dbName) async
  {
    final String dbPath = await getDatabasesPath();
    final completePath = "$dbPath/$dbName";
    return await openDatabase(
      completePath,
      version: 1,
      onCreate: _onCreate,
      onConfigure: _onConfigure,
    );
  }

  Future _onCreate(db, version) async
  {
    await db.execute(_createDeviceTable);
    await db.execute(_createLanguageTable);
    await db.execute(_createExpressionTable);
    await db.execute(_createTrainingDataTable);
  }

  Future _onConfigure(Database db) async 
  {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future close() async
  {
    final db = await instance.database;
    db.close();
  }

}


const String _createDeviceTable = 
'''
  CREATE TABLE device
  (
    id INTEGER NOT NULL UNIQUE,
    name TEXT NOT NULL,
    service_uuid TEXT NOT NULL,
    receive_data_characteristic_uuid TEXT NOT NULL,
    PRIMARY KEY("id")
  )
''';


const String _createLanguageTable = 
'''
  CREATE TABLE language
  (
    id INTEGER NOT NULL UNIQUE,
    name TEXT NOT NULL,
    machine_learning_model TEXT,
    device_id INTEGER NOT NULL,
    PRIMARY KEY("id"),
    FOREIGN KEY("device_id") REFERENCES "device"("id") ON DELETE CASCADE ON UPDATE CASCADE
  )
''';

const String _createExpressionTable = 
'''
  CREATE TABLE expression
  (
    id INTEGER NOT NULL UNIQUE,
    name TEXT NOT NULL,
    language_id INTEGER NOT NULL,
    PRIMARY KEY("id"),
    FOREIGN KEY("language_id") REFERENCES "language"("id") ON DELETE CASCADE ON UPDATE CASCADE
  )
''';

const String _createTrainingDataTable = 
'''
  CREATE TABLE training_data
  (
    id INTEGER NOT NULL UNIQUE,
    flex1_value INTEGER NOT NULL,
    flex2_value INTEGER NOT NULL,
    flex3_value INTEGER NOT NULL,
    flex4_value INTEGER NOT NULL,
    flex5_value INTEGER NOT NULL,
    mpu_ax_value REAL NOT NULL,
    mpu_ay_value REAL NOT NULL,
    mpu_az_value REAL NOT NULL,
    expression_id INTEGER NOT NULL,
    PRIMARY KEY("id"),
    FOREIGN KEY("expression_id") REFERENCES "expression"("id") ON DELETE CASCADE ON UPDATE CASCADE
  )
''';