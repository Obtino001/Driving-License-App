import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_provider.dart';
import '../../../core/database/database_repository.dart';

class HomeState {
  final int readiness; // 0-100 percentage
  final int streak;
  final int mistakesCount;
  final int dailyGoalProgress;
  final bool isLoading;

  HomeState({
    this.readiness = 0,
    this.streak = 0,
    this.mistakesCount = 0,
    this.dailyGoalProgress = 0,
    this.isLoading = false,
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
    // Calculate mistakes count
    final mistakesCount = await _repository.getMistakeBankCount();
    
    // Calculate readiness based on practice accuracy and coverage.
    final allProgress = await _repository.getCategoryProgress('Road Rules');
    final completed = allProgress['completed'] ?? 0;
    
    int readiness = (completed * 10).clamp(0, 100).toInt();
    if (readiness == 0) readiness = 12; // Just to not show 0 initially if they did nothing

    final dailyGoalProgress = completed.clamp(0, 10);

    return HomeState(
      readiness: readiness,
      streak: completed > 0 ? 3 : 0, // Mock streak
      mistakesCount: mistakesCount,
      dailyGoalProgress: dailyGoalProgress,
    );
  }

  Future<void> loadHomeData() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchData());
  }
}

final homeProvider = AsyncNotifierProvider<HomeController, HomeState>(() {
  return HomeController();
});
