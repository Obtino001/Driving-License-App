/// Mock Test CTA card.
library;

import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';

/// A bold call-to-action card for starting a mock test.
class MockTestCtaCard extends StatelessWidget {
  const MockTestCtaCard({
    super.key,
    required this.totalQuestions,
    required this.timeMinutes,
    required this.bestScore,
    this.onTap,
  });

  final int totalQuestions;
  final int timeMinutes;

  /// Best score as percentage (0-100). Null if never taken.
  final int? bestScore;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      onTap: onTap,
      color: theme.colorScheme.secondaryContainer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.ms),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary.withValues(alpha: 0.15),
                  borderRadius: AppRadius.borderRadiusMd,
                ),
                child: Icon(
                  Icons.assignment_turned_in_rounded,
                  color: theme.colorScheme.secondary,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppSpacing.ms),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mock Test',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.onSecondaryContainer,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$totalQuestions questions • $timeMinutes min',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSecondaryContainer
                            .withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              if (bestScore != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.ms,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondary.withValues(alpha: 0.12),
                    borderRadius: AppRadius.borderRadiusFull,
                  ),
                  child: Text(
                    'Best: $bestScore%',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.secondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: FilledButton.tonal(
              onPressed: onTap,
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                backgroundColor:
                    theme.colorScheme.secondary.withValues(alpha: 0.15),
                foregroundColor: theme.colorScheme.secondary,
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.borderRadiusMd,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.play_arrow_rounded, size: 20),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'Start Full Mock Test',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
