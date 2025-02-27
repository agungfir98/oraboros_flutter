import "package:flutter/services.dart";
import "package:oraboros/src/model/category.model.dart" as budget;
import "package:path/path.dart";
import "package:sqflite/sqflite.dart";

class DBHelper {
  // singleton pattern
  static final DBHelper _instance = DBHelper._internal();
  static Database? _database;

  factory DBHelper() => _instance;

  DBHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database?> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'oraboros.db');

    return await openDatabase(
      path,
      onCreate: _onCreate,
      version: 1,
    );
  }

  _onCreate(Database db, int version) async {
    String sql = await _loadSQL();
    List<String> queries = sql.split(';');

    for (var query in queries) {
      if (query.trim().isNotEmpty) {
        await db.execute(query);
      }
    }

    await db.insert("categories", budget.Category(amount: 0, name: "fnb").toMap());
    await db.insert("categories", budget.Category(amount: 0, name: "household").toMap());
    await db.insert("categories", budget.Category(amount: 0, name: "shopping").toMap());
  }

  Future<String> _loadSQL() async {
    return await rootBundle.loadString('assets/schema.sql');
  }

  Future<void> close() async {
    if (_database != null) {
      await _database?.close();
    }
  }
}
