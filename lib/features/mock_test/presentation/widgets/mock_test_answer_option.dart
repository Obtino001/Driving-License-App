library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_spacing.dart';

/// A single answer option for the Mock Test.
/// 
/// Unlike the practice answer option, this DOES NOT reveal right/wrong
/// status. It only shows whether it is currently selected.
class MockTestAnswerOption extends StatelessWidget {
  const MockTestAnswerOption({
    super.key,
    required this.index,
    required this.text,
    required this.isSelected,
    this.onTap,
  });

  final int index;
  final String text;
  final bool isSelected;
  final VoidCallback? onTap;

  static const _letters = ['A', 'B', 'C', 'D'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Visual state
    Color borderColor;
    Color backgroundColor;
    Color textColor;
    Color letterBgColor;
    Color letterColor;

    if (isSelected) {
      borderColor = theme.colorScheme.primary;
      backgroundColor = theme.colorScheme.primaryContainer.withValues(alpha: 0.3);
      textColor = theme.colorScheme.primary;
      letterBgColor = theme.colorScheme.primary;
      letterColor = theme.colorScheme.onPrimary;
    } else {
      borderColor = theme.colorScheme.outlineVariant;
      backgroundColor = theme.colorScheme.surface;
      textColor = theme.colorScheme.onSurface;
      letterBgColor = theme.colorScheme.surfaceContainerHighest;
      letterColor = theme.colorScheme.onSurfaceVariant;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppRadius.borderRadiusLg,
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (!isSelected) {
              HapticFeedback.selectionClick();
            }
            onTap?.call();
          },
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
                  duration: const Duration(milliseconds: 200),
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: letterBgColor,
                    borderRadius: AppRadius.borderRadiusSm,
                  ),
                  child: Center(
                    child: Text(
                      _letters[index],
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
                    text,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: textColor,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),

                // Selection checkmark
                if (isSelected) ...[
                  const SizedBox(width: AppSpacing.sm),
                  Icon(
                    Icons.radio_button_checked_rounded,
                    color: theme.colorScheme.primary,
                    size: 22,
                  ),
                ] else ...[
                  const SizedBox(width: AppSpacing.sm),
                  Icon(
                    Icons.radio_button_unchecked_rounded,
                    color: theme.colorScheme.outlineVariant,
                    size: 22,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
