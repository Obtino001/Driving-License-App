/// Today's Challenge card with timer badge and start button.
library;

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

/// A visually distinct card prompting the daily 10-question challenge.
///
/// Uses a gradient background when active, and a success state when completed.
/// Features entrance animation with delay for staggered effect.
class ChallengeCard extends StatefulWidget {
  const ChallengeCard({
    super.key,
    required this.questionCount,
    required this.estimatedMinutes,
    required this.isCompleted,
    this.animationDelay = Duration.zero,
    this.onStart,
  });

  final int questionCount;
  final int estimatedMinutes;
  final bool isCompleted;
  final Duration animationDelay;
  final VoidCallback? onStart;

  @override
  State<ChallengeCard> createState() => _ChallengeCardState();
}

class _ChallengeCardState extends State<ChallengeCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

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
    final colors = context.appColors;

    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: widget.isCompleted
            ? _buildCompleted(theme, colors)
            : _buildActive(theme, colors),
      ),
    );
  }

  Widget _buildActive(ThemeData theme, AppColorsExtension colors) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: theme.colorScheme.tertiaryContainer,
        borderRadius: AppRadius.borderRadiusXl,
      ),
      child: Row(
        children: [
          // Left: icon + info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onTertiaryContainer.withValues(alpha: 0.1),
                        borderRadius: AppRadius.borderRadiusSm,
                      ),
                      child: Icon(
                        Icons.bolt_rounded,
                        size: 18,
                        color: theme.colorScheme.onTertiaryContainer,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      'Today\'s Challenge',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onTertiaryContainer,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  '${widget.questionCount} questions · ~${widget.estimatedMinutes} min',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onTertiaryContainer.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),

          // Right: start button
          _PressableButton(
            onPressed: widget.onStart,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.ml,
                vertical: AppSpacing.ms,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.onTertiaryContainer,
                borderRadius: AppRadius.borderRadiusFull,
              ),
              child: Text(
                'Start',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.tertiaryContainer,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompleted(ThemeData theme, AppColorsExtension colors) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.successContainer,
        borderRadius: AppRadius.borderRadiusXl,
        border: Border.all(
          color: colors.success.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: colors.success.withValues(alpha: 0.15),
              borderRadius: AppRadius.borderRadiusSm,
            ),
            child: Icon(
              Icons.check_circle_rounded,
              size: 18,
              color: colors.success,
            ),
          ),
          const SizedBox(width: AppSpacing.ms),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Challenge Complete!',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colors.onSuccessContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Come back tomorrow for a new one',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.onSuccessContainer.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          Text('✅', style: TextStyle(fontSize: 24)),
        ],
      ),
    );
  }
}

/// A simple wrapper that adds a scale-down animation on press.
class _PressableButton extends StatefulWidget {
  const _PressableButton({
    required this.child,
    this.onPressed,
  });

  final Widget child;
  final VoidCallback? onPressed;

  @override
  State<_PressableButton> createState() => _PressableButtonState();
}

class _PressableButtonState extends State<_PressableButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.93).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onPressed?.call();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: widget.child,
      ),
    );
  }
}
