import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../motion/app_motion.dart';

import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/practice/presentation/practice_quiz_screen.dart';
import '../../features/mistakes/presentation/mistakes_screen.dart';
import '../../features/learn/presentation/learn_screen.dart';
import '../../features/signs/presentation/signs_screen.dart';
import '../../features/signs/presentation/flashcards_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/onboarding',
  routes: [
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/learn',
      pageBuilder: (context, state) =>
          _editorialPage(state, const LearnScreen()),
    ),
    GoRoute(
      path: '/mistakes',
      builder: (context, state) => const MistakesScreen(),
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
      path: '/practice',
      pageBuilder: (context, state) {
        final category = state.extra as String?;
        return CustomTransitionPage(
          key: state.pageKey,
          transitionDuration: AppMotion.standard,
          reverseTransitionDuration: AppMotion.standard,
          child: PracticeQuizScreen(category: category),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curved = CurvedAnimation(
              parent: animation,
              curve: AppMotion.standardEasing,
            );
            return FadeTransition(
              opacity: curved,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, .035),
                  end: Offset.zero,
                ).animate(curved),
                child: child,
              ),
            );
          },
        );
      },
    ),
  ],
);

CustomTransitionPage<void> _editorialPage(GoRouterState state, Widget child) =>
    CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionDuration: AppMotion.standard,
      reverseTransitionDuration: AppMotion.standard,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: AppMotion.standardEasing,
        );
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
