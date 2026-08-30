/// Compact weekly progress visualization.
library;

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

/// A compact 7-day activity strip showing which days the user practiced.
///
/// Uses animated dot fills with stagger for visual interest.
class WeeklyProgress extends StatefulWidget {
  const WeeklyProgress({
    super.key,
    required this.activeDays,
    required this.currentStreak,
    this.animationDelay = Duration.zero,
  });

  /// Set of weekday indices (1=Mon … 7=Sun) the user practiced.
  final Set<int> activeDays;
  final int currentStreak;
  final Duration animationDelay;

  @override
  State<WeeklyProgress> createState() => _WeeklyProgressState();
}

class _WeeklyProgressState extends State<WeeklyProgress>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    Future.delayed(widget.animationDelay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  static const _dayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  String get _summaryText {
    final count = widget.activeDays.length;
    if (count == 0) return 'Start practicing to build your streak!';
    if (count == 7) return 'Perfect week! 🎉';
    return '$count of 7 days this week';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLow,
          borderRadius: AppRadius.borderRadiusXl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              children: [
                Text(
                  'This Week',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const Spacer(),
                if (widget.currentStreak > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: colors.streakContainer,
                      borderRadius: AppRadius.borderRadiusFull,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('🔥', style: TextStyle(fontSize: 12)),
                        const SizedBox(width: 3),
                        Text(
                          '${widget.currentStreak}',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colors.streak,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),

            const SizedBox(height: AppSpacing.md),

            // Day dots
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (i) {
                final dayNum = i + 1;
                final isActive = widget.activeDays.contains(dayNum);
                final isToday = DateTime.now().weekday == dayNum;

                return _DayColumn(
                  label: _dayLabels[i],
                  isActive: isActive,
                  isToday: isToday,
                  activeColor: colors.success,
                  dotIndex: i,
                  parentAnimation: _controller,
                );
              }),
            ),

            const SizedBox(height: AppSpacing.ms),

            // Summary
            Text(
              _summaryText,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DayColumn extends StatelessWidget {
  const _DayColumn({
    required this.label,
    required this.isActive,
    required this.isToday,
    required this.activeColor,
    required this.dotIndex,
    required this.parentAnimation,
  });

  final String label;
  final bool isActive;
  final bool isToday;
  final Color activeColor;
  final int dotIndex;
  final Animation<double> parentAnimation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Stagger the dot animation by index
    final dotAnimation = CurvedAnimation(
      parent: parentAnimation,
      curve: Interval(
        (dotIndex * 0.08).clamp(0.0, 0.6),
        ((dotIndex * 0.08) + 0.4).clamp(0.0, 1.0),
        curve: Curves.easeOutBack,
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: isToday
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurfaceVariant,
            fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
            fontSize: 10,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        ScaleTransition(
          scale: isActive ? dotAnimation : const AlwaysStoppedAnimation(1.0),
          child: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive
                  ? activeColor
                  : theme.colorScheme.surfaceContainerHighest,
              border: isToday && !isActive
                  ? Border.all(color: theme.colorScheme.primary, width: 2)
                  : null,
            ),
            child: isActive
                ? const Icon(Icons.check_rounded, size: 14, color: Colors.white)
                : null,
          ),
        ),
      ],
    );
  }
}
