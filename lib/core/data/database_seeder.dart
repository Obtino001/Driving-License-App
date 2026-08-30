library;

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:sqflite/sqflite.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/region_state.dart';
import 'local_database.dart';

/// Seeds the local database with initial content (questions, road signs)
/// on the very first launch.
class DatabaseSeeder {
  static const String _seededKey = 'db_seeded_v3'; // Bumped for v3 migration

  static Future<void> seedIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    final isSeeded = prefs.getBool(_seededKey) ?? false;

    if (isSeeded) return;

    final db = await LocalDatabase.instance.database;

    // Load states.json
    final statesJsonStr = await rootBundle.loadString('assets/data/us/states.json');
    final List<dynamic> statesData = jsonDecode(statesJsonStr);

    // For now, load us_generic questions and road signs. In the future, this would iterate through states.
    final questionsJsonStr = await rootBundle.loadString('assets/data/us_generic/questions.json');
    final roadSignsJsonStr = await rootBundle.loadString('assets/data/us_generic/road_signs.json');

    final List<dynamic> questionsData = jsonDecode(questionsJsonStr);
    final List<dynamic> roadSignsData = jsonDecode(roadSignsJsonStr);

    await db.transaction((txn) async {
      // 1. Seed States
      for (final stateMap in statesData) {
        final state = RegionState.fromJson(stateMap as Map<String, dynamic>);
        await txn.insert(
          'states',
          state.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      // 2. Seed Categories (Extract from questions data)
      final Set<String> categories = questionsData.map((q) => q['category'] as String).toSet();
      for (final cat in categories) {
        await txn.insert(
          'categories',
          {'id': cat.toLowerCase().replaceAll(' ', '_'), 'name': cat},
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
      }

      // 3. Seed Questions (mapping to us_generic for now)
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
            'state_id': 'us_generic',
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      // 4. Seed Road Signs (mapping to us_generic for now)
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
            'state_id': 'us_generic',
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });

    await prefs.setBool(_seededKey, true);
  }
}
