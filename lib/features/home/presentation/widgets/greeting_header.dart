/// Greeting header with time-based message and streak badge.
library;

import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/streak_badge.dart';

/// Displays a personalized time-based greeting with the user's streak.
class GreetingHeader extends StatelessWidget {
  const GreetingHeader({
    super.key,
    required this.userName,
    required this.streakDays,
  });

  final String userName;
  final int streakDays;

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$_greeting,',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                userName,
                style: theme.textTheme.displaySmall?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        StreakBadge(days: streakDays),
      ],
    );
  }
}
