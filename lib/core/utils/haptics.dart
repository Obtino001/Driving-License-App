import 'package:flutter/services.dart';

class AppHaptics {
  /// Subtle selection feedback (e.g., picking a quiz option, tabbing)
  static Future<void> selection() async {
    await HapticFeedback.selectionClick();
  }

  /// Positive feedback for correct answers or completed actions
  static Future<void> success() async {
    await HapticFeedback.lightImpact();
  }

  /// Feedback for incorrect answers or errors
  static Future<void> error() async {
    await HapticFeedback.heavyImpact();
  }

  /// For main CTA buttons
  static Future<void> buttonPress() async {
    await HapticFeedback.mediumImpact();
  }
}
