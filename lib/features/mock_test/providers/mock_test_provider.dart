library;

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../practice/data/models/question.dart';
import '../data/models/mock_test_config.dart';

/// State of an active Mock Test session.
@immutable
class MockTestState {
  const MockTestState({
    required this.config,
    required this.questions,
    this.currentIndex = 0,
    this.selectedAnswers = const {},
    this.flaggedIndices = const {},
    this.timeRemainingSeconds = 0,
    this.isSubmitted = false,
  });

  final MockTestConfig config;
  final List<Question> questions;
  final int currentIndex;
  
  /// Map of question index to selected answer index (0-3).
  final Map<int, int> selectedAnswers;
  
  /// Set of flagged question indices.
  final Set<int> flaggedIndices;
  
  final int timeRemainingSeconds;
  final bool isSubmitted;

  // Derived properties
  int get totalQuestions => questions.length;
  Question get currentQuestion => questions[currentIndex];
  int? get currentAnswer => selectedAnswers[currentIndex];
  bool get isCurrentFlagged => flaggedIndices.contains(currentIndex);
  
  int get answeredCount => selectedAnswers.length;
  int get unansweredCount => totalQuestions - answeredCount;
  
  bool get hasNext => currentIndex < totalQuestions - 1;
  bool get hasPrevious => currentIndex > 0;

  // Results calculation
  int get correctCount {
    if (!isSubmitted) return 0;
    int count = 0;
    for (int i = 0; i < totalQuestions; i++) {
      if (selectedAnswers[i] == questions[i].correctIndex) {
        count++;
      }
    }
    return count;
  }

  int get incorrectCount => isSubmitted ? answeredCount - correctCount : 0;
  
  double get accuracy => isSubmitted && totalQuestions > 0 
      ? correctCount / totalQuestions 
      : 0.0;
      
  bool get isPassed => isSubmitted && accuracy >= (config.passingScorePercentage / 100);

  int get timeUsedSeconds => (config.timeLimitMinutes * 60) - timeRemainingSeconds;

  MockTestState copyWith({
    MockTestConfig? config,
    List<Question>? questions,
    int? currentIndex,
    Map<int, int>? selectedAnswers,
    Set<int>? flaggedIndices,
    int? timeRemainingSeconds,
    bool? isSubmitted,
  }) {
    return MockTestState(
      config: config ?? this.config,
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
      flaggedIndices: flaggedIndices ?? this.flaggedIndices,
      timeRemainingSeconds: timeRemainingSeconds ?? this.timeRemainingSeconds,
      isSubmitted: isSubmitted ?? this.isSubmitted,
    );
  }
}

class MockTestNotifier extends StateNotifier<MockTestState> {
  MockTestNotifier({
    required MockTestConfig config,
    required List<Question> questions,
  }) : super(MockTestState(
          config: config,
          questions: questions,
          timeRemainingSeconds: config.timeLimitMinutes * 60,
        )) {
    _startTimer();
  }

  Timer? _timer;

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.isSubmitted) {
        timer.cancel();
        return;
      }
      
      if (state.timeRemainingSeconds > 0) {
        state = state.copyWith(
          timeRemainingSeconds: state.timeRemainingSeconds - 1,
        );
      } else {
        submitTest();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void selectAnswer(int optionIndex) {
    if (state.isSubmitted) return;
    
    final updatedAnswers = Map<int, int>.from(state.selectedAnswers);
    updatedAnswers[state.currentIndex] = optionIndex;
    
    state = state.copyWith(selectedAnswers: updatedAnswers);
  }

  void toggleFlag() {
    if (state.isSubmitted) return;
    
    final updatedFlags = Set<int>.from(state.flaggedIndices);
    if (updatedFlags.contains(state.currentIndex)) {
      updatedFlags.remove(state.currentIndex);
    } else {
      updatedFlags.add(state.currentIndex);
    }
    
    state = state.copyWith(flaggedIndices: updatedFlags);
  }

  void nextQuestion() {
    if (state.hasNext) {
      state = state.copyWith(currentIndex: state.currentIndex + 1);
    }
  }

  void previousQuestion() {
    if (state.hasPrevious) {
      state = state.copyWith(currentIndex: state.currentIndex - 1);
    }
  }

  void jumpToQuestion(int index) {
    if (index >= 0 && index < state.totalQuestions) {
      state = state.copyWith(currentIndex: index);
    }
  }

  void submitTest() {
    if (state.isSubmitted) return;
    _timer?.cancel();
    state = state.copyWith(isSubmitted: true);
  }
}

final mockTestProvider = StateNotifierProvider.autoDispose<MockTestNotifier, MockTestState>(
  (ref) => throw UnimplementedError('mockTestProvider must be overridden'),
);
