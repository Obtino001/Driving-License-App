/// Daily Challenge card with gradient and timer icon.
library;

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';

/// A vibrant gradient card prompting the user to take their daily challenge.
class DailyChallengeCard extends StatelessWidget {
  const DailyChallengeCard({
    super.key,
    required this.isCompleted,
    this.onTap,
  });

  /// Whether today's challenge has been completed.
  final bool isCompleted;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;

    if (isCompleted) {
      return AppCard(
        color: colors.successContainer,
        onTap: onTap,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.ms),
              decoration: BoxDecoration(
                color: colors.success.withValues(alpha: 0.15),
                borderRadius: AppRadius.borderRadiusMd,
              ),
              child: Icon(
                Icons.check_circle_rounded,
                color: colors.success,
                size: 24,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Daily Challenge Complete!',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: colors.onSuccessContainer,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Great job! Come back tomorrow for more.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors.onSuccessContainer.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return AppCard(
      onTap: onTap,
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          theme.colorScheme.tertiary,
          theme.colorScheme.tertiary.withValues(alpha: 0.8),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.ms),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: AppRadius.borderRadiusMd,
            ),
            child: const Icon(
              Icons.bolt_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daily Challenge',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.onTertiary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '5 quick questions • 2 min',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onTertiary.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.ms,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.25),
              borderRadius: AppRadius.borderRadiusFull,
            ),
            child: Text(
              'START',
              style: theme.textTheme.labelMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
