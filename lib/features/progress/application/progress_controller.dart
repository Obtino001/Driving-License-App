import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/database_provider.dart';

final progressProvider = FutureProvider<ProgressState>((ref) async {
  final repo = ref.watch(databaseRepositoryProvider);
  
  final todayQuestions = await repo.getTodayQuestionCount();
  final mistakeCount = await repo.getMistakeBankCount();

  // Hardcode topics for now, ideally fetch dynamically
  final topics = ['Signs', 'Rules', 'Safety', 'Fines'];
  final categoryStats = <String, Map<String, int>>{};
  var totalCompleted = 0;
  var totalQuestions = 0;

  for (final t in topics) {
    final prog = await repo.getCategoryProgress(t);
    categoryStats[t] = prog;
    totalCompleted += prog['completed'] ?? 0;
    totalQuestions += prog['total'] ?? 0;

    final acc = await repo.getCategoryAccuracy(t);
    if (acc != null) {
      // this is a rough approximation since we don't have exact sum in getCategoryAccuracy
      // but we can adjust it if needed.
    }
  }

  final readiness = totalQuestions == 0 ? 0 : ((totalCompleted / totalQuestions) * 100).round();
  
  return ProgressState(
    readiness: readiness,
    topicsExplored: topics.where((t) => (categoryStats[t]?['completed'] ?? 0) > 0).length,
    totalTopics: topics.length,
    todayQuestions: todayQuestions,
    mistakeCount: mistakeCount,
    categoryStats: categoryStats,
  );
});

class ProgressState {
  final int readiness;
  final int topicsExplored;
  final int totalTopics;
  final int todayQuestions;
  final int mistakeCount;
  final Map<String, Map<String, int>> categoryStats;

  ProgressState({
    required this.readiness,
    required this.topicsExplored,
    required this.totalTopics,
    required this.todayQuestions,
    required this.mistakeCount,
    required this.categoryStats,
  });
}
