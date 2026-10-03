import 'package:flutter/services.dart';

class AppHaptics {
  static bool enabled = true;

  /// Subtle selection feedback (e.g., picking a quiz option, tabbing)
  static Future<void> selection() async {
    if (!enabled) return;
    await HapticFeedback.selectionClick();
  }

  /// Positive feedback for correct answers or completed actions
  static Future<void> success() async {
    if (!enabled) return;
    await HapticFeedback.lightImpact();
  }

  /// Feedback for incorrect answers or errors
  static Future<void> error() async {
    if (!enabled) return;
    await HapticFeedback.heavyImpact();
  }

  /// For main CTA buttons
  static Future<void> buttonPress() async {
    if (!enabled) return;
    await HapticFeedback.mediumImpact();
  }
}
