import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/haptics.dart';
import '../application/home_controller.dart';
import 'widgets/home_sections.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsync = ref.watch(homeProvider);
    Future<void> openAndRefresh(String route, {Object? extra}) async {
      if (route == '/learn' || route == '/practice' || route == '/progress') {
        context.go(route, extra: extra);
      } else {
        await context.push(route, extra: extra);
      }
      if (context.mounted) {
        await ref.read(homeProvider.notifier).loadHomeData();
      }
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => ref.read(homeProvider.notifier).loadHomeData(),
          color: AppColors.primaryDark,
          child: stateAsync.when(
            data: (state) => ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
              children: [
                HomeHeader(streak: state.streak),
                const SizedBox(height: 26),
                ReadinessJourneyHero(
                  readiness: state.readiness,
                  exploredTopics: state.exploredTopics,
                  totalTopics: state.totalTopics,
                  onContinue: () {
                    AppHaptics.buttonPress();
                    openAndRefresh('/learn');
                  },
                ),
                const SizedBox(height: 26),
                TodayRecommendationCard(
                  title: state.nextTopic,
                  onTap: () {
                    AppHaptics.selection();
                    openAndRefresh('/practice', extra: state.nextTopic);
                  },
                ),
                const SizedBox(height: 26),
                Text(
                  'Make a move',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 14),
                QuickActions(
                  mistakesCount: state.mistakesCount,
                  onOpen: openAndRefresh,
                ),
                const SizedBox(height: 26),
                DailyGoalCard(progress: state.dailyGoalProgress),
                const SizedBox(height: 26),
                JourneyPreview(
                  currentTopic: state.currentTopic,
                  currentProgress: state.currentTopicProgress,
                  nextTopic: state.nextTopic,
                  onTap: () {
                    AppHaptics.selection();
                    openAndRefresh('/learn');
                  },
                ),
              ],
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                const SizedBox(height: 160),
                Center(child: Text('Could not load your progress: $error')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, required this.streak});
  final int streak;

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good morning'
        : hour < 18
        ? 'Good afternoon'
        : 'Good evening';
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'CALIFORNIA  /  CLASS C',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.textSecondary,
                  letterSpacing: 1.4,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                greeting,
                maxLines: 2,
                style: Theme.of(context).textTheme.displaySmall
                    ?.copyWith(fontSize: 29, letterSpacing: -1.1, height: 1.08),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        if (streak > 0)
          Semantics(
            label: '$streak day streak',
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
              decoration: BoxDecoration(
                color: const Color(0xFFFFE9C2),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    PhosphorIcons.fire(PhosphorIconsStyle.fill),
                    size: 16,
                    color: const Color(0xFF9D5B00),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$streak',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () {
            AppHaptics.buttonPress();
            context.push('/settings');
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.textTertiary.withOpacity(0.1)),
            ),
            child: Icon(
              PhosphorIcons.user(PhosphorIconsStyle.fill),
              color: AppColors.textPrimary,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}
