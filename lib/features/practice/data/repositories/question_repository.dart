library;

import 'package:sqflite/sqflite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/data/local_database.dart';
import '../../../../core/utils/mastery_calculator.dart';
import '../../../../core/utils/streak_calculator.dart';
import '../../../../core/services/preferences_service.dart';
import '../../../../core/providers/state_selection_provider.dart';
import '../models/question.dart';

final sqlQuestionRepositoryProvider = Provider<SqlQuestionRepository>((ref) {
  final prefs = ref.watch(preferencesServiceProvider);
  final stateId = ref.watch(activeStateIdProvider);
  return SqlQuestionRepository(LocalDatabase.instance, prefs, stateId);
});

class SqlQuestionRepository {
  SqlQuestionRepository(this._localDb, this._prefs, this._stateId);

  final LocalDatabase _localDb;
  final PreferencesService _prefs;
  final String _stateId;

  Future<Database> get _db => _localDb.database;

  /// Fetches questions for a specific category.
  Future<List<Question>> getQuestionsByCategory(String categoryName) async {
    final db = await _db;
    
    // Join with categories to filter by name
    final results = await db.rawQuery('''
      SELECT q.*, c.name as category_name
      FROM questions q
      JOIN categories c ON q.category_id = c.id
      WHERE c.name = ? AND q.state_id = ?
    ''', [categoryName, _stateId]);

    return results.map((row) => Question.fromMap(row, row['category_name'] as String)).toList();
  }

  /// Fetches N random questions for a mock test.
  Future<List<Question>> getRandomQuestions(int count) async {
    final db = await _db;
    
    final results = await db.rawQuery('''
      SELECT q.*, c.name as category_name
      FROM questions q
      JOIN categories c ON q.category_id = c.id
      WHERE q.state_id = ?
      ORDER BY RANDOM()
      LIMIT ?
    ''', [_stateId, count]);

    return results.map((row) => Question.fromMap(row, row['category_name'] as String)).toList();
  }

  /// Records a user's answer to a question for progress tracking and updates mastery.
  Future<void> saveQuestionResult(String questionId, bool isCorrect) async {
    final db = await _db;
    await db.transaction((txn) async {
      final now = DateTime.now().millisecondsSinceEpoch;
      
      // 1. Log the attempt
      await txn.insert('user_progress', {
        'question_id': questionId,
        'is_correct': isCorrect ? 1 : 0,
        'answered_at': now,
      });

      // 2. Update mastery level
      final masteryRows = await txn.query('question_mastery', where: 'question_id = ?', whereArgs: [questionId]);
      int consecutive = 0;
      int level = 0; // 0=New, 1=Learning, 2=Improving, 3=Mastered

      if (masteryRows.isNotEmpty) {
        consecutive = masteryRows.first['consecutive_correct'] as int;
      }

      final newMastery = MasteryCalculator.calculateNewMastery(isCorrect, consecutive);
      level = newMastery['level']!;
      consecutive = newMastery['consecutive']!;

      await txn.insert('question_mastery', {
        'question_id': questionId,
        'mastery_level': level,
        'consecutive_correct': consecutive,
        'last_answered_at': now,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    });

    // 3. Handle Retention & Streaks (outside transaction as it uses SharedPreferences)
    final nowUtc = DateTime.now().toUtc();
    final today = DateTime(nowUtc.year, nowUtc.month, nowUtc.day);
    
    final lastActiveStr = _prefs.lastActiveDate;
    DateTime? lastActive;
    if (lastActiveStr.isNotEmpty) {
      lastActive = DateTime.tryParse(lastActiveStr);
    }

    final newStreakState = StreakCalculator.calculateNewStreak(
      today: today,
      lastActive: lastActive,
      currentStreak: _prefs.currentStreak,
      bestStreak: _prefs.bestStreak,
      recoveryAvailable: _prefs.streakRecoveryAvailable,
    );

    if (newStreakState['isNewDay'] == true) {
      // First activity of a new day
      await _prefs.setDailyQuestionsAnswered(1);
      await _prefs.setCurrentStreak(newStreakState['newStreak'] as int);
      await _prefs.setBestStreak(newStreakState['bestStreak'] as int);
      await _prefs.setStreakRecoveryAvailable(newStreakState['recoveryAvailable'] as bool);
      await _prefs.setLastActiveDate(today.toIso8601String());
    } else {
      // Same day activity
      await _prefs.setDailyQuestionsAnswered(_prefs.dailyQuestionsAnswered + 1);
    }
  }

  /// Fetches questions that the user has previously answered incorrectly and not yet mastered.
  Future<List<Question>> getMistakeQuestions() async {
    final db = await _db;
    final results = await db.rawQuery('''
      SELECT q.*, c.name as category_name
      FROM questions q
      JOIN categories c ON q.category_id = c.id
      JOIN question_mastery m ON q.id = m.question_id
      WHERE m.mastery_level IN (1, 2) AND q.state_id = ?
      ORDER BY m.mastery_level ASC, m.last_answered_at ASC
    ''', [_stateId]);
    return results.map((row) => Question.fromMap(row, row['category_name'] as String)).toList();
  }

  /// Returns counts for Learning, Improving, and Mastered questions.
  Future<Map<String, int>> getMistakeStats() async {
    final db = await _db;
    final results = await db.rawQuery('''
      SELECT mastery_level, COUNT(*) as count
      FROM question_mastery
      GROUP BY mastery_level
    ''');
    
    int learning = 0;
    int improving = 0;
    int mastered = 0;

    for (final row in results) {
      final level = row['mastery_level'] as int;
      final count = row['count'] as int;
      if (level == 1) learning = count;
      if (level == 2) improving = count;
      if (level == 3) mastered = count;
    }

    return {
      'learning': learning,
      'improving': improving,
      'mastered': mastered,
      'total_mistakes': learning + improving,
    };
  }

  /// Toggles a bookmark for a question.
  Future<void> toggleBookmark(String questionId) async {
    final db = await _db;
    
    final existing = await db.query(
      'bookmarks',
      where: 'question_id = ?',
      whereArgs: [questionId],
    );

    if (existing.isNotEmpty) {
      await db.delete(
        'bookmarks',
        where: 'question_id = ?',
        whereArgs: [questionId],
      );
    } else {
      await db.insert('bookmarks', {
        'question_id': questionId,
        'added_at': DateTime.now().millisecondsSinceEpoch,
      });
    }
  }

}
