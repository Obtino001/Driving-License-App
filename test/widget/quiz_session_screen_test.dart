import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:driving_license_app/features/practice/presentation/quiz_session_screen.dart';
import 'package:driving_license_app/features/practice/presentation/widgets/answer_option.dart';
import 'package:driving_license_app/features/practice/presentation/widgets/explanation_panel.dart';
import 'package:driving_license_app/features/practice/data/models/question.dart';
import 'package:driving_license_app/features/practice/data/repositories/question_repository.dart';
import 'package:driving_license_app/features/practice/providers/quiz_session_provider.dart';
import 'package:driving_license_app/core/theme/app_theme.dart';
import 'package:mocktail/mocktail.dart';

class MockQuestionRepository extends Mock implements SqlQuestionRepository {}

void main() {
  late MockQuestionRepository mockRepository;
  late List<Question> testQuestions;

  setUp(() {
    mockRepository = MockQuestionRepository();
    when(() => mockRepository.saveQuestionResult(any(), any()))
        .thenAnswer((_) async {});

    testQuestions = [
      const Question(
        id: 'q1',
        text: 'What does a stop sign mean?',
        options: ['Stop', 'Yield', 'Go', 'Slow down'],
        correctIndex: 0,
        explanation: 'You must come to a complete stop.',
        category: 'Signs',
      ),
    ];
  });

  testWidgets('QuizSessionScreen renders correctly and handles answer selection', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sqlQuestionRepositoryProvider.overrideWithValue(mockRepository),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: QuizSessionScreen(
            questions: testQuestions,
            title: 'Practice Test',
          ),
        ),
      ),
    );

    // Initial state: question text and options are visible
    expect(find.text('What does a stop sign mean?'), findsOneWidget);
    expect(find.byType(AnswerOption), findsNWidgets(4));
    expect(find.text('Stop'), findsOneWidget);
    
    // Explanation should not be visible initially
    expect(find.byType(ExplanationPanel), findsNothing);

    // Tap the correct answer
    await tester.tap(find.text('Stop'));
    await tester.pumpAndSettle(); // Wait for animations

    // Now explanation panel should be visible
    expect(find.byType(ExplanationPanel), findsOneWidget);
    expect(find.text('You must come to a complete stop.'), findsOneWidget);
  });
}
