/// Primary CTA button with consistent height, radius, and loading state.
library;

import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';

/// A filled button following the app's design system.
///
/// Provides a consistent 56dp height, large radius, and optional
/// loading state with a circular progress indicator.
class AppFilledButton extends StatelessWidget {
  const AppFilledButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isExpanded = true,
  });

  /// The button label text.
  final String label;

  /// Called when the button is tapped. Pass null to disable.
  final VoidCallback? onPressed;

  /// Optional leading icon.
  final IconData? icon;

  /// When true, shows a loading spinner instead of the label.
  final bool isLoading;

  /// When true (default), the button stretches to fill available width.
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: Colors.white,
            ),
          )
        : icon != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 20),
                  const SizedBox(width: AppSpacing.sm),
                  Text(label),
                ],
              )
            : Text(label);

    final button = FilledButton(
      onPressed: isLoading ? null : onPressed,
      child: child,
    );

    if (!isExpanded) {
      return button;
    }

    return SizedBox(
      width: double.infinity,
      child: button,
    );
  }
}
