import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:driving_license_app/features/practice/data/models/question.dart';
import 'package:driving_license_app/core/data/local_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productionSeederProvider = Provider<ProductionSeeder>((ref) {
  final db = ref.watch(localDatabaseProvider);
  return ProductionSeeder(db);
});

class ProductionSeeder {
  final LocalDatabase _localDatabase;

  ProductionSeeder(this._localDatabase);

  /// Safely imports VERIFIED questions from a JSON asset into the SQLite database.
  /// Preserves user progress by using INSERT IGNORE + UPDATE strategy instead of REPLACE.
  Future<int> importVerifiedQuestions(String assetPath) async {
    int importedCount = 0;
    try {
      final String jsonString = await rootBundle.loadString(assetPath);
      final List<dynamic> jsonList = jsonDecode(jsonString);
      
      final db = await _localDatabase.database;

      await db.transaction((txn) async {
        for (var json in jsonList) {
          final q = Question.fromJson(json as Map<String, dynamic>);
          
          // Only import explicitly VERIFIED questions
          if (q.verificationStatus != 'VERIFIED') {
            continue;
          }

          final questionMap = q.toMap();

          // Try inserting. If the ID exists, it will ignore.
          int result = await txn.insert(
            'questions',
            questionMap,
            conflictAlgorithm: ConflictAlgorithm.ignore,
          );

          // If the question already existed, the insert returned 0.
          // We must update the record to reflect any content changes,
          // but safely, so we don't destroy foreign keys mapping to this ID.
          if (result == 0) {
            await txn.update(
              'questions',
              questionMap,
              where: 'id = ?',
              whereArgs: [q.id],
            );
          }
          
          importedCount++;
        }
      });
      
    } catch (e) {
      // ignore: avoid_print
      print('ProductionSeeder Error: $e');
    }
    
    return importedCount;
  }
}
