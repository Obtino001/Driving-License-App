/// Quick Practice floating action button.
library;

import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';

/// A prominent "Quick Practice" button — 10 random questions.
class QuickPracticeButton extends StatelessWidget {
  const QuickPracticeButton({
    super.key,
    this.onTap,
  });

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      onTap: onTap,
      color: theme.colorScheme.primaryContainer,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.15),
              borderRadius: AppRadius.borderRadiusSm,
            ),
            child: Icon(
              Icons.shuffle_rounded,
              size: 20,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: AppSpacing.ms),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quick Practice',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                Text(
                  '10 random questions',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer
                        .withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_rounded,
            size: 20,
            color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.7),
          ),
        ],
      ),
    );
  }
}
