import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_provider.dart';
import '../../../core/database/database_repository.dart';

class LearnModule {
  final String title;
  final String category;
  final int totalQuestions;
  final int completedQuestions;
  final double? accuracy;

  LearnModule({
    required this.title,
    required this.category,
    required this.totalQuestions,
    required this.completedQuestions,
    this.accuracy,
  });

  double get progress =>
      totalQuestions == 0 ? 0 : completedQuestions / totalQuestions;
  bool get isCompleted =>
      totalQuestions > 0 && completedQuestions == totalQuestions;
  bool get isLocked => false; // As requested, don't lock aggressively
}

class LearnState {
  final List<LearnModule> modules;
  final bool isLoading;

  LearnState({this.modules = const [], this.isLoading = false});
}

class LearnController extends AsyncNotifier<LearnState> {
  late final DatabaseRepository _repository;

  @override
  Future<LearnState> build() async {
    _repository = ref.watch(databaseRepositoryProvider);
    return _fetchData();
  }

  Future<LearnState> _fetchData() async {
    final categories = [
      "Road Rules",
      "Traffic Signs",
      "Right of Way",
      "Speed & Distance",
      "Intersections",
      "Lane Control",
      "Parking",
      "Sharing the Road",
      "Safe Driving",
      "Emergencies",
    ];

    List<LearnModule> modules = [];
    for (var cat in categories) {
      final progress = await _repository.getCategoryProgress(cat);
      modules.add(
        LearnModule(
          title: cat,
          category: cat,
          totalQuestions: progress['total'] ?? 0,
          completedQuestions: progress['completed'] ?? 0,
          accuracy: await _repository.getCategoryAccuracy(cat),
        ),
      );
    }

    return LearnState(modules: modules);
  }

  Future<void> loadModules() async {
    state = await AsyncValue.guard(() => _fetchData());
  }
}

final learnProvider = AsyncNotifierProvider<LearnController, LearnState>(() {
  return LearnController();
});
