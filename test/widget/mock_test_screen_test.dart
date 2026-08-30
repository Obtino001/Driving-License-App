import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:driving_license_app/features/mock_test/presentation/mock_test_session_screen.dart';
import 'package:driving_license_app/features/mock_test/data/models/mock_test_config.dart';
import 'package:driving_license_app/features/practice/data/models/question.dart';
import 'package:driving_license_app/features/mock_test/providers/mock_test_provider.dart';
import 'package:driving_license_app/core/theme/app_theme.dart';

void main() {
  late List<Question> testQuestions;
  late MockTestConfig testConfig;

  setUp(() {
    testQuestions = [
      const Question(
        id: 'q1',
        text: 'Mock Test Question 1',
        options: ['A', 'B', 'C', 'D'],
        correctIndex: 0,
        explanation: 'Explanation 1',
        category: 'Signs',
      ),
    ];

    testConfig = const MockTestConfig(
      questionCount: 1,
      timeLimitMinutes: 10,
      passingScorePercentage: 80,
    );
  });

  testWidgets('MockTestSessionScreen renders timer and questions correctly', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.light,
          home: MockTestSessionScreen(
            config: testConfig,
            questions: testQuestions,
          ),
        ),
      ),
    );

    // Initial state
    expect(find.text('Mock Test Question 1'), findsOneWidget);
    
    // There should be a timer widget or text indicating remaining time
    // Timer text starts with 10:00 (10 minutes)
    expect(find.textContaining(':'), findsWidgets); // e.g. 10:00

    // Tap an answer
    await tester.tap(find.text('A'));
    await tester.pumpAndSettle();

    // Unlike practice session, mock test should NOT show explanation panel immediately
    expect(find.text('Explanation 1'), findsNothing);

    // Submit test button should be present
    expect(find.text('Submit Test'), findsOneWidget);
  });
}
