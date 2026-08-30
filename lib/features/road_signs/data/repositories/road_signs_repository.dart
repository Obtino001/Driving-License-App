library;

import 'package:sqflite/sqflite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/data/local_database.dart';
import '../../../../core/providers/state_selection_provider.dart';
import '../models/road_sign.dart';

final sqlRoadSignsRepositoryProvider = Provider<SqlRoadSignsRepository>((ref) {
  final stateId = ref.watch(activeStateIdProvider);
  return SqlRoadSignsRepository(LocalDatabase.instance, stateId);
});

class SqlRoadSignsRepository {
  SqlRoadSignsRepository(this._localDb, this._stateId);

  final LocalDatabase _localDb;
  final String _stateId;

  Future<Database> get _db => _localDb.database;

  /// Fetches all road signs from the database for the active state.
  Future<List<RoadSign>> getAllSigns() async {
    final db = await _db;
    final results = await db.query(
      'road_signs',
      where: 'state_id = ?',
      whereArgs: [_stateId],
    );
    return results.map((row) => RoadSign.fromMap(row)).toList();
  }

  /// Fetches all favorite sign IDs.
  Future<Set<String>> getFavoriteSignIds() async {
    final db = await _db;
    final results = await db.query('favorite_signs');
    return results.map((row) => row['sign_id'] as String).toSet();
  }

  /// Toggles a favorite status for a sign.
  Future<void> toggleFavorite(String signId) async {
    final db = await _db;
    
    final existing = await db.query(
      'favorite_signs',
      where: 'sign_id = ?',
      whereArgs: [signId],
    );

    if (existing.isNotEmpty) {
      await db.delete(
        'favorite_signs',
        where: 'sign_id = ?',
        whereArgs: [signId],
      );
    } else {
      await db.insert('favorite_signs', {
        'sign_id': signId,
        'added_at': DateTime.now().millisecondsSinceEpoch,
      });
    }
  }
}
