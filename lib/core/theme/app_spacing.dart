/// Spacing and border radius constants for the DriveWise design system.
///
/// Based on an 8dp grid for consistent visual rhythm.
library;

import 'package:flutter/material.dart';

/// Spacing constants used throughout the app.
abstract final class AppSpacing {
  /// 4dp — tight gaps, icon padding
  static const double xs = 4;

  /// 8dp — inner card padding, small gaps
  static const double sm = 8;

  /// 12dp — medium-small gaps
  static const double ms = 12;

  /// 16dp — standard gaps, list item padding
  static const double md = 16;

  /// 20dp — medium-large gaps
  static const double ml = 20;

  /// 24dp — section gaps, card padding
  static const double lg = 24;

  /// 32dp — screen padding, large section spacing
  static const double xl = 32;

  /// 48dp — hero section spacing
  static const double xxl = 48;

  /// 64dp — extra large spacing
  static const double xxxl = 64;

  /// Standard horizontal screen padding
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(
    horizontal: lg,
  );

  /// Standard card padding
  static const EdgeInsets cardPadding = EdgeInsets.all(lg);

  /// Compact card padding
  static const EdgeInsets cardPaddingCompact = EdgeInsets.all(md);
}

/// Border radius constants.
abstract final class AppRadius {
  /// 8dp — subtle rounding
  static const double sm = 8;

  /// 12dp — standard card rounding
  static const double md = 12;

  /// 16dp — prominent rounding
  static const double lg = 16;

  /// 24dp — large element rounding
  static const double xl = 24;

  /// 100dp — pill shape
  static const double full = 100;

  static final BorderRadius borderRadiusSm = BorderRadius.circular(sm);
  static final BorderRadius borderRadiusMd = BorderRadius.circular(md);
  static final BorderRadius borderRadiusLg = BorderRadius.circular(lg);
  static final BorderRadius borderRadiusXl = BorderRadius.circular(xl);
  static final BorderRadius borderRadiusFull = BorderRadius.circular(full);
}
