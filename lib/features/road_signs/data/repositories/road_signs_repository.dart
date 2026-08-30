library;

import 'package:sqflite/sqflite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../../../../core/data/local_database.dart';
import '../models/road_sign.dart';

final sqlRoadSignsRepositoryProvider = Provider<SqlRoadSignsRepository>((ref) {
  return SqlRoadSignsRepository(LocalDatabase.instance);
});

class SqlRoadSignsRepository {
  SqlRoadSignsRepository(this._localDb);

  final LocalDatabase _localDb;

  Future<Database> get _db => _localDb.database;

  /// Fetches all road signs from the database.
  Future<List<RoadSign>> getAllSigns() async {
    final db = await _db;
    final results = await db.query('road_signs');
    return results.map(_mapRowToSign).toList();
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

  RoadSign _mapRowToSign(Map<String, dynamic> row) {
    return RoadSign(
      id: row['id'] as String,
      name: row['name'] as String,
      category: row['category'] as String,
      meaning: row['meaning'] as String,
      actionRequired: row['action_required'] as String,
      exampleSituation: row['example_situation'] as String,
      // ignore: non_const_argument_for_const_parameter
      iconData: IconData(row['icon_data_code'] as int, fontFamily: 'MaterialIcons'),
      color: Color(row['color_hex'] as int),
      shape: RoadSignShape.values[row['shape_index'] as int],
    );
  }
}
