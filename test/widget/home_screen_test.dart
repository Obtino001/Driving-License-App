import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:driving_license_app/features/home/presentation/home_screen.dart';
import 'package:driving_license_app/features/home/presentation/widgets/progress_card.dart';
import 'package:driving_license_app/features/home/presentation/widgets/challenge_card.dart';
import 'package:driving_license_app/core/theme/app_theme.dart';

void main() {
  testWidgets('HomeScreen renders key components', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400); // Set a reasonable phone size
    tester.view.devicePixelRatio = 3.0;

    // We override necessary providers to avoid database calls
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.light,
          home: const HomeScreen(),
        ),
      ),
    );

    // Initial pump and settle for animations
    await tester.pumpAndSettle();

    // Check for TopBar greeting
    expect(find.text('Yasir'), findsOneWidget);

    // Check for ProgressCard
    expect(find.byType(ProgressCard), findsOneWidget);
    expect(find.text('Road Signs & Signals'), findsOneWidget);

    // Check for ChallengeCard
    expect(find.byType(ChallengeCard), findsOneWidget);
    expect(find.text('Daily Challenge'), findsOneWidget);

    // Check for Quick Actions
    expect(find.text('Mock Test'), findsOneWidget);
    expect(find.text('Road Signs'), findsOneWidget);
  });
}
