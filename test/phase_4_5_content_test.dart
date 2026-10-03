import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dmv_practice/features/scenarios/domain/scenario_models.dart';
import 'package:dmv_practice/features/scenarios/presentation/visual_scenario_widget.dart';

void main() {
  group('Phase 4.5 Content Completion Tests', () {
    late List<dynamic> questions;
    late List<dynamic> signs;

    setUpAll(() {
      final qFile = File('assets/content/questions_v1.json');
      final sFile = File('assets/content/signs_v1.json');

      final qData = jsonDecode(qFile.readAsStringSync());
      final sData = jsonDecode(sFile.readAsStringSync());

      questions = qData['questions'];
      signs = sData['signs'];
    });

    test('all 50 questions parse and exist', () {
      expect(
        questions.length,
        50,
        reason: 'There must be exactly 50 questions.',
      );
    });

    test('sign count and category coverage', () {
      expect(
        signs.length,
        greaterThanOrEqualTo(15),
        reason: 'There must be at least 15 signs.',
      );
      final categories = signs.map((s) => s['category']).toSet();
      expect(
        categories.containsAll([
          'Regulatory',
          'Warning',
          'Guide',
          'Construction',
          'Railroad',
        ]),
        isTrue,
      );
    });

    test('minimum visual scenario count', () {
      final visualQs = questions
          .where((q) => q['assetType'] == 'scenario')
          .toList();
      expect(
        visualQs.length,
        greaterThanOrEqualTo(10),
        reason: 'There must be at least 10 visual scenarios.',
      );
    });

    test('minimum animated-scenario count', () {
      final animatedQs = questions
          .where(
            (q) => q['assetType'] == 'scenario' && q['motionVariant'] != null,
          )
          .toList();
      expect(
        animatedQs.length,
        greaterThanOrEqualTo(5),
        reason: 'There must be at least 5 animated scenarios.',
      );
    });

    test('all scenario IDs resolve to enum', () {
      final visualQs = questions
          .where((q) => q['assetType'] == 'scenario')
          .toList();
      for (final q in visualQs) {
        final path = q['assetPath'];
        expect(
          () => ScenarioType.values.byName(path),
          returnsNormally,
          reason: 'Scenario ID "$path" must resolve to ScenarioType enum',
        );
      }
    });

    test('all referenced assets exist', () {
      final assetQs = questions
          .where((q) => q['assetType'] == 'image' || q['assetType'] == 'svg')
          .toList();
      for (final q in assetQs) {
        final path = q['assetPath'];
        final file = File(path);
        expect(
          file.existsSync(),
          isTrue,
          reason: 'Asset file must exist at $path',
        );
      }

      for (final s in signs) {
        final path = s['assetPath'];
        final file = File(path);
        expect(
          file.existsSync(),
          isTrue,
          reason: 'Asset file must exist at $path',
        );
      }
    });

    testWidgets('Practice visual scenario rendering', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VisualScenarioWidget(
              type: ScenarioType.highwayMerge,
              state: ScenarioState.initial,
            ),
          ),
        ),
      );

      expect(find.byType(VisualScenarioWidget), findsOneWidget);
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('reduced-motion scenario state', (WidgetTester tester) async {
      // Pump with disableAnimations: true
      await tester.pumpWidget(
        const MediaQuery(
          data: MediaQueryData(disableAnimations: true),
          child: MaterialApp(
            home: Scaffold(
              body: VisualScenarioWidget(
                type: ScenarioType.fourWayIntersection,
                state: ScenarioState.highlighted,
                animate: true,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(VisualScenarioWidget), findsOneWidget);

      // Since animation is 1.5s, wait a tiny bit and the progress should jump or remain static.
      await tester.pump(const Duration(milliseconds: 100));
      // In reduced motion, it should just paint the final state immediately.
    });
  });
}
