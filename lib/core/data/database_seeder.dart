library;

import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/practice/data/mock_questions.dart';
import '../../features/road_signs/data/mock_road_signs.dart';
import 'local_database.dart';

/// Seeds the local database with initial content (questions, road signs)
/// on the very first launch.
class DatabaseSeeder {
  static const String _seededKey = 'db_seeded_v1';

  static Future<void> seedIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    final isSeeded = prefs.getBool(_seededKey) ?? false;

    if (isSeeded) return;

    final db = await LocalDatabase.instance.database;

    await db.transaction((txn) async {
      // 1. Seed Categories (Extract from mock questions)
      final categories = mockQuestions.map((q) => q.category).toSet();
      for (final cat in categories) {
        await txn.insert(
          'categories',
          {'id': cat.toLowerCase().replaceAll(' ', '_'), 'name': cat},
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
      }

      // 2. Seed Questions
      for (final q in mockQuestions) {
        await txn.insert(
          'questions',
          {
            'id': q.id,
            'category_id': q.category.toLowerCase().replaceAll(' ', '_'),
            'text': q.text,
            'options_json': jsonEncode(q.options),
            'correct_index': q.correctIndex,
            'explanation': q.explanation,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      // 3. Seed Road Signs
      for (final sign in mockRoadSigns) {
        await txn.insert(
          'road_signs',
          {
            'id': sign.id,
            'name': sign.name,
            'category': sign.category,
            'meaning': sign.meaning,
            'action_required': sign.actionRequired,
            'example_situation': sign.exampleSituation,
            'icon_data_code': sign.iconData.codePoint,
            'color_hex': sign.color.toARGB32(),
            'shape_index': sign.shape.index,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });

    await prefs.setBool(_seededKey, true);
  }
}
