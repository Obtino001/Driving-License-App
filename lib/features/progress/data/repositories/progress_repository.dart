library;

import 'package:flutter/material.dart';
import '../models/achievement.dart';
import '../models/category_stats.dart';
import '../models/user_stats.dart';

import 'package:sqflite/sqflite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/data/local_database.dart';
import '../../../../core/services/preferences_service.dart';
import '../../../../core/providers/state_selection_provider.dart';

final progressRepositoryProvider = Provider<ProgressRepository>((ref) {
  final prefs = ref.watch(preferencesServiceProvider);
  final stateId = ref.watch(activeStateIdProvider);
  return SqlProgressRepository(LocalDatabase.instance, prefs, stateId);
});

abstract class ProgressRepository {
  Future<UserStats> getUserStats();
  Future<List<CategoryStats>> getCategoryStats();
  Future<List<Achievement>> getAchievements();
  Future<void> saveTestResult(int totalQuestions, int correctAnswers, int timeUsedSeconds, bool isPassed);
}

class SqlProgressRepository implements ProgressRepository {
  SqlProgressRepository(this._localDb, this._prefs, this._stateId);
  
  final LocalDatabase _localDb;
  final PreferencesService _prefs;
  final String _stateId;
  
  Future<Database> get _db => _localDb.database;

  @override
  Future<UserStats> getUserStats() async {
    final db = await _db;
    
    // Calculate total questions answered and overall accuracy for the specific state
    final progressRes = await db.rawQuery('''
      SELECT 
        COUNT(up.id) as total_qs,
        SUM(up.is_correct) as correct_qs
      FROM user_progress up
      JOIN questions q ON up.question_id = q.id
      WHERE q.state_id = ?
    ''', [_stateId]);

    int totalQs = (progressRes.first['total_qs'] as int?) ?? 0;
    int correctQs = (progressRes.first['correct_qs'] as int?) ?? 0;
    double accuracy = totalQs > 0 ? correctQs / totalQs : 0.0;
    
    // Mock Test stats
    final testRes = await db.rawQuery('''
      SELECT 
        COUNT(*) as total_tests,
        AVG(CAST(correct_answers AS REAL) / total_questions) as avg_score
      FROM test_history
      WHERE state_id = ?
    ''', [_stateId]);
    
    int totalTests = (testRes.first['total_tests'] as int?) ?? 0;
    double avgScore = (testRes.first['avg_score'] as double?) ?? 0.0;
    
    // In a real app, streaks and XP would be calculated chronologically or 
    // stored in a dedicated `user_stats` table that gets updated on events.
    // For this implementation, we simulate XP based on correct answers and tests.
    int xp = (correctQs * 10) + (totalTests * 100);
    int level = (xp / 1000).floor() + 1;

    return UserStats(
      xp: xp,
      level: level,
      currentStreak: _prefs.currentStreak,
      bestStreak: _prefs.bestStreak,
      totalQuestionsAnswered: totalQs,
      overallAccuracy: accuracy,
      mockTestsCompleted: totalTests,
      mockTestAverageScore: avgScore,
      dailyGoalQuestions: _prefs.dailyGoal,
      dailyQuestionsAnswered: _prefs.dailyQuestionsAnswered,
    );
  }

  @override
  Future<List<CategoryStats>> getCategoryStats() async {
    final db = await _db;
    
    final results = await db.rawQuery('''
      SELECT 
        c.name as category_name,
        COUNT(up.id) as total_answered,
        SUM(up.is_correct) as correct_answered
      FROM categories c
      JOIN questions q ON c.id = q.category_id
      LEFT JOIN user_progress up ON q.id = up.question_id
      WHERE q.state_id = ?
      GROUP BY c.id
      HAVING COUNT(up.id) > 0
    ''', [_stateId]);
    
    return results.map((row) {
      return CategoryStats(
        categoryName: row['category_name'] as String,
        questionsAnswered: (row['total_answered'] as int?) ?? 0,
        correctAnswers: (row['correct_answered'] as int?) ?? 0,
      );
    }).toList();
  }

  @override
  Future<List<Achievement>> getAchievements() async {
    // Achievements logic can be state-independent or dependent.
    // For now we'll just return the simulated data as before.
    return [
      const Achievement(id: '1', title: 'First Steps', description: 'Complete 10 questions', isUnlocked: true, iconData: Icons.directions_walk),
      const Achievement(id: '2', title: 'On a Roll', description: 'Achieve a 7-day streak', isUnlocked: false, iconData: Icons.local_fire_department),
      const Achievement(id: '3', title: 'Perfect Test', description: 'Score 100% on a Mock Test', isUnlocked: false, iconData: Icons.star),
      const Achievement(id: '4', title: 'Sign Master', description: 'Master all Road Signs', isUnlocked: false, iconData: Icons.traffic),
    ];
  }

  @override
  Future<void> saveTestResult(int totalQuestions, int correctAnswers, int timeUsedSeconds, bool isPassed) async {
    final db = await _db;
    
    await db.insert('test_history', {
      'total_questions': totalQuestions,
      'correct_answers': correctAnswers,
      'time_used_seconds': timeUsedSeconds,
      'is_passed': isPassed ? 1 : 0,
      'completed_at': DateTime.now().millisecondsSinceEpoch,
      'state_id': _stateId,
    });
  }
}
