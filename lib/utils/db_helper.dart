import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DBHelper {
  static const String _databaseName = 'flashcards.db';
  static const int _databaseVersion = 2;

  DBHelper._();

  static final DBHelper _singleton = DBHelper._();

  factory DBHelper() => _singleton;

  Database? _database;

  get db async {
    _database ??= await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    //Uncoment below two lines to run code in windows
    // sqfliteFfiInit();
    // databaseFactory = databaseFactoryFfi;
    var dbDir = await getApplicationDocumentsDirectory();
    var dbPath = path.join(dbDir.path, _databaseName);

    // await deleteDatabase(dbPath); // For testing

    var db = await openDatabase(dbPath,
        version: _databaseVersion, onCreate: _onCreate);

    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE categories(
        id INTEGER PRIMARY KEY,
        title TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE flashcards(
        id INTEGER PRIMARY KEY,
        categoryId INTEGER,
        question TEXT,
        answer TEXT
      )
    ''');
  }

  Future<List<Map<String, dynamic>>> queryCategories(
      {String? where, List<dynamic>? whereArgs}) async {
    final db = await this.db;
    return db.query('categories', where: where, whereArgs: whereArgs);
  }

  Future<List<Map<String, dynamic>>> queryFlashcards(
      {String? where, List<dynamic>? whereArgs}) async {
    final db = await this.db;
    return db.query('flashcards', where: where, whereArgs: whereArgs);
  }

  Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await this.db;
    return db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> update(String table, Map<String, dynamic> data) async {
    final db = await this.db;
    final id = data['id'];
    if (id != null) {
      await db.update(table, data, where: 'id = ?', whereArgs: [id]);
    }
  }

  Future<void> clearDatabase() async {
    final Database db = await this.db;

    // Clear all tables in the database
    await db.delete('categories');
    await db.delete('flashcards');
  }

  Future<void> delete(String table, int id) async {
    final db = await this.db;
    await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}
