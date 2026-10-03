import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_provider.dart';
import '../../../core/database/database_repository.dart';

class HomeState {
  final int readiness; // Question coverage, 0-100.
  final int streak;
  final int mistakesCount;
  final int dailyGoalProgress;
  final int exploredTopics;
  final int totalTopics;
  final String currentTopic;
  final double currentTopicProgress;
  final String nextTopic;
  final int? latestMockScore;

  HomeState({
    this.readiness = 0,
    this.streak = 0,
    this.mistakesCount = 0,
    this.dailyGoalProgress = 0,
    this.exploredTopics = 0,
    this.totalTopics = 0,
    this.currentTopic = 'Road Rules',
    this.currentTopicProgress = 0,
    this.nextTopic = 'Road Rules',
    this.latestMockScore,
  });
}

class HomeController extends AsyncNotifier<HomeState> {
  late final DatabaseRepository _repository;

  @override
  Future<HomeState> build() async {
    _repository = ref.watch(databaseRepositoryProvider);
    return _fetchData();
  }

  Future<HomeState> _fetchData() async {
    final mistakesCount = await _repository.getMistakeBankCount();
    const categories = [
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
    final progress = await Future.wait(
      categories.map(_repository.getCategoryProgress),
    );
    var total = 0;
    var completed = 0;
    var explored = 0;
    for (final item in progress) {
      final count = item['completed'] ?? 0;
      completed += count;
      total += item['total'] ?? 0;
      if (count > 0) explored++;
    }
    final currentIndex = progress.indexWhere(
      (item) =>
          (item['completed'] ?? 0) > 0 &&
          (item['completed'] ?? 0) < (item['total'] ?? 0),
    );
    final nextIndex = progress.indexWhere(
      (item) =>
          (item['completed'] ?? 0) < (item['total'] ?? 0) &&
          (item['total'] ?? 0) > 0,
    );
    final activeIndex = currentIndex >= 0
        ? currentIndex
        : (nextIndex >= 0 ? nextIndex : 0);
    final recommendationIndex = nextIndex >= 0 ? nextIndex : activeIndex;
    final active = progress[activeIndex];
    final activeTotal = active['total'] ?? 0;
    final today = await _repository.getTodayQuestionCount();
    final latestMockScore = await _repository.getLatestMockScore();

    return HomeState(
      readiness: total == 0
          ? 0
          : ((completed / total) * 100).round().clamp(0, 100),
      streak: 0, // No daily history is stored yet; avoid showing a fabricated streak.
      mistakesCount: mistakesCount,
      dailyGoalProgress: today.clamp(0, 10),
      exploredTopics: explored,
      totalTopics: categories.length,
      currentTopic: categories[activeIndex],
      currentTopicProgress: activeTotal == 0
          ? 0
          : (active['completed'] ?? 0) / activeTotal,
      nextTopic: categories[recommendationIndex],
      latestMockScore: latestMockScore,
    );
  }

  Future<void> loadHomeData() async {
    state = await AsyncValue.guard(() => _fetchData());
  }
}

final homeProvider = AsyncNotifierProvider<HomeController, HomeState>(() {
  return HomeController();
});
