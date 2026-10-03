import 'package:dmv_practice/core/database/app_database.dart';
import 'package:dmv_practice/core/widgets/visual_scenario.dart';
import 'package:dmv_practice/features/learn/application/learn_controller.dart';
import 'package:dmv_practice/features/learn/presentation/learn_screen.dart';
import 'package:dmv_practice/features/practice/application/practice_quiz_controller.dart';
import 'package:dmv_practice/features/practice/presentation/practice_quiz_screen.dart';

import 'package:dmv_practice/features/signs/presentation/flashcards_screen.dart';
import 'package:dmv_practice/features/signs/presentation/signs_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final width in [360.0, 393.0, 430.0]) {
    testWidgets('Core learning layouts fit $width px at large text scale', (
      tester,
    ) async {
      tester.view.physicalSize = Size(width, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final longModule = LearnModule(
        title: 'Long category name about sharing the road with everyone',
        category: 'Sharing the Road',
        totalQuestions: 10,
        completedQuestions: 10,
        accuracy: 1,
      );
      final sections = <Widget>[
        const QuizProgressHeader(
          index: 9,
          total: 10,
          category: 'Very long category name for the progress header',
          onClose: _noop,
        ),
        const PremiumAnswerCard(
          index: 2,
          text: 'A long answer option explaining how to react carefully at an uncontrolled intersection while other vehicles are approaching.',
          revealed: true,
          selected: true,
          correct: false,
          onTap: _noop,
        ),
        const VisualScenario(),
        ModuleJourneyNode(
          module: longModule,
          index: 9,
          isLast: true,
          isCurrent: true,
          onTap: _noop,
        ),
        SignStudyCard(
          sign: const RoadSign(
            id: 'long',
            name: 'A very long sign name that needs room to wrap',
            category: 'Regulatory',
            shortMeaning: 'A detailed meaning that continues onto another line on a narrow device.',
            detailedMeaning: 'A detailed meaning that continues onto another line on a narrow device.',
            commonMistake: 'Missing it.',
            assetPath: 'assets/signs/stop.svg',
            reviewStatus: 'verified',
            contentVersion: 1,
          ),
          onTap: _noop,
        ),
      ];

      for (final section in sections) {
        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(textScaler: TextScaler.linear(1.3)),
              child: Scaffold(
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: section,
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(
          tester.takeException(),
          isNull,
          reason: '${section.runtimeType} at $width px',
        );
      }

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(textScaler: TextScaler.linear(1.3)),
              child: const SignsScreen(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        tester.takeException(),
        isNull,
        reason: 'SignsScreen at $width px',
      );
      await tester.drag(find.byType(ListView).first, const Offset(0, -300));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text('Warning'),
        100,
        scrollable: find.byType(Scrollable).last,
      );
      await tester.ensureVisible(find.text('Warning'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Warning'));
      await tester.pumpAndSettle();
      expect(find.text('Merging Traffic'), findsOneWidget);
      await tester.tap(find.text('Merging Traffic'));
      await tester.pumpAndSettle();
      expect(find.text('EASY TO MISS'), findsOneWidget);
      expect(
        tester.takeException(),
        isNull,
        reason: 'Sign detail at $width px',
      );
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(textScaler: TextScaler.linear(1.3)),
              child: const FlashcardsScreen(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        tester.takeException(),
        isNull,
        reason: 'Flashcards front at $width px',
      );
      await tester.tap(find.text('Reveal meaning'));
      await tester.pumpAndSettle();
      expect(find.text('WATCH FOR THIS'), findsOneWidget);
      expect(
        tester.takeException(),
        isNull,
        reason: 'Flashcards back at $width px',
      );

      await tester.pumpWidget(
        ProviderScope(
          key: UniqueKey(),
          overrides: [learnProvider.overrideWith(_TestLearnController.new)],
          child: MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(textScaler: TextScaler.linear(1.3)),
              child: const LearnScreen(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        tester.takeException(),
        isNull,
        reason: 'LearnScreen at $width px',
      );
      await tester.scrollUntilVisible(
        find.text('Right of Way'),
        180,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.ensureVisible(find.text('Right of Way'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Right of Way'));
      await tester.pumpAndSettle();
      expect(find.text('ACCURACY'), findsOneWidget);
      expect(
        tester.takeException(),
        isNull,
        reason: 'Module detail at $width px',
      );
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      await tester.pumpWidget(
        ProviderScope(
          key: UniqueKey(),
          overrides: [
            practiceQuizProvider.overrideWith(_TestQuizController.new),
          ],
          child: MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(textScaler: TextScaler.linear(1.3)),
              child: const PracticeQuizScreen(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        tester.takeException(),
        isNull,
        reason: 'Quiz initial at $width px',
      );
      await tester.ensureVisible(find.byType(PremiumAnswerCard).first);
      await tester.tap(find.byType(PremiumAnswerCard).first);
      await tester.pumpAndSettle();
      expect(find.byType(ExplanationPanel), findsOneWidget);
      expect(
        tester.takeException(),
        isNull,
        reason: 'Quiz explanation at $width px',
      );
    });
  }
}

void _noop() {}

class _TestLearnController extends LearnController {
  @override
  Future<LearnState> build() async => LearnState(
    modules: [
      LearnModule(
        title: 'Right of Way',
        category: 'Right of Way',
        totalQuestions: 10,
        completedQuestions: 7,
        accuracy: .72,
      ),
      LearnModule(
        title: 'Long category name about sharing the road with everyone',
        category: 'Sharing the Road',
        totalQuestions: 10,
        completedQuestions: 0,
      ),
    ],
  );
}

class _TestQuizController extends PracticeQuizController {
  PracticeQuizState get _testState => PracticeQuizState(
    questions: [
      Question(
        id: 'layout_test',
        state: 'CA',
        licenseType: 'ClassC',
        category: 'A very long category name for the quiz header',
        difficulty: 1,
        questionText: 'At a busy intersection with a marked crosswalk and several approaching vehicles, what should a careful driver do first?',
        answerA: 'Slow down, check the crosswalk and all approaching traffic, then yield when required.',
        answerB: 'Accelerate to clear the intersection before anyone enters the crosswalk.',
        answerC: 'Stop in the middle of the crossing to decide which direction to travel.',
        correctAnswerIndex: 0,
        explanationShort:
            'Check for people and approaching traffic before you proceed.',
        explanationDetailed: 'A careful driver makes space for people in the crossing and yields to traffic with the right of way.',
        contentVersion: 1,
        reviewStatus: 'verified',
        isActive: true,
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      ),
    ],
  );

  @override
  Future<PracticeQuizState> build() async => _testState;

  @override
  Future<void> loadQuestions(String? category) async {
    state = AsyncData(_testState);
  }

  @override
  Future<void> submitAnswer(int index) async {
    final current = state.value!;
    state = AsyncData(
      current.copyWith(
        selectedIndex: index,
        isRevealed: true,
        correctCount: index == 0 ? 1 : 0,
      ),
    );
  }
}
