library;

/// Pure logic for calculating streak updates.
class StreakCalculator {
  /// Calculates the new streak state based on the current date and last active date.
  /// 
  /// Returns a Map containing:
  /// - 'newStreak': The new current streak count
  /// - 'bestStreak': The new best streak count
  /// - 'recoveryAvailable': Whether a streak freeze is still available
  /// - 'isNewDay': True if this is the first activity of a new day
  static Map<String, dynamic> calculateNewStreak({
    required DateTime today,
    required DateTime? lastActive,
    required int currentStreak,
    required int bestStreak,
    required bool recoveryAvailable,
  }) {
    // Strip time components to compare days only
    final todayDate = DateTime(today.year, today.month, today.day);
    final lastActiveDate = lastActive != null 
        ? DateTime(lastActive.year, lastActive.month, lastActive.day)
        : null;

    if (lastActiveDate == null || lastActiveDate.isBefore(todayDate)) {
      if (lastActiveDate != null) {
        final difference = todayDate.difference(lastActiveDate).inDays;
        
        if (difference == 1) {
          // Consecutive day
          final newStreak = currentStreak + 1;
          return {
            'newStreak': newStreak,
            'bestStreak': newStreak > bestStreak ? newStreak : bestStreak,
            'recoveryAvailable': newStreak >= 3 && !recoveryAvailable ? true : recoveryAvailable,
            'isNewDay': true,
          };
        } else if (difference > 1) {
          // Missed at least one day
          if (recoveryAvailable && currentStreak > 0) {
            // Consume streak freeze
            final newStreak = currentStreak + 1;
            return {
              'newStreak': newStreak,
              'bestStreak': newStreak > bestStreak ? newStreak : bestStreak,
              'recoveryAvailable': false,
              'isNewDay': true,
            };
          } else {
            // Lost streak
            final newStreak = 1;
            return {
              'newStreak': newStreak,
              'bestStreak': newStreak > bestStreak ? newStreak : bestStreak,
              'recoveryAvailable': recoveryAvailable,
              'isNewDay': true,
            };
          }
        }
      } else {
        // First day ever
        return {
          'newStreak': 1,
          'bestStreak': 1 > bestStreak ? 1 : bestStreak,
          'recoveryAvailable': recoveryAvailable,
          'isNewDay': true,
        };
      }
    }
    
    // Same day activity
    return {
      'newStreak': currentStreak,
      'bestStreak': bestStreak,
      'recoveryAvailable': recoveryAvailable,
      'isNewDay': false,
    };
  }
}
