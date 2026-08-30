/// Animated streak badge with flame icon and day count.
library;

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Displays the user's current streak with a flame icon.
///
/// Animated with a subtle scale pulse on first render.
class StreakBadge extends StatefulWidget {
  const StreakBadge({
    super.key,
    required this.days,
    this.compact = false,
  });

  /// Number of streak days.
  final int days;

  /// When true, uses a smaller, more compact layout.
  final bool compact;

  @override
  State<StreakBadge> createState() => _StreakBadgeState();
}

class _StreakBadgeState extends State<StreakBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.2), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Play the pulse animation once on build
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    if (widget.compact) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ScaleTransition(
            scale: _scaleAnimation,
            child: Text('🔥', style: TextStyle(fontSize: 16)),
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            '${widget.days}',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: colors.streak,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.ms,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: colors.streakContainer,
        borderRadius: AppRadius.borderRadiusFull,
        border: Border.all(
          color: colors.streak.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ScaleTransition(
            scale: _scaleAnimation,
            child: const Text('🔥', style: TextStyle(fontSize: 18)),
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            '${widget.days} day streak',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: colors.streak,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}
