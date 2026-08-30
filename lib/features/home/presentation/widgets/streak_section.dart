/// Weekly streak calendar section.
library;

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

/// Displays a 7-day streak calendar with motivational text.
class StreakSection extends StatelessWidget {
  const StreakSection({
    super.key,
    required this.activeDays,
    required this.currentStreak,
  });

  /// Set of weekday indices (1=Mon, 7=Sun) that the user practiced.
  final Set<int> activeDays;
  final int currentStreak;

  static const _dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  String get _motivationalText {
    if (currentStreak == 0) return 'Start your streak today! 💪';
    if (currentStreak < 3) return 'Great start! Keep going! 🌱';
    if (currentStreak < 7) return 'You\'re on fire! Don\'t stop! 🔥';
    if (currentStreak < 14) return 'Amazing consistency! 🌟';
    return 'Unstoppable! You\'re a legend! 🏆';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'This Week',
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: AppSpacing.ms),
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLow,
            borderRadius: AppRadius.borderRadiusLg,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(7, (index) {
                  final dayNumber = index + 1;
                  final isActive = activeDays.contains(dayNumber);
                  final isToday = DateTime.now().weekday == dayNumber;

                  return _DayDot(
                    label: _dayLabels[index],
                    isActive: isActive,
                    isToday: isToday,
                    activeColor: colors.success,
                  );
                }),
              ),
              const SizedBox(height: AppSpacing.ms),
              Text(
                _motivationalText,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DayDot extends StatelessWidget {
  const _DayDot({
    required this.label,
    required this.isActive,
    required this.isToday,
    required this.activeColor,
  });

  final String label;
  final bool isActive;
  final bool isToday;
  final Color activeColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: isToday
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurfaceVariant,
            fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive
                ? activeColor
                : theme.colorScheme.surfaceContainerHighest,
            border: isToday && !isActive
                ? Border.all(
                    color: theme.colorScheme.primary,
                    width: 2,
                  )
                : null,
          ),
          child: isActive
              ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
              : null,
        ),
      ],
    );
  }
}
