library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/question.dart';
import '../data/repositories/question_repository.dart';

class MistakesState {
  MistakesState({
    required this.questions,
    required this.stats,
  });

  final List<Question> questions;
  final Map<String, int> stats;

  int get totalMistakes => stats['total_mistakes'] ?? 0;
  int get learningCount => stats['learning'] ?? 0;
  int get improvingCount => stats['improving'] ?? 0;
  int get masteredCount => stats['mastered'] ?? 0;
}

final mistakesProvider = FutureProvider.autoDispose<MistakesState>((ref) async {
  final repo = ref.watch(sqlQuestionRepositoryProvider);
  
  final questions = await repo.getMistakeQuestions();
  final stats = await repo.getMistakeStats();

  return MistakesState(
    questions: questions,
    stats: stats,
  );
});
