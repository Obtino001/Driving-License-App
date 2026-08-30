/// Continue Practice card — shows current progress and resume CTA.
library;

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/circular_progress_indicator.dart';

/// A prominent card showing the user's last practice session
/// with a progress ring and a resume button.
class ContinuePracticeCard extends StatelessWidget {
  const ContinuePracticeCard({
    super.key,
    required this.categoryName,
    required this.categoryIcon,
    required this.progress,
    required this.questionsLeft,
    this.onTap,
  });

  final String categoryName;
  final IconData categoryIcon;

  /// Progress from 0.0 to 1.0.
  final double progress;
  final int questionsLeft;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;

    return AppCard(
      onTap: onTap,
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          theme.colorScheme.primaryContainer,
          theme.colorScheme.primaryContainer.withValues(alpha: 0.7),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.15),
                  borderRadius: AppRadius.borderRadiusMd,
                ),
                child: Icon(
                  categoryIcon,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.ms),
              Text(
                'Continue Learning',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_rounded,
                size: 20,
                color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.7),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      categoryName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '$questionsLeft questions left',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer
                            .withValues(alpha: 0.8),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.ms),
                    // Linear progress bar
                    ClipRRect(
                      borderRadius: AppRadius.borderRadiusFull,
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor:
                            theme.colorScheme.primary.withValues(alpha: 0.15),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          colors.success,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              AppCircularProgress(
                progress: progress,
                size: 72,
                strokeWidth: 7,
                activeColor: colors.success,
                backgroundColor:
                    theme.colorScheme.primary.withValues(alpha: 0.15),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
