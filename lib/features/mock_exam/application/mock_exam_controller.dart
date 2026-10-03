import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';

const mockExamProfileId = 'development_california_class_c';
const mockExamState = 'CA';
const mockExamLicenseType = 'Class C';
const mockExamQuestionCount = 20; // Using 20 for development simulation
const mockExamPassingRequirement = 16; // 80% of 20

class MockExamState {
  final ExamSession? session;
  final List<ExamSessionQuestion>? sessionQuestions;
  final List<Question>? questions;
  final int currentIndex;
  final bool isLoading;
  final bool isSubmitting;

  MockExamState({
    this.session,
    this.sessionQuestions,
    this.questions,
    this.currentIndex = 0,
    this.isLoading = true,
    this.isSubmitting = false,
  });

  MockExamState copyWith({
    ExamSession? session,
    List<ExamSessionQuestion>? sessionQuestions,
    List<Question>? questions,
    int? currentIndex,
    bool? isLoading,
    bool? isSubmitting,
  }) {
    return MockExamState(
      session: session ?? this.session,
      sessionQuestions: sessionQuestions ?? this.sessionQuestions,
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}

class MockExamController extends Notifier<MockExamState> {
  @override
  MockExamState build() {
    return MockExamState();
  }

  Future<void> checkResume() async {
    final repo = ref.read(databaseRepositoryProvider);
    final inProgress = await repo.getInProgressSession();
    if (inProgress != null) {
      await resumeExam(inProgress);
    }
  }

  Future<void> resumeExam(ExamSession session) async {
    state = state.copyWith(isLoading: true);
    final repo = ref.read(databaseRepositoryProvider);
    
    final questions = await repo.getQuestionsForSession(session.id);
    final sessionQuestions = await repo.getExamSessionQuestions(session.id);
    
    // Find first unanswered question
    int firstUnanswered = sessionQuestions.indexWhere((q) => q.selectedAnswerIndex == null);
    if (firstUnanswered == -1) firstUnanswered = 0;

    state = state.copyWith(
      session: session,
      questions: questions,
      sessionQuestions: sessionQuestions,
      currentIndex: firstUnanswered,
      isLoading: false,
    );
  }

  Future<void> startExam() async {
    state = state.copyWith(isLoading: true);
    final repo = ref.read(databaseRepositoryProvider);
    
    // In case there is an in progress session, abandon it or maybe we shouldn't allow starting a new one.
    // For now, let's just create a new one.
    
    // Load eligible questions. We shuffle in Dart.
    // To ensure category balance we could do something complex, but a shuffled slice is fine for development.
    // Get all questions, shuffle, take up to mockExamQuestionCount.
    // NOTE: This uses all questions in db for now.
    // If we only wanted specific categories we would query those.
    final db = ref.read(databaseProvider);
    final allQuestions = await db.select(db.questions).get();
    
    allQuestions.shuffle();
    final examQuestions = allQuestions.take(mockExamQuestionCount).toList();

    final session = await repo.createExamSession(
      profileId: mockExamProfileId,
      state: mockExamState,
      licenseType: mockExamLicenseType,
      passingRequirement: (examQuestions.length * 0.8).round(), // Dynamic based on actual count
      questions: examQuestions,
    );
    
    final sessionQuestions = await repo.getExamSessionQuestions(session.id);

    state = state.copyWith(
      session: session,
      questions: examQuestions,
      sessionQuestions: sessionQuestions,
      currentIndex: 0,
      isLoading: false,
    );
  }

  Future<void> selectAnswer(int optionIndex) async {
    if (state.session == null || state.sessionQuestions == null) return;
    
    final currentQ = state.sessionQuestions![state.currentIndex];
    
    final repo = ref.read(databaseRepositoryProvider);
    await repo.updateExamSessionAnswer(state.session!.id, currentQ.questionId, optionIndex);
    
    // Update local state
    final updatedList = List<ExamSessionQuestion>.from(state.sessionQuestions!);
    updatedList[state.currentIndex] = currentQ.copyWith(selectedAnswerIndex: Value(optionIndex));
    
    state = state.copyWith(sessionQuestions: updatedList);
  }

  Future<void> toggleFlag() async {
    if (state.session == null || state.sessionQuestions == null) return;
    
    final currentQ = state.sessionQuestions![state.currentIndex];
    final newFlag = !currentQ.isFlagged;
    
    final repo = ref.read(databaseRepositoryProvider);
    await repo.updateExamSessionFlag(state.session!.id, currentQ.questionId, newFlag);
    
    // Update local state
    final updatedList = List<ExamSessionQuestion>.from(state.sessionQuestions!);
    updatedList[state.currentIndex] = currentQ.copyWith(isFlagged: Value(newFlag));
    
    state = state.copyWith(sessionQuestions: updatedList);
  }

  void nextQuestion() {
    if (state.questions != null && state.currentIndex < state.questions!.length - 1) {
      state = state.copyWith(currentIndex: state.currentIndex + 1);
    }
  }

  void previousQuestion() {
    if (state.currentIndex > 0) {
      state = state.copyWith(currentIndex: state.currentIndex - 1);
    }
  }

  void goToQuestion(int index) {
    if (state.questions != null && index >= 0 && index < state.questions!.length) {
      state = state.copyWith(currentIndex: index);
    }
  }

  Future<void> submitExam() async {
    if (state.session == null || state.sessionQuestions == null) return;
    state = state.copyWith(isSubmitting: true);
    
    // Calculate score
    int correctCount = 0;
    for (final q in state.sessionQuestions!) {
      if (q.selectedAnswerIndex != null && q.selectedAnswerIndex == q.correctAnswerIndex) {
        correctCount++;
      }
    }
    
    final repo = ref.read(databaseRepositoryProvider);
    await repo.finishExamSession(state.session!.id, correctCount);
    
    // We don't reset state here. The result screen will read the state.
    state = state.copyWith(isSubmitting: false);
  }
}

final mockExamProvider = NotifierProvider<MockExamController, MockExamState>(MockExamController.new);
