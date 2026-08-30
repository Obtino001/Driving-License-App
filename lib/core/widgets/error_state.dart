/// Error state widget with retry button.
library;

import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';
import 'app_filled_button.dart';

/// Displays an error icon, message, and retry button.
class ErrorState extends StatelessWidget {
  const ErrorState({
    super.key,
    this.title = 'Something went wrong',
    this.subtitle = 'Please try again later.',
    this.onRetry,
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: theme.colorScheme.errorContainer.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 40,
                color: theme.colorScheme.error,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              title,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                subtitle!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.lg),
              AppFilledButton(
                label: 'Try Again',
                onPressed: onRetry,
                icon: Icons.refresh_rounded,
                isExpanded: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
