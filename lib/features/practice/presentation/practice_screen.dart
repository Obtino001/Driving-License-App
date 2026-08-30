/// Practice / Learn screen placeholder.
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/circular_progress_indicator.dart';
import 'quiz_session_screen.dart';

/// Category list for the Learn tab.
class PracticeScreen extends StatelessWidget {
  const PracticeScreen({super.key});

  static const _categories = [
    _Category('Road Signs & Signals', Icons.signpost_rounded, 0.65, 40),
    _Category('Traffic Rules', Icons.gavel_rounded, 0.30, 35),
    _Category('Right of Way', Icons.swap_horiz_rounded, 0.0, 25),
    _Category('Safety & Emergencies', Icons.health_and_safety_rounded, 0.12, 30),
    _Category('Vehicle Control', Icons.directions_car_rounded, 0.0, 20),
    _Category('Parking & Reversing', Icons.local_parking_rounded, 0.0, 15),
    _Category('Highway Driving', Icons.add_road_rounded, 0.0, 20),
    _Category('Night & Weather', Icons.nights_stay_rounded, 0.0, 18),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 0,
              ),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Learn',
                      style: theme.textTheme.displaySmall,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Choose a category to practice',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              sliver: SliverList.separated(
                itemCount: _categories.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: AppSpacing.ms),
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  return _CategoryTile(category: cat);
                },
              ),
            ),
            const SliverPadding(
              padding: EdgeInsets.only(bottom: AppSpacing.xxl),
            ),
          ],
        ),
      ),
    );
  }
}

class _Category {
  const _Category(this.name, this.icon, this.progress, this.totalQuestions);
  final String name;
  final IconData icon;
  final double progress;
  final int totalQuestions;
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.category});
  final _Category category;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;
    final isStarted = category.progress > 0;

    return AppCard(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => QuizSessionScreen(
            title: category.name,
            categoryName: category.name,
          ),
        ));
      },
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.ms),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
              borderRadius: AppRadius.borderRadiusMd,
            ),
            child: Icon(
              category.icon,
              size: 22,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.name,
                  style: theme.textTheme.titleSmall,
                ),
                const SizedBox(height: 2),
                Text(
                  isStarted
                      ? '${(category.progress * category.totalQuestions).round()}/${category.totalQuestions} completed'
                      : '${category.totalQuestions} questions',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (isStarted)
            AppCircularProgress(
              progress: category.progress,
              size: 44,
              strokeWidth: 4,
              activeColor: colors.success,
            )
          else
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: theme.colorScheme.onSurfaceVariant,
            ),
        ],
      ),
    );
  }
}
