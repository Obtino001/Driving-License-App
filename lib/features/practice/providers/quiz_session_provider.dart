/// Quiz session state management with Riverpod.
///
/// Manages the complete lifecycle of a quiz session:
/// unanswered → selected → correct/incorrect → explanation → next → completed.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/question.dart';

/// Immutable state of the entire quiz session.
@immutable
class QuizSessionState {
  const QuizSessionState({
    required this.questions,
    this.currentIndex = 0,
    this.results = const [],
    this.isCompleted = false,
    this.showExplanation = false,
  });

  /// All questions in this session.
  final List<Question> questions;

  /// Index of the currently displayed question.
  final int currentIndex;

  /// Results for each question (parallel to [questions]).
  final List<QuestionResult> results;

  /// Whether the session is complete.
  final bool isCompleted;

  /// Whether to show the explanation panel.
  final bool showExplanation;

  // ─── Derived getters ─────────────────────────────────────────────────

  /// Total number of questions.
  int get totalQuestions => questions.length;

  /// The currently displayed question.
  Question get currentQuestion => questions[currentIndex];

  /// The result for the current question.
  QuestionResult get currentResult => results[currentIndex];

  /// Progress as a value from 0.0 to 1.0.
  double get progress =>
      totalQuestions > 0 ? (currentIndex + 1) / totalQuestions : 0;

  /// Number of correctly answered questions.
  int get correctCount =>
      results.where((r) => r.status == QuestionStatus.correct).length;

  /// Number of incorrectly answered questions.
  int get incorrectCount =>
      results.where((r) => r.status == QuestionStatus.incorrect).length;

  /// Number of answered questions.
  int get answeredCount =>
      results.where((r) => r.isAnswered).length;

  /// Accuracy as percentage (0-100).
  int get accuracy =>
      answeredCount > 0
          ? ((correctCount / answeredCount) * 100).round()
          : 0;

  /// Whether the current question has been answered.
  bool get isCurrentAnswered => currentResult.isAnswered;

  /// Whether there's a next question.
  bool get hasNext => currentIndex < totalQuestions - 1;

  /// Set of bookmarked question indices.
  Set<int> get bookmarkedIndices =>
      results
          .where((r) => r.isBookmarked)
          .map((r) => r.questionIndex)
          .toSet();

  QuizSessionState copyWith({
    List<Question>? questions,
    int? currentIndex,
    List<QuestionResult>? results,
    bool? isCompleted,
    bool? showExplanation,
  }) {
    return QuizSessionState(
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      results: results ?? this.results,
      isCompleted: isCompleted ?? this.isCompleted,
      showExplanation: showExplanation ?? this.showExplanation,
    );
  }
}

/// Manages quiz session state transitions.
class QuizSessionNotifier extends StateNotifier<QuizSessionState> {
  QuizSessionNotifier(List<Question> questions)
      : super(QuizSessionState(
          questions: questions,
          results: List.generate(
            questions.length,
            (i) => QuestionResult(questionIndex: i),
          ),
        ));

  /// User selects an answer. Immediately reveals correct/incorrect.
  void selectAnswer(int answerIndex) {
    if (state.isCurrentAnswered) return; // Already answered

    final question = state.currentQuestion;
    final isCorrect = answerIndex == question.correctIndex;

    final updatedResults = List<QuestionResult>.from(state.results);
    updatedResults[state.currentIndex] = state.currentResult.copyWith(
      selectedIndex: answerIndex,
      status: isCorrect ? QuestionStatus.correct : QuestionStatus.incorrect,
    );

    state = state.copyWith(
      results: updatedResults,
      showExplanation: true,
    );
  }

  /// Move to the next question.
  void nextQuestion() {
    if (state.hasNext) {
      state = state.copyWith(
        currentIndex: state.currentIndex + 1,
        showExplanation: false,
      );
    } else {
      state = state.copyWith(
        isCompleted: true,
        showExplanation: false,
      );
    }
  }

  /// Toggle bookmark on the current question.
  void toggleBookmark() {
    final updatedResults = List<QuestionResult>.from(state.results);
    updatedResults[state.currentIndex] = state.currentResult.copyWith(
      isBookmarked: !state.currentResult.isBookmarked,
    );
    state = state.copyWith(results: updatedResults);
  }

  /// Jump to a specific question (for review mode).
  void goToQuestion(int index) {
    if (index >= 0 && index < state.totalQuestions) {
      state = state.copyWith(
        currentIndex: index,
        showExplanation: state.results[index].isAnswered,
      );
    }
  }
}

/// Provider for the quiz session. Must be overridden when starting a session.
final quizSessionProvider =
    StateNotifierProvider.autoDispose<QuizSessionNotifier, QuizSessionState>(
  (ref) => throw UnimplementedError(
    'quizSessionProvider must be overridden with questions',
  ),
);
