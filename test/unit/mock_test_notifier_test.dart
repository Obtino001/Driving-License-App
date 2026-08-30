import 'package:flutter_test/flutter_test.dart';
import 'package:driving_license_app/features/practice/data/models/question.dart';
import 'package:driving_license_app/features/mock_test/data/models/mock_test_config.dart';
import 'package:driving_license_app/features/mock_test/providers/mock_test_provider.dart';

void main() {
  late List<Question> testQuestions;
  late MockTestConfig testConfig;

  setUp(() {
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
      const Question(
        id: 'q3',
        text: 'Question 3',
        options: ['A', 'B', 'C', 'D'],
        correctIndex: 2,
        explanation: 'Explanation 3',
        category: 'cat1',
      ),
    ];

    testConfig = const MockTestConfig(
      questionCount: 3,
      timeLimitMinutes: 10,
      passingScorePercentage: 80,
    );
  });

  group('MockTestNotifier', () {
    test('initial state is correct', () {
      final notifier = MockTestNotifier(
        config: testConfig,
        questions: testQuestions,
      );

      final state = notifier.state;
      expect(state.totalQuestions, 3);
      expect(state.currentIndex, 0);
      expect(state.timeRemainingSeconds, 600);
      expect(state.isSubmitted, false);
      expect(state.answeredCount, 0);
      expect(state.unansweredCount, 3);
      
      notifier.dispose();
    });

    test('selectAnswer updates answers map', () {
      final notifier = MockTestNotifier(
        config: testConfig,
        questions: testQuestions,
      );

      notifier.selectAnswer(2);

      expect(notifier.state.selectedAnswers[0], 2);
      expect(notifier.state.answeredCount, 1);
      
      notifier.dispose();
    });

    test('toggleFlag updates flagged indices', () {
      final notifier = MockTestNotifier(
        config: testConfig,
        questions: testQuestions,
      );

      expect(notifier.state.isCurrentFlagged, false);
      
      notifier.toggleFlag();
      expect(notifier.state.isCurrentFlagged, true);
      
      notifier.toggleFlag();
      expect(notifier.state.isCurrentFlagged, false);
      
      notifier.dispose();
    });

    test('navigation methods work correctly', () {
      final notifier = MockTestNotifier(
        config: testConfig,
        questions: testQuestions,
      );

      expect(notifier.state.currentIndex, 0);
      
      notifier.nextQuestion();
      expect(notifier.state.currentIndex, 1);
      
      notifier.previousQuestion();
      expect(notifier.state.currentIndex, 0);
      
      notifier.jumpToQuestion(2);
      expect(notifier.state.currentIndex, 2);
      
      notifier.dispose();
    });

    test('submitTest calculates results correctly', () {
      final notifier = MockTestNotifier(
        config: testConfig,
        questions: testQuestions,
      );

      // Answer Q1 correctly
      notifier.jumpToQuestion(0);
      notifier.selectAnswer(0);
      
      // Answer Q2 correctly
      notifier.jumpToQuestion(1);
      notifier.selectAnswer(1);
      
      // Answer Q3 incorrectly
      notifier.jumpToQuestion(2);
      notifier.selectAnswer(0);

      notifier.submitTest();

      final state = notifier.state;
      expect(state.isSubmitted, true);
      expect(state.correctCount, 2);
      expect(state.incorrectCount, 1);
      expect(state.accuracy, closeTo(0.666, 0.01));
      
      // Passing score is 80%, we got 66% -> fail
      expect(state.isPassed, false);
      
      notifier.dispose();
    });

    test('submitTest sets isPassed to true if score meets threshold', () {
      final config = const MockTestConfig(
        questionCount: 3,
        timeLimitMinutes: 10,
        passingScorePercentage: 60,
      );
      
      final notifier = MockTestNotifier(
        config: config,
        questions: testQuestions,
      );

      // Answer Q1 correctly
      notifier.jumpToQuestion(0);
      notifier.selectAnswer(0);
      
      // Answer Q2 correctly
      notifier.jumpToQuestion(1);
      notifier.selectAnswer(1);
      
      // Leave Q3 unanswered

      notifier.submitTest();

      final state = notifier.state;
      expect(state.isSubmitted, true);
      expect(state.correctCount, 2);
      expect(state.incorrectCount, 0); 
      expect(state.accuracy, closeTo(0.666, 0.01));
      
      // Passing score is 60%, we got 66% -> pass
      expect(state.isPassed, true);
      
      notifier.dispose();
    });
  });
}
