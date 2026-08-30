import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:driving_license_app/features/practice/data/models/question.dart';
import 'package:driving_license_app/features/practice/data/repositories/question_repository.dart';
import 'package:driving_license_app/features/practice/providers/quiz_session_provider.dart';

class MockQuestionRepository extends Mock implements SqlQuestionRepository {}

void main() {
  late MockQuestionRepository mockRepository;
  late List<Question> testQuestions;

  setUp(() {
    mockRepository = MockQuestionRepository();
    
    // Mock saveQuestionResult to return Future.value()
    when(() => mockRepository.saveQuestionResult(any(), any()))
        .thenAnswer((_) async {});

    testQuestions = [
      const Question(
        id: 'q1',
        text: 'Question 1',
        options: ['A', 'B', 'C', 'D'],
        correctIndex: 0,
        explanation: 'Explanation 1',
        category: 'cat1',
      ),
      const Question(
        id: 'q2',
        text: 'Question 2',
        options: ['A', 'B', 'C', 'D'],
        correctIndex: 1,
        explanation: 'Explanation 2',
        category: 'cat1',
      ),
    ];
  });

  group('QuizSessionNotifier', () {
    test('initial state is correct', () {
      final notifier = QuizSessionNotifier(
        questions: testQuestions,
        repository: mockRepository,
      );

      final state = notifier.state;
      expect(state.totalQuestions, 2);
      expect(state.currentIndex, 0);
      expect(state.answeredCount, 0);
      expect(state.isCompleted, false);
      expect(state.showExplanation, false);
    });

    test('selectAnswer updates state correctly on correct answer', () {
      final notifier = QuizSessionNotifier(
        questions: testQuestions,
        repository: mockRepository,
      );

      notifier.selectAnswer(0); // correct answer for q1

      final state = notifier.state;
      expect(state.answeredCount, 1);
      expect(state.correctCount, 1);
      expect(state.incorrectCount, 0);
      expect(state.showExplanation, true);
      expect(state.currentResult.status, QuestionStatus.correct);
      
      verify(() => mockRepository.saveQuestionResult('q1', true)).called(1);
    });

    test('selectAnswer updates state correctly on incorrect answer', () {
      final notifier = QuizSessionNotifier(
        questions: testQuestions,
        repository: mockRepository,
      );

      notifier.selectAnswer(2); // incorrect answer for q1

      final state = notifier.state;
      expect(state.answeredCount, 1);
      expect(state.correctCount, 0);
      expect(state.incorrectCount, 1);
      expect(state.showExplanation, true);
      expect(state.currentResult.status, QuestionStatus.incorrect);

      verify(() => mockRepository.saveQuestionResult('q1', false)).called(1);
    });

    test('nextQuestion moves to next question', () {
      final notifier = QuizSessionNotifier(
        questions: testQuestions,
        repository: mockRepository,
      );

      notifier.selectAnswer(0);
      notifier.nextQuestion();

      final state = notifier.state;
      expect(state.currentIndex, 1);
      expect(state.showExplanation, false);
      expect(state.isCompleted, false);
    });

    test('nextQuestion completes session when no more questions', () {
      final notifier = QuizSessionNotifier(
        questions: testQuestions,
        repository: mockRepository,
      );

      notifier.selectAnswer(0); // Q1
      notifier.nextQuestion();  // Move to Q2
      notifier.selectAnswer(1); // Q2
      notifier.nextQuestion();  // Complete

      final state = notifier.state;
      expect(state.isCompleted, true);
      expect(state.currentIndex, 1); // Stays at last index
      expect(state.showExplanation, false);
    });

    test('accuracy calculates correctly', () {
      final notifier = QuizSessionNotifier(
        questions: testQuestions,
        repository: mockRepository,
      );

      notifier.selectAnswer(0); // correct
      notifier.nextQuestion();
      notifier.selectAnswer(0); // incorrect for q2 (correct is 1)

      final state = notifier.state;
      expect(state.accuracy, 50); // 1 out of 2
    });
  });
}
