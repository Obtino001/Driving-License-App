/// Quick Action buttons — compact row of secondary entry points.
library;

import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';

/// A single quick action tile (icon + label) with press animation.
///
/// Used in a horizontal row for Quick Practice, Mock Test, Road Signs.
class QuickAction extends StatefulWidget {
  const QuickAction({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    this.animationDelay = Duration.zero,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final Duration animationDelay;
  final VoidCallback? onTap;

  @override
  State<QuickAction> createState() => _QuickActionState();
}

class _QuickActionState extends State<QuickAction>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: AppRadius.borderRadiusLg,
            splashFactory: InkSparkle.splashFactory,
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.md,
                horizontal: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerLow,
                borderRadius: AppRadius.borderRadiusLg,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: widget.color.withValues(alpha: 0.12),
                      borderRadius: AppRadius.borderRadiusMd,
                    ),
                    child: Icon(
                      widget.icon,
                      size: 24,
                      color: widget.color,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    widget.label,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A horizontal row of [QuickAction] tiles with staggered entrance.
class QuickActionsRow extends StatelessWidget {
  const QuickActionsRow({
    super.key,
    this.onQuickPractice,
    this.onMockTest,
    this.onRoadSigns,
  });

  final VoidCallback? onQuickPractice;
  final VoidCallback? onMockTest;
  final VoidCallback? onRoadSigns;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: QuickAction(
            icon: Icons.shuffle_rounded,
            label: 'Quick Practice',
            color: theme.colorScheme.primary,
            animationDelay: const Duration(milliseconds: 300),
            onTap: onQuickPractice,
          ),
        ),
        const SizedBox(width: AppSpacing.ms),
        Expanded(
          child: QuickAction(
            icon: Icons.assignment_turned_in_rounded,
            label: 'Mock Test',
            color: theme.colorScheme.secondary,
            animationDelay: const Duration(milliseconds: 400),
            onTap: onMockTest,
          ),
        ),
        const SizedBox(width: AppSpacing.ms),
        Expanded(
          child: QuickAction(
            icon: Icons.signpost_rounded,
            label: 'Road Signs',
            color: theme.colorScheme.tertiary,
            animationDelay: const Duration(milliseconds: 500),
            onTap: onRoadSigns,
          ),
        ),
      ],
    );
  }
}
