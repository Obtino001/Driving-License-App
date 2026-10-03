import 'package:dmv_practice/features/home/presentation/home_screen.dart';
import 'package:dmv_practice/features/home/presentation/widgets/home_sections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final width in [360.0, 393.0, 430.0]) {
    testWidgets(
      'Home sections fit $width px with large text and boundary values',
      (tester) async {
        tester.view.physicalSize = Size(width, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        for (final readiness in [0, 64, 99, 100]) {
          final sections = <Widget>[
            const HomeHeader(streak: 123),
            ReadinessJourneyHero(
              readiness: readiness,
              exploredTopics: 10,
              totalTopics: 10,
              onContinue: () {},
            ),
            TodayRecommendationCard(
              title: 'Very long intersection and right of way category name',
              onTap: () {},
            ),
            QuickActions(mistakesCount: 123, onOpen: _open),
            const DailyGoalCard(progress: 0),
            const DailyGoalCard(progress: 10),
            const JourneyPreview(
              currentTopic:
                  'Very long current topic name for responsive layout',
              currentProgress: 1,
              nextTopic: 'Very long next category and module name',
              onTap: _noop,
            ),
          ];
          for (final section in sections) {
            await tester.pumpWidget(
              MaterialApp(
                home: MediaQuery(
                  data: const MediaQueryData(
                    textScaler: TextScaler.linear(1.3),
                  ),
                  child: Scaffold(
                    body: ListView(
                      padding: const EdgeInsets.all(20),
                      children: [section],
                    ),
                  ),
                ),
              ),
            );
            await tester.pumpAndSettle();
            final exception = tester.takeException();
            expect(
              exception,
              isNull,
              reason: '${section.runtimeType} at $width px / $readiness%',
            );
          }
        }
      },
    );
  }
}

void _noop() {}

Future<void> _open(String route, {Object? extra}) async {}
