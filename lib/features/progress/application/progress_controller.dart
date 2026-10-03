import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_provider.dart';

final progressProvider = FutureProvider<ProgressState>((ref) async {
  final repo = ref.watch(databaseRepositoryProvider);

  final todayQuestions = await repo.getTodayQuestionCount();
  final mistakeCount = await repo.getMistakeBankCount();

  // The actual categories from our content pipeline
  final topics = [
    'Road Rules',
    'Traffic Signs',
    'Right of Way',
    'Speed & Distance',
    'Intersections',
    'Lane Control',
    'Parking',
    'Sharing the Road',
    'Safe Driving',
    'Emergencies',
  ];

  final categoryStats = <String, Map<String, int>>{};
  final categoryAccuracy = <String, double>{};
  var totalCompleted = 0;
  var totalQuestions = 0;

  for (final t in topics) {
    final prog = await repo.getCategoryProgress(t);
    categoryStats[t] = prog;
    totalCompleted += prog['completed'] ?? 0;
    totalQuestions += prog['total'] ?? 0;

    final acc = await repo.getCategoryAccuracy(t);
    if (acc != null) {
      categoryAccuracy[t] = acc;
    }
  }

  String? strongestTopic;
  String? weakestTopic;

  if (categoryAccuracy.isNotEmpty) {
    var maxAcc = -1.0;
    var minAcc = 2.0;

    for (final e in categoryAccuracy.entries) {
      // Only consider topics with some decent volume? We'll just use the raw for now.
      if (e.value > maxAcc) {
        maxAcc = e.value;
        strongestTopic = e.key;
      }
      if (e.value < minAcc) {
        minAcc = e.value;
        weakestTopic = e.key;
      }
    }
    // If they are the same (e.g. only 1 topic practiced), clear weakest
    if (strongestTopic == weakestTopic) {
      weakestTopic = null;
    }
  }

  final mockExamsCount = await repo.getMockExamsCount();
  final latestMockScore = await repo.getLatestMockScore();
  final bestMockScore = await repo.getBestMockScore();

  final readiness = totalQuestions == 0
      ? 0
      : ((totalCompleted / totalQuestions) * 100).round();

  return ProgressState(
    readiness: readiness,
    topicsExplored: topics
        .where((t) => (categoryStats[t]?['completed'] ?? 0) > 0)
        .length,
    totalTopics: topics.length,
    todayQuestions: todayQuestions,
    mistakeCount: mistakeCount,
    categoryStats: categoryStats,
    categoryAccuracy: categoryAccuracy,
    mockExamsCount: mockExamsCount,
    latestMockScore: latestMockScore,
    bestMockScore: bestMockScore,
    strongestTopic: strongestTopic,
    weakestTopic: weakestTopic,
  );
});

class ProgressState {
  final int readiness;
  final int topicsExplored;
  final int totalTopics;
  final int todayQuestions;
  final int mistakeCount;
  final Map<String, Map<String, int>> categoryStats;
  final Map<String, double> categoryAccuracy;
  final int mockExamsCount;
  final int? latestMockScore;
  final int? bestMockScore;
  final String? strongestTopic;
  final String? weakestTopic;

  ProgressState({
    required this.readiness,
    required this.topicsExplored,
    required this.totalTopics,
    required this.todayQuestions,
    required this.mistakeCount,
    required this.categoryStats,
    required this.categoryAccuracy,
    required this.mockExamsCount,
    this.latestMockScore,
    this.bestMockScore,
    this.strongestTopic,
    this.weakestTopic,
  });
}
