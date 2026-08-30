library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/achievement.dart';
import '../data/models/category_stats.dart';
import '../data/models/user_stats.dart';
import '../data/repositories/progress_repository.dart';
/// Combined state for the progress dashboard.
class ProgressState {
  const ProgressState({
    required this.userStats,
    required this.categoryStats,
    required this.achievements,
  });

  final UserStats userStats;
  final List<CategoryStats> categoryStats;
  final List<Achievement> achievements;

  /// Returns categories sorted by accuracy (lowest first) to identify weaknesses.
  List<CategoryStats> get weakCategories {
    final sorted = List<CategoryStats>.from(categoryStats)
      ..sort((a, b) => a.accuracy.compareTo(b.accuracy));
    return sorted;
  }

  /// Returns the single weakest category (or null if no data).
  CategoryStats? get weakestCategory {
    final weak = weakCategories;
    if (weak.isNotEmpty) return weak.first;
    return null;
  }
}

/// Fetches and holds all progress data for the UI.
final progressProvider = FutureProvider.autoDispose<ProgressState>((ref) async {
  final repo = ref.watch(progressRepositoryProvider);
  
  final userStats = await repo.getUserStats();
  final categoryStats = await repo.getCategoryStats();
  final achievements = await repo.getAchievements();

  return ProgressState(
    userStats: userStats,
    categoryStats: categoryStats,
    achievements: achievements,
  );
});
