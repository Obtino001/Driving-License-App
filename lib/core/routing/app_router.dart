import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../motion/app_motion.dart';
import '../preferences/preferences_provider.dart';
import 'app_shell.dart';

import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/practice/presentation/practice_landing_screen.dart';
import '../../features/practice/presentation/practice_quiz_screen.dart';
import '../../features/mistakes/presentation/mistakes_screen.dart';
import '../../features/learn/presentation/learn_screen.dart';
import '../../features/signs/presentation/signs_screen.dart';
import '../../features/signs/presentation/flashcards_screen.dart';
import '../../features/progress/presentation/progress_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/mock_exam/presentation/mock_exam_intro_screen.dart';
import '../../features/mock_exam/presentation/mock_exam_screen.dart';
import '../../features/mock_exam/presentation/mock_exam_review_screen.dart';
import '../../features/mock_exam/presentation/mock_exam_result_screen.dart';
import '../../features/mock_exam/presentation/mock_exam_answers_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  final onboardingComplete = prefs.getBool('onboarding_complete') ?? false;

  return GoRouter(
    initialLocation: onboardingComplete ? '/home' : '/onboarding',
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                pageBuilder: (context, state) =>
                    _editorialPage(state, const HomeScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/learn',
                pageBuilder: (context, state) =>
                    _editorialPage(state, const LearnScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/practice',
                pageBuilder: (context, state) =>
                    _editorialPage(state, const PracticeLandingScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/progress',
                pageBuilder: (context, state) =>
                    _editorialPage(state, const ProgressScreen()),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/settings',
        pageBuilder: (context, state) =>
            _editorialPage(state, const SettingsScreen()),
      ),
      GoRoute(
        path: '/mistakes',
        pageBuilder: (context, state) =>
            _editorialPage(state, const MistakesScreen()),
      ),
      GoRoute(
        path: '/signs',
        pageBuilder: (context, state) =>
            _editorialPage(state, const SignsScreen()),
      ),
      GoRoute(
        path: '/signs/flashcards',
        pageBuilder: (context, state) =>
            _editorialPage(state, const FlashcardsScreen()),
      ),
      GoRoute(
        path: '/quiz',
        pageBuilder: (context, state) {
          final category = state.extra as String?;
          return _editorialPage(state, PracticeQuizScreen(category: category));
        },
      ),
      GoRoute(
        path: '/mock_exam_intro',
        pageBuilder: (context, state) =>
            _editorialPage(state, const MockExamIntroScreen()),
      ),
      GoRoute(
        path: '/mock_exam',
        pageBuilder: (context, state) =>
            _editorialPage(state, const MockExamScreen()),
      ),
      GoRoute(
        path: '/mock_exam_review',
        pageBuilder: (context, state) =>
            _editorialPage(state, const MockExamReviewScreen()),
      ),
      GoRoute(
        path: '/mock_exam_results',
        pageBuilder: (context, state) =>
            _editorialPage(state, const MockExamResultScreen()),
      ),
      GoRoute(
        path: '/mock_exam_answers',
        pageBuilder: (context, state) =>
            _editorialPage(state, const MockExamAnswersScreen()),
      ),
    ],
  );
});

CustomTransitionPage<void> _editorialPage(GoRouterState state, Widget child) =>
    CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionDuration: AppMotion.standard,
      reverseTransitionDuration: AppMotion.standard,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final reducedMotion = ProviderScope.containerOf(context).read(reducedMotionProvider);

        final curved = CurvedAnimation(
          parent: animation,
          curve: AppMotion.standardEasing,
        );

        if (reducedMotion) {
          return FadeTransition(opacity: curved, child: child);
        }

        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, .025),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        );
      },
    );
