/// Recent performance stats row.
library;

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

/// Displays a row of key performance stats: accuracy, questions done, best streak.
class RecentPerformanceCard extends StatelessWidget {
  const RecentPerformanceCard({
    super.key,
    required this.accuracy,
    required this.questionsAnswered,
    required this.bestStreak,
  });

  /// Accuracy as percentage (0-100).
  final int accuracy;
  final int questionsAnswered;
  final int bestStreak;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Performance',
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: AppSpacing.ms),
        Row(
          children: [
            Expanded(
              child: _StatTile(
                icon: Icons.gps_fixed_rounded,
                label: 'Accuracy',
                value: '$accuracy%',
                iconColor: context.appColors.success,
                bgColor: context.appColors.successContainer,
              ),
            ),
            const SizedBox(width: AppSpacing.ms),
            Expanded(
              child: _StatTile(
                icon: Icons.quiz_rounded,
                label: 'Answered',
                value: '$questionsAnswered',
                iconColor: context.appColors.info,
                bgColor: theme.colorScheme.primaryContainer,
              ),
            ),
            const SizedBox(width: AppSpacing.ms),
            Expanded(
              child: _StatTile(
                icon: Icons.local_fire_department_rounded,
                label: 'Best Streak',
                value: '$bestStreak days',
                iconColor: context.appColors.streak,
                bgColor: context.appColors.streakContainer,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
    required this.bgColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.ms),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: AppRadius.borderRadiusMd,
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: bgColor.withValues(alpha: 0.6),
              borderRadius: AppRadius.borderRadiusSm,
            ),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            value,
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
