import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/database/database_repository.dart';

class PracticeQuizState {
  final List<Question> questions;
  final int currentIndex;
  final int? selectedIndex;
  final bool isRevealed;
  final int correctCount;

  PracticeQuizState({
    this.questions = const [],
    this.currentIndex = 0,
    this.selectedIndex,
    this.isRevealed = false,
    this.correctCount = 0,
  });

  PracticeQuizState copyWith({
    List<Question>? questions,
    int? currentIndex,
    int? selectedIndex,
    bool? isRevealed,
    int? correctCount,
  }) {
    return PracticeQuizState(
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      selectedIndex: selectedIndex,
      isRevealed: isRevealed ?? this.isRevealed,
      correctCount: correctCount ?? this.correctCount,
    );
  }

  Question? get currentQuestion =>
      questions.isEmpty || currentIndex >= questions.length
      ? null
      : questions[currentIndex];
  bool get isFinished =>
      questions.isNotEmpty && currentIndex >= questions.length;
}

class PracticeQuizController extends AsyncNotifier<PracticeQuizState> {
  late final DatabaseRepository _repository;

  @override
  Future<PracticeQuizState> build() async {
    _repository = ref.watch(databaseRepositoryProvider);
    return _fetchData(null);
  }

  Future<PracticeQuizState> _fetchData(String? category) async {
    final questions = category != null
        ? await _repository.getQuestionsByCategory(category)
        : await _repository.getQuestionsByCategory('Road Rules');

    questions.shuffle();

    return PracticeQuizState(questions: questions);
  }

  Future<void> loadQuestions(String? category) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchData(category));
  }

  Future<void> submitAnswer(int index) async {
    final currentState = state.value;
    if (currentState == null || currentState.isRevealed) return;

    final question = currentState.currentQuestion;
    if (question == null) return;

    final isCorrect = index == question.correctAnswerIndex;

    await _repository.recordAnswer(question.id, isCorrect);

    state = AsyncData(
      currentState.copyWith(
        selectedIndex: index,
        isRevealed: true,
        correctCount: currentState.correctCount + (isCorrect ? 1 : 0),
      ),
    );
  }

  void nextQuestion() {
    final currentState = state.value;
    if (currentState == null || !currentState.isRevealed) return;

    state = AsyncData(
      PracticeQuizState(
        questions: currentState.questions,
        currentIndex: currentState.currentIndex + 1,
        selectedIndex: null,
        isRevealed: false,
        correctCount: currentState.correctCount,
      ),
    );
  }
}

final practiceQuizProvider =
    AsyncNotifierProvider<PracticeQuizController, PracticeQuizState>(() {
      return PracticeQuizController();
    });
