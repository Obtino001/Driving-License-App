/// Complete ThemeData configuration for light and dark modes.
///
/// Uses Material 3 ColorScheme.fromSeed with a rich indigo seed,
/// custom typography, and component-level overrides for a premium feel.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

/// Seed color — rich indigo that generates a modern, trustworthy palette.
const _seedColor = Color(0xFF4F46E5);

/// Builds the app's ThemeData.
abstract final class AppTheme {
  /// Light theme.
  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.light,
    );
    return _buildTheme(colorScheme, AppColorsExtension.light);
  }

  /// Dark theme.
  static ThemeData get dark {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.dark,
    );
    return _buildTheme(colorScheme, AppColorsExtension.dark);
  }

  static ThemeData _buildTheme(
    ColorScheme colorScheme,
    AppColorsExtension customColors,
  ) {
    final isDark = colorScheme.brightness == Brightness.dark;
    final textTheme = AppTypography.textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      extensions: [customColors],

      // Scaffold
      scaffoldBackgroundColor: colorScheme.surface,

      // AppBar
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        systemOverlayStyle: isDark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
        ),
      ),

      // NavigationBar (bottom nav)
      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        elevation: 0,
        backgroundColor: isDark
            ? colorScheme.surfaceContainer
            : colorScheme.surface,
        indicatorColor: colorScheme.primaryContainer,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(
              color: colorScheme.onPrimaryContainer,
              size: 24,
            );
          }
          return IconThemeData(
            color: colorScheme.onSurfaceVariant,
            size: 24,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final base = textTheme.labelMedium!;
          if (states.contains(WidgetState.selected)) {
            return base.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            );
          }
          return base.copyWith(
            color: colorScheme.onSurfaceVariant,
          );
        }),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),

      // Cards
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.borderRadiusLg,
        ),
        color: colorScheme.surfaceContainerLow,
        margin: EdgeInsets.zero,
      ),

      // Filled Buttons
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.borderRadiusLg,
          ),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
        ),
      ),

      // Elevated Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.borderRadiusLg,
          ),
          textStyle: textTheme.labelLarge,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
        ),
      ),

      // Outlined Buttons
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.borderRadiusLg,
          ),
          textStyle: textTheme.labelLarge,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.ms,
          ),
          side: BorderSide(color: colorScheme.outline),
        ),
      ),

      // Text Buttons
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: textTheme.labelLarge,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
        ),
      ),

      // Floating Action Button
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.borderRadiusXl,
        ),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: AppRadius.borderRadiusMd,
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.ms,
        ),
      ),

      // Divider
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
        space: 0,
      ),

      // Chip
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.borderRadiusFull,
        ),
        labelStyle: textTheme.labelMedium,
      ),

      // Splash & ripple
      splashFactory: InkSparkle.splashFactory,
    );
  }
}
