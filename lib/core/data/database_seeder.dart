library;

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:sqflite/sqflite.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';
import 'local_database.dart';

/// Seeds the local database with initial content (questions, road signs)
/// on the very first launch.
class DatabaseSeeder {
  static const String _seededKey = 'db_seeded_v2';

  static Future<void> seedIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    final isSeeded = prefs.getBool(_seededKey) ?? false;

    if (isSeeded) return;

    final db = await LocalDatabase.instance.database;
    final basePath = AppConfig.dataAssetPath;

    // Load JSON data
    final questionsJsonStr = await rootBundle.loadString('$basePath/questions.json');
    final roadSignsJsonStr = await rootBundle.loadString('$basePath/road_signs.json');

    final List<dynamic> questionsData = jsonDecode(questionsJsonStr);
    final List<dynamic> roadSignsData = jsonDecode(roadSignsJsonStr);

    await db.transaction((txn) async {
      // 1. Seed Categories (Extract from questions data)
      final Set<String> categories = questionsData.map((q) => q['category'] as String).toSet();
      for (final cat in categories) {
        await txn.insert(
          'categories',
          {'id': cat.toLowerCase().replaceAll(' ', '_'), 'name': cat},
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
      }

      // 2. Seed Questions
      for (final q in questionsData) {
        await txn.insert(
          'questions',
          {
            'id': q['id'],
            'category_id': (q['category'] as String).toLowerCase().replaceAll(' ', '_'),
            'text': q['text'],
            'options_json': jsonEncode(q['options']),
            'correct_index': q['correctIndex'],
            'explanation': q['explanation'],
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      // 3. Seed Road Signs
      for (final sign in roadSignsData) {
        await txn.insert(
          'road_signs',
          {
            'id': sign['id'],
            'name': sign['name'],
            'category': sign['category'],
            'meaning': sign['meaning'],
            'action_required': sign['actionRequired'],
            'example_situation': sign['exampleSituation'],
            'icon_data_code': sign['iconDataCode'],
            'color_hex': sign['colorHex'],
            'shape_index': sign['shapeIndex'],
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });

    await prefs.setBool(_seededKey, true);
  }
}
