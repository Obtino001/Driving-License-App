/// Base card component with consistent styling.
library;

import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';

/// A styled card wrapper with consistent elevation, radius, and padding.
///
/// Supports optional gradient background for accent cards.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.gradient,
    this.color,
    this.borderColor,
    this.onTap,
    this.elevation,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Gradient? gradient;
  final Color? color;
  final Color? borderColor;
  final VoidCallback? onTap;
  final double? elevation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget content = Padding(
      padding: padding ?? AppSpacing.cardPadding,
      child: child,
    );

    if (gradient != null) {
      return Material(
        color: Colors.transparent,
        borderRadius: AppRadius.borderRadiusLg,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.borderRadiusLg,
          child: Ink(
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: AppRadius.borderRadiusLg,
            ),
            child: content,
          ),
        ),
      );
    }

    return Card(
      elevation: elevation ?? 0,
      color: color ?? theme.colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.borderRadiusLg,
        side: borderColor != null
            ? BorderSide(color: borderColor!)
            : BorderSide.none,
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.borderRadiusLg,
        child: content,
      ),
    );
  }
}
