import 'package:nugasyik/homework.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;

  DatabaseHelper._internal() {
    _databaseHelper = this;
  }

  factory DatabaseHelper() => _databaseHelper ?? DatabaseHelper._internal();

  static late Database _database;

  Future<Database> get database async {
    return _database = await _initializeDb();
  }

  static const String _tableName = 'homework';

  Future<Database> _initializeDb() async {
    var path = await getDatabasesPath();
    var db = openDatabase(
      join(path, 'homework_db.db'),
      onCreate: (db, version) async {
        await db.execute(
            '''CREATE TABLE $_tableName (id INTEGER PRIMARY KEY, title TEXT, subject TEXT, description TEXT, deadline TEXT)''');
      },
      version: 1,
    );
    return db;
  }

  Future<void> insertHomework(Homework homework) async {
    final Database db = await database;
    await db.insert(
      _tableName,
      homework.toMap(),
    );
  }

  Future<List<Homework>> getHomeworks() async {
    final Database db = await database;
    List<Map<String, dynamic>> result =
        await db.query(_tableName, orderBy: "deadline ASC");

    return result.map((res) => Homework.fromMap(res)).toList();
  }

  Future<int?> updateHomework(Homework homework) async {
    var dbClient = await _database;
    return await dbClient.update(_tableName, homework.toMap(),
        where: 'id = ?', whereArgs: [homework.id]);
  }

  //hapus database
  Future<int?> deleteHomework(int? id) async {
    var dbClient = await _database;
    return await dbClient.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }
}
