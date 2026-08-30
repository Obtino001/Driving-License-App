library;

import 'package:flutter/material.dart';
import '../models/achievement.dart';
import '../models/category_stats.dart';
import '../models/user_stats.dart';

abstract class ProgressRepository {
  Future<UserStats> getUserStats();
  Future<List<CategoryStats>> getCategoryStats();
  Future<List<Achievement>> getAchievements();
}

class MockProgressRepository implements ProgressRepository {
  @override
  Future<UserStats> getUserStats() async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network/DB latency
    return const UserStats(
      xp: 3450,
      level: 4,
      currentStreak: 5,
      bestStreak: 12,
      totalQuestionsAnswered: 450,
      overallAccuracy: 0.76,
      mockTestsCompleted: 3,
      mockTestAverageScore: 0.82,
      dailyGoalQuestions: 50,
      dailyQuestionsAnswered: 35,
    );
  }

  @override
  Future<List<CategoryStats>> getCategoryStats() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const [
      CategoryStats(categoryName: 'Road Signs & Signals', questionsAnswered: 120, correctAnswers: 110),
      CategoryStats(categoryName: 'Right of Way', questionsAnswered: 85, correctAnswers: 60), // Weak
      CategoryStats(categoryName: 'Traffic Rules', questionsAnswered: 90, correctAnswers: 70),
      CategoryStats(categoryName: 'Safety & Emergencies', questionsAnswered: 40, correctAnswers: 20), // Weakest
      CategoryStats(categoryName: 'Parking', questionsAnswered: 50, correctAnswers: 45), // Strong
      CategoryStats(categoryName: 'Highway Driving', questionsAnswered: 35, correctAnswers: 25),
      CategoryStats(categoryName: 'Vehicle Control', questionsAnswered: 30, correctAnswers: 12), // Very Weak
    ];
  }

  @override
  Future<List<Achievement>> getAchievements() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      Achievement(
        id: 'ach_1',
        title: 'First Steps',
        description: 'Complete your first practice session.',
        iconData: Icons.directions_walk_rounded,
        isUnlocked: true,
        unlockedDate: DateTime.now().subtract(const Duration(days: 10)),
      ),
      Achievement(
        id: 'ach_2',
        title: 'Sign Master',
        description: 'Achieve 90% accuracy in Road Signs.',
        iconData: Icons.traffic_rounded,
        isUnlocked: true,
        unlockedDate: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Achievement(
        id: 'ach_3',
        title: 'Mock Star',
        description: 'Pass a mock test on your first try.',
        iconData: Icons.star_rounded,
        isUnlocked: true,
        unlockedDate: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Achievement(
        id: 'ach_4',
        title: 'Perfect Week',
        description: 'Maintain a 7-day learning streak.',
        iconData: Icons.local_fire_department_rounded,
        isUnlocked: false,
      ),
      Achievement(
        id: 'ach_5',
        title: 'Century Club',
        description: 'Answer 100 questions correctly in a single day.',
        iconData: Icons.workspace_premium_rounded,
        isUnlocked: false,
      ),
    ];
  }
}
