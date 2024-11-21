import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'database_service.dart';

class DatabaseServiceImpl extends DatabaseService {
  DatabaseServiceImpl({super.path = 'favorites.db'});

  static const String table = 'favorites';

  late final Future<Database> _db = () async {
    return await openDatabase(join(await getDatabasesPath(), path), version: 1,
        onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE $table (
          id INTEGER PRIMARY KEY,
          adult INTEGER DEFAULT 0,
          original_language STRING NOT NULL,
          original_name STRING NOT NULL,
          overview STRING NOT NULL,
          popularity REAL NOT NULL,
          vote_average REAL NOT NULL,
          poster_path String,
          backdrop_path String,
          year INTEGER DEFAULT 0
        );
      ''');
    });
  }();

  @override
  Future<bool> isSerieFavorite(int serieId) async {
    final db = await _db;
    return _isFavorite(db, serieId);
  }

  @override
  Future<List<Map<String, dynamic>>> loadFavoriteSeries() async {
    final db = await _db;
    final List<Map<String, dynamic>> favoriteMaps = await db.query(table);
    return favoriteMaps;
  }

  @override
  Future<void> toggleFavorite(Map<String, dynamic> serie) async {
    final db = await _db;
    var serieId = serie['id'];
    final isFavorite = await _isFavorite(db, serieId);
    if (isFavorite) {
      await db.delete(table, where: 'id = ?', whereArgs: [serieId]);
    } else {
      await db.insert(
        table,
        serie,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<bool> _isFavorite(Database db, int serieId) async {
    final result = await db.query(table,
        columns: ['id'], where: 'id = ?', whereArgs: [serieId]);
    return result.isNotEmpty;
  }
}
