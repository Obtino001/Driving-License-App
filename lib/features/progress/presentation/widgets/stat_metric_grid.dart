library;

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../data/models/user_stats.dart';

class StatMetricGrid extends StatelessWidget {
  const StatMetricGrid({super.key, required this.stats});

  final UserStats stats;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: AppSpacing.md,
      mainAxisSpacing: AppSpacing.md,
      childAspectRatio: 1.6,
      children: [
        _MetricCard(
          title: 'Accuracy',
          value: '${(stats.overallAccuracy * 100).toInt()}%',
          icon: Icons.gps_fixed_rounded,
          color: stats.overallAccuracy >= 0.8 ? colors.success : colors.warning,
        ),
        _MetricCard(
          title: 'Questions',
          value: '${stats.totalQuestionsAnswered}',
          icon: Icons.format_list_numbered_rounded,
          color: theme.colorScheme.primary,
        ),
        _MetricCard(
          title: 'Mock Tests',
          value: '${stats.mockTestsCompleted}',
          icon: Icons.assignment_turned_in_rounded,
          color: theme.colorScheme.secondary,
        ),
        _MetricCard(
          title: 'Best Streak',
          value: '${stats.bestStreak}',
          subtitle: 'days',
          icon: Icons.local_fire_department_rounded,
          color: const Color(0xFFFF9800), // Orange
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.value,
    this.subtitle,
    required this.icon,
    required this.color,
  });

  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: AppRadius.borderRadiusLg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: AppSpacing.xs),
              Text(
                title,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(width: 4),
                Text(
                  subtitle!,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
