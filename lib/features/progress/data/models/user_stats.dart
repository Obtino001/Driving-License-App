library;

import 'package:flutter/foundation.dart';

@immutable
class UserStats {
  const UserStats({
    required this.xp,
    required this.level,
    required this.currentStreak,
    required this.bestStreak,
    required this.totalQuestionsAnswered,
    required this.overallAccuracy,
    required this.mockTestsCompleted,
    required this.mockTestAverageScore,
    required this.dailyGoalQuestions,
    required this.dailyQuestionsAnswered,
  });

  final int xp;
  final int level;
  final int currentStreak;
  final int bestStreak;
  final int totalQuestionsAnswered;
  final double overallAccuracy; // 0.0 to 1.0
  final int mockTestsCompleted;
  final double mockTestAverageScore; // 0.0 to 1.0
  
  // Daily goals
  final int dailyGoalQuestions;
  final int dailyQuestionsAnswered;

  /// Returns progress towards the next level (0.0 to 1.0)
  /// Simplified calculation for mock data: next level is (level * 1000) XP.
  double get levelProgress {
    final currentLevelBaseXp = (level - 1) * 1000;
    final xpInCurrentLevel = xp - currentLevelBaseXp;
    return (xpInCurrentLevel / 1000).clamp(0.0, 1.0);
  }

  /// Returns progress towards daily goal
  double get dailyGoalProgress => 
      (dailyQuestionsAnswered / dailyGoalQuestions).clamp(0.0, 1.0);
}
