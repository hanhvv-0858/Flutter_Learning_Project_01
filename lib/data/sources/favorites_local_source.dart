import 'package:sqflite/sqflite.dart';

import '../../models/favorite.dart';
import '../database/database_helper.dart';

/// CRUD operations for the favorites table using Sqflite.
class FavoritesLocalSource {
  final DatabaseHelper _dbHelper;

  FavoritesLocalSource(this._dbHelper);

  Future<List<Favorite>> getAll() async {
    final db = await _dbHelper.database;
    final rows = await db.query('favorites', orderBy: 'saved_at DESC');
    return rows.map(Favorite.fromMap).toList();
  }

  Future<Favorite?> getById(String id) async {
    final db = await _dbHelper.database;
    final rows = await db.query(
      'favorites',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return Favorite.fromMap(rows.first);
  }

  Future<void> insert(Favorite favorite) async {
    final db = await _dbHelper.database;
    await db.insert(
      'favorites',
      favorite.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> delete(String id) async {
    final db = await _dbHelper.database;
    await db.delete('favorites', where: 'id = ?', whereArgs: [id]);
  }
}
