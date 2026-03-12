import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// Manages Sqflite database initialization with versioned migrations.
class DatabaseHelper {
  static const _databaseName = 'example_flutter.db';
  static const _databaseVersion = 1;

  Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);

    return openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE favorites (
        id           TEXT PRIMARY KEY,
        name         TEXT NOT NULL,
        artist_name  TEXT NOT NULL,
        image_url    TEXT NOT NULL,
        release_date TEXT,
        album_type   TEXT NOT NULL,
        saved_at     TEXT NOT NULL
      )
    ''');
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
