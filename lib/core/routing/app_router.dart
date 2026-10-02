import 'package:go_router/go_router.dart';

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
    GoRoute(path: '/learn', builder: (context, state) => const LearnScreen()),
    GoRoute(
      path: '/mistakes',
      builder: (context, state) => const MistakesScreen(),
    ),
    GoRoute(path: '/signs', builder: (context, state) => const SignsScreen()),
    GoRoute(
      path: '/signs/flashcards',
      builder: (context, state) => const FlashcardsScreen(),
    ),
    GoRoute(
      path: '/practice',
      builder: (context, state) {
        final category = state.extra as String?;
        return PracticeQuizScreen(category: category);
      },
    ),
  ],
);
