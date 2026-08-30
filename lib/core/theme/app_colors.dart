/// Custom semantic colors via ThemeExtension.
///
/// Provides success, warning, and info colors that aren't part of the
/// standard Material 3 ColorScheme but are essential for quiz feedback.
library;

import 'package:flutter/material.dart';

/// Extension that adds custom semantic colors to the theme.
///
/// Access via `Theme.of(context).extension<AppColorsExtension>()`.
class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  const AppColorsExtension({
    required this.success,
    required this.onSuccess,
    required this.successContainer,
    required this.onSuccessContainer,
    required this.warning,
    required this.onWarning,
    required this.warningContainer,
    required this.onWarningContainer,
    required this.info,
    required this.onInfo,
    required this.streak,
    required this.streakContainer,
  });

  final Color success;
  final Color onSuccess;
  final Color successContainer;
  final Color onSuccessContainer;
  final Color warning;
  final Color onWarning;
  final Color warningContainer;
  final Color onWarningContainer;
  final Color info;
  final Color onInfo;
  final Color streak;
  final Color streakContainer;

  /// Light mode semantic colors.
  static const light = AppColorsExtension(
    success: Color(0xFF10B981),
    onSuccess: Color(0xFFFFFFFF),
    successContainer: Color(0xFFD1FAE5),
    onSuccessContainer: Color(0xFF064E3B),
    warning: Color(0xFFF59E0B),
    onWarning: Color(0xFFFFFFFF),
    warningContainer: Color(0xFFFEF3C7),
    onWarningContainer: Color(0xFF78350F),
    info: Color(0xFF3B82F6),
    onInfo: Color(0xFFFFFFFF),
    streak: Color(0xFFF97316),
    streakContainer: Color(0xFFFFF7ED),
  );

  /// Dark mode semantic colors.
  static const dark = AppColorsExtension(
    success: Color(0xFF34D399),
    onSuccess: Color(0xFF064E3B),
    successContainer: Color(0xFF065F46),
    onSuccessContainer: Color(0xFFD1FAE5),
    warning: Color(0xFFFBBF24),
    onWarning: Color(0xFF78350F),
    warningContainer: Color(0xFF92400E),
    onWarningContainer: Color(0xFFFEF3C7),
    info: Color(0xFF60A5FA),
    onInfo: Color(0xFF1E3A5F),
    streak: Color(0xFFFB923C),
    streakContainer: Color(0xFF431407),
  );

  @override
  AppColorsExtension copyWith({
    Color? success,
    Color? onSuccess,
    Color? successContainer,
    Color? onSuccessContainer,
    Color? warning,
    Color? onWarning,
    Color? warningContainer,
    Color? onWarningContainer,
    Color? info,
    Color? onInfo,
    Color? streak,
    Color? streakContainer,
  }) {
    return AppColorsExtension(
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      successContainer: successContainer ?? this.successContainer,
      onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
      warningContainer: warningContainer ?? this.warningContainer,
      onWarningContainer: onWarningContainer ?? this.onWarningContainer,
      info: info ?? this.info,
      onInfo: onInfo ?? this.onInfo,
      streak: streak ?? this.streak,
      streakContainer: streakContainer ?? this.streakContainer,
    );
  }

  @override
  AppColorsExtension lerp(covariant ThemeExtension<AppColorsExtension>? other, double t) {
    if (other is! AppColorsExtension) return this;
    return AppColorsExtension(
      success: Color.lerp(success, other.success, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
      successContainer: Color.lerp(successContainer, other.successContainer, t)!,
      onSuccessContainer: Color.lerp(onSuccessContainer, other.onSuccessContainer, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      onWarning: Color.lerp(onWarning, other.onWarning, t)!,
      warningContainer: Color.lerp(warningContainer, other.warningContainer, t)!,
      onWarningContainer: Color.lerp(onWarningContainer, other.onWarningContainer, t)!,
      info: Color.lerp(info, other.info, t)!,
      onInfo: Color.lerp(onInfo, other.onInfo, t)!,
      streak: Color.lerp(streak, other.streak, t)!,
      streakContainer: Color.lerp(streakContainer, other.streakContainer, t)!,
    );
  }
}

/// Convenience extension on BuildContext to access custom colors.
extension AppColorsX on BuildContext {
  AppColorsExtension get appColors =>
      Theme.of(this).extension<AppColorsExtension>()!;
}
