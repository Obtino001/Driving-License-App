/// Explanation panel that slides up after answering.
library;

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

/// A panel that slides up from below to show why the answer is correct.
///
/// Includes the explanation text and a prominent "Next Question" button.
class ExplanationPanel extends StatefulWidget {
  const ExplanationPanel({
    super.key,
    required this.explanation,
    required this.isCorrect,
    required this.correctAnswer,
    required this.onNext,
    required this.isLastQuestion,
  });

  final String explanation;
  final bool isCorrect;
  final String correctAnswer;
  final VoidCallback onNext;
  final bool isLastQuestion;

  @override
  State<ExplanationPanel> createState() => _ExplanationPanelState();
}

class _ExplanationPanelState extends State<ExplanationPanel>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    _controller.forward();
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

    final accentColor = widget.isCorrect ? colors.success : theme.colorScheme.error;
    final bgColor = widget.isCorrect
        ? colors.successContainer.withValues(alpha: 0.5)
        : theme.colorScheme.errorContainer.withValues(alpha: 0.5);

    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(AppRadius.xl),
              topRight: Radius.circular(AppRadius.xl),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status header
                Row(
                  children: [
                    Icon(
                      widget.isCorrect
                          ? Icons.check_circle_rounded
                          : Icons.cancel_rounded,
                      color: accentColor,
                      size: 24,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      widget.isCorrect ? 'Correct!' : 'Not quite',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: accentColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),

                if (!widget.isCorrect) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Correct answer: ${widget.correctAnswer}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colors.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],

                const SizedBox(height: AppSpacing.ms),

                // Explanation text
                Text(
                  widget.explanation,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.85),
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                // Next button — PROMINENT, impossible to miss
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: FilledButton(
                    onPressed: widget.onNext,
                    style: FilledButton.styleFrom(
                      backgroundColor: accentColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.borderRadiusMd,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.isLastQuestion
                              ? 'See Results'
                              : 'Next Question',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Icon(
                          widget.isLastQuestion
                              ? Icons.flag_rounded
                              : Icons.arrow_forward_rounded,
                          size: 20,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
