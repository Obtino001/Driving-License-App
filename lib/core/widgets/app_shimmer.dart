/// Shimmer loading placeholder.
library;

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/app_spacing.dart';

/// A shimmer skeleton loading widget for cards and content.
class AppShimmer extends StatelessWidget {
  const AppShimmer({
    super.key,
    this.width,
    this.height = 20,
    this.borderRadius,
  });

  /// Creates a card-shaped shimmer placeholder.
  const AppShimmer.card({
    super.key,
    this.height = 120,
  })  : width = double.infinity,
        borderRadius = AppRadius.lg;

  /// Creates a circular shimmer placeholder.
  const AppShimmer.circle({
    super.key,
    double size = 48,
  })  : width = size,
        height = size,
        borderRadius = 100;

  /// Creates a text-line shimmer placeholder.
  const AppShimmer.text({
    super.key,
    this.width = 120,
  })  : height = 14,
        borderRadius = AppRadius.sm;

  final double? width;
  final double height;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDark
          ? theme.colorScheme.surfaceContainerHighest
          : theme.colorScheme.surfaceContainerHigh,
      highlightColor: isDark
          ? theme.colorScheme.surfaceContainer
          : theme.colorScheme.surface,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius != null
              ? BorderRadius.circular(borderRadius!)
              : null,
        ),
      ),
    );
  }
}

/// A collection of shimmer placeholders mimicking the Home screen layout.
class HomeShimmerLoading extends StatelessWidget {
  const HomeShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.lg),
          const AppShimmer.text(width: 200),
          const SizedBox(height: AppSpacing.sm),
          const AppShimmer.text(width: 140),
          const SizedBox(height: AppSpacing.xl),
          const AppShimmer.card(height: 140),
          const SizedBox(height: AppSpacing.md),
          const AppShimmer.card(height: 100),
          const SizedBox(height: AppSpacing.md),
          const AppShimmer.card(height: 100),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(child: AppShimmer.card(height: 90)),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: AppShimmer.card(height: 90)),
            ],
          ),
        ],
      ),
    );
  }
}
