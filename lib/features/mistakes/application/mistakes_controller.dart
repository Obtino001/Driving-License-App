import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/database/database_repository.dart';

class MistakesState {
  final List<Question> mistakes;
  final bool isLoading;

  MistakesState({
    this.mistakes = const [],
    this.isLoading = false,
  });
}

class MistakesController extends AsyncNotifier<MistakesState> {
  late final DatabaseRepository _repository;

  @override
  Future<MistakesState> build() async {
    _repository = ref.watch(databaseRepositoryProvider);
    return _fetchData();
  }

  Future<MistakesState> _fetchData() async {
    final mistakes = await _repository.getMistakeBank();
    return MistakesState(mistakes: mistakes);
  }

  Future<void> loadMistakes() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchData());
  }
}

final mistakesProvider = AsyncNotifierProvider<MistakesController, MistakesState>(() {
  return MistakesController();
});
