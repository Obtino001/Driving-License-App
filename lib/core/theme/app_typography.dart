/// Typography system using Google Fonts (Inter).
///
/// Provides a strict 5-level type scale optimized for readability
/// on mobile screens with proper weight/height combinations.
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Builds the app's TextTheme using the Inter font family.
abstract final class AppTypography {
  /// Creates the complete TextTheme.
  static TextTheme get textTheme {
    return TextTheme(
      // Display — Welcome greeting, hero numbers
      displayLarge: GoogleFonts.inter(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        height: 1.2,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        height: 1.25,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.25,
        height: 1.29,
      ),

      // Headline — Section titles
      headlineLarge: GoogleFonts.inter(
        fontSize: 26,
        fontWeight: FontWeight.w600,
        height: 1.31,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.33,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.4,
      ),

      // Title — Card titles, dialog titles
      titleLarge: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.4,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        height: 1.44,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        height: 1.5,
      ),

      // Body — Question text, descriptions
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.15,
        height: 1.5,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        height: 1.43,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        height: 1.33,
      ),

      // Label — Buttons, chips, captions
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        height: 1.43,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.33,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.45,
      ),
    );
  }
}
