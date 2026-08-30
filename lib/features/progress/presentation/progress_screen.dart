library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_shimmer.dart';
import '../../practice/data/mock_questions.dart';
import '../../practice/presentation/quiz_session_screen.dart';
import '../providers/progress_provider.dart';
import 'widgets/achievements_strip.dart';
import 'widgets/category_performance_list.dart';
import 'widgets/level_progress_card.dart';
import 'widgets/recommended_practice_card.dart';
import 'widgets/stat_metric_grid.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(progressProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress'),
        centerTitle: true,
      ),
      body: progressAsync.when(
        data: (state) => _ProgressDashboard(state: state),
        loading: () => const _ProgressSkeleton(),
        error: (error, stack) => Center(
          child: Text('Error loading progress: $error'),
        ),
      ),
    );
  }
}

class _ProgressDashboard extends StatelessWidget {
  const _ProgressDashboard({required this.state});

  final ProgressState state;

  @override
  Widget build(BuildContext context) {
    final weakestCat = state.weakestCategory;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ─── Level Header ───
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: LevelProgressCard(stats: state.userStats),
          ),
          const SizedBox(height: AppSpacing.xl),

          // ─── Quick Stats ───
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: StatMetricGrid(stats: state.userStats),
          ),
          const SizedBox(height: AppSpacing.xl),

          // ─── Recommended Practice ───
          if (weakestCat != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: RecommendedPracticeCard(
                weakCategory: weakestCat,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => QuizSessionScreen(
                        title: '${weakestCat.categoryName} Practice',
                        questions: getQuestionsByCategory(weakestCat.categoryName),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],

          // ─── Category Breakdown ───
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: CategoryPerformanceList(categories: state.weakCategories),
          ),
          const SizedBox(height: AppSpacing.xl),

          // ─── Achievements ───
          AchievementsStrip(achievements: state.achievements),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}

/// A loading skeleton that matches the dashboard layout.
class _ProgressSkeleton extends StatelessWidget {
  const _ProgressSkeleton();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AppShimmer(height: 160, borderRadius: AppRadius.xl),
          const SizedBox(height: AppSpacing.xl),
          Row(
            children: const [
              Expanded(child: AppShimmer(height: 80, borderRadius: AppRadius.lg)),
              SizedBox(width: AppSpacing.md),
              Expanded(child: AppShimmer(height: 80, borderRadius: AppRadius.lg)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: const [
              Expanded(child: AppShimmer(height: 80, borderRadius: AppRadius.lg)),
              SizedBox(width: AppSpacing.md),
              Expanded(child: AppShimmer(height: 80, borderRadius: AppRadius.lg)),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          const AppShimmer(height: 100, borderRadius: AppRadius.lg),
        ],
      ),
    );
  }
}
