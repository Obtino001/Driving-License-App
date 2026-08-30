import 'package:flutter_test/flutter_test.dart';
import 'package:driving_license_app/core/utils/streak_calculator.dart';

void main() {
  group('StreakCalculator', () {
    final today = DateTime(2023, 10, 10);

    test('First day ever sets streak to 1', () {
      final result = StreakCalculator.calculateNewStreak(
        today: today,
        lastActive: null,
        currentStreak: 0,
        bestStreak: 0,
        recoveryAvailable: false,
      );
      expect(result['newStreak'], 1);
      expect(result['bestStreak'], 1);
      expect(result['isNewDay'], true);
    });

    test('Consecutive day increases streak', () {
      final lastActive = DateTime(2023, 10, 9);
      final result = StreakCalculator.calculateNewStreak(
        today: today,
        lastActive: lastActive,
        currentStreak: 1,
        bestStreak: 1,
        recoveryAvailable: false,
      );
      expect(result['newStreak'], 2);
      expect(result['bestStreak'], 2);
      expect(result['isNewDay'], true);
    });

    test('Same day does not increase streak', () {
      final lastActive = DateTime(2023, 10, 10, 8, 0); // Earlier today
      final result = StreakCalculator.calculateNewStreak(
        today: today,
        lastActive: lastActive,
        currentStreak: 2,
        bestStreak: 2,
        recoveryAvailable: false,
      );
      expect(result['newStreak'], 2);
      expect(result['isNewDay'], false);
    });

    test('Missed day resets streak', () {
      final lastActive = DateTime(2023, 10, 8); // Missed 9th
      final result = StreakCalculator.calculateNewStreak(
        today: today,
        lastActive: lastActive,
        currentStreak: 5,
        bestStreak: 5,
        recoveryAvailable: false,
      );
      expect(result['newStreak'], 1);
      expect(result['bestStreak'], 5);
      expect(result['recoveryAvailable'], false);
      expect(result['isNewDay'], true);
    });

    test('Missed day uses streak freeze if available', () {
      final lastActive = DateTime(2023, 10, 8); // Missed 9th
      final result = StreakCalculator.calculateNewStreak(
        today: today,
        lastActive: lastActive,
        currentStreak: 5,
        bestStreak: 5,
        recoveryAvailable: true,
      );
      expect(result['newStreak'], 6); // Consumed freeze, streak continues!
      expect(result['bestStreak'], 6);
      expect(result['recoveryAvailable'], false);
      expect(result['isNewDay'], true);
    });
    
    test('Earns streak freeze at 3 days', () {
      final lastActive = DateTime(2023, 10, 9); 
      final result = StreakCalculator.calculateNewStreak(
        today: today,
        lastActive: lastActive,
        currentStreak: 2, // Becoming 3
        bestStreak: 2,
        recoveryAvailable: false, // Didn't have one
      );
      expect(result['newStreak'], 3);
      expect(result['recoveryAvailable'], true); // Earned one!
      expect(result['isNewDay'], true);
    });
  });
}
