/// Answer option button with animated correct/incorrect states.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../data/models/question.dart';

/// A single answer option with visual state for unanswered, correct, incorrect.
///
/// Minimum 56dp height, full-width, large text for readability.
class AnswerOption extends StatefulWidget {
  const AnswerOption({
    super.key,
    required this.index,
    required this.text,
    required this.status,
    required this.isSelected,
    required this.isCorrectAnswer,
    required this.isRevealed,
    this.onTap,
  });

  /// Option index (0-3), used for the letter prefix.
  final int index;

  /// Answer text.
  final String text;

  /// Current status of the parent question.
  final QuestionStatus status;

  /// Whether THIS option was selected by the user.
  final bool isSelected;

  /// Whether THIS option is the correct answer.
  final bool isCorrectAnswer;

  /// Whether answers have been revealed.
  final bool isRevealed;

  /// Called when tapped (null if already answered).
  final VoidCallback? onTap;

  @override
  State<AnswerOption> createState() => _AnswerOptionState();
}

class _AnswerOptionState extends State<AnswerOption>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shakeController;
  late final Animation<double> _shakeAnimation;

  static const _letters = ['A', 'B', 'C', 'D'];

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: 6), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 6, end: -6), weight: 20),
      TweenSequenceItem(tween: Tween(begin: -6, end: 4), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 4, end: -4), weight: 20),
      TweenSequenceItem(tween: Tween(begin: -4, end: 0), weight: 20),
    ]).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(AnswerOption oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Trigger shake on incorrect selection
    if (widget.isSelected &&
        widget.isRevealed &&
        !widget.isCorrectAnswer &&
        !oldWidget.isRevealed) {
      _shakeController.forward(from: 0);
      HapticFeedback.mediumImpact();
    }
    // Light haptic on correct
    if (widget.isSelected &&
        widget.isRevealed &&
        widget.isCorrectAnswer &&
        !oldWidget.isRevealed) {
      HapticFeedback.lightImpact();
    }
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;

    // Determine visual state
    Color borderColor;
    Color backgroundColor;
    Color textColor;
    Color letterBgColor;
    Color letterColor;
    IconData? trailingIcon;
    Color? trailingIconColor;

    if (!widget.isRevealed) {
      // Unanswered state
      borderColor = theme.colorScheme.outlineVariant;
      backgroundColor = theme.colorScheme.surface;
      textColor = theme.colorScheme.onSurface;
      letterBgColor = theme.colorScheme.surfaceContainerHighest;
      letterColor = theme.colorScheme.onSurfaceVariant;
    } else if (widget.isCorrectAnswer) {
      // This is the correct answer (always highlight green)
      borderColor = colors.success;
      backgroundColor = colors.successContainer.withValues(alpha: 0.4);
      textColor = colors.onSuccessContainer;
      letterBgColor = colors.success;
      letterColor = colors.onSuccess;
      trailingIcon = Icons.check_circle_rounded;
      trailingIconColor = colors.success;
    } else if (widget.isSelected && !widget.isCorrectAnswer) {
      // User selected this, but it's wrong
      borderColor = theme.colorScheme.error;
      backgroundColor = theme.colorScheme.errorContainer.withValues(alpha: 0.4);
      textColor = theme.colorScheme.onErrorContainer;
      letterBgColor = theme.colorScheme.error;
      letterColor = theme.colorScheme.onError;
      trailingIcon = Icons.cancel_rounded;
      trailingIconColor = theme.colorScheme.error;
    } else {
      // Other options after reveal (dimmed)
      borderColor = theme.colorScheme.outlineVariant.withValues(alpha: 0.5);
      backgroundColor = theme.colorScheme.surface;
      textColor = theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5);
      letterBgColor =
          theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5);
      letterColor = theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5);
    }

    Widget card = AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppRadius.borderRadiusLg,
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: AppRadius.borderRadiusLg,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            child: Row(
              children: [
                // Letter badge
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: letterBgColor,
                    borderRadius: AppRadius.borderRadiusSm,
                  ),
                  child: Center(
                    child: Text(
                      _letters[widget.index],
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: letterColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.ms),

                // Answer text
                Expanded(
                  child: Text(
                    widget.text,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: textColor,
                      fontWeight: widget.isSelected && widget.isRevealed
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ),

                // Trailing icon
                if (trailingIcon != null) ...[
                  const SizedBox(width: AppSpacing.sm),
                  Icon(trailingIcon, color: trailingIconColor, size: 22),
                ],
              ],
            ),
          ),
        ),
      ),
    );

    // Wrap in shake animation for wrong answer
    if (widget.isSelected && !widget.isCorrectAnswer && widget.isRevealed) {
      card = AnimatedBuilder(
        animation: _shakeAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(_shakeAnimation.value, 0),
            child: child,
          );
        },
        child: card,
      );
    }

    return card;
  }
}
