library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider for the SharedPreferences instance.
/// This must be overridden in `main()` after `SharedPreferences.getInstance()` completes.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider must be overridden in main()');
});

/// A service to handle reading/writing typed preferences.
class PreferencesService {
  PreferencesService(this._prefs);

  final SharedPreferences _prefs;

  static const String _keyOnboardingComplete = 'onboarding_complete';
  static const String _keySound = 'sound_enabled';
  static const String _keyHaptic = 'haptic_enabled';
  static const String _keyNotifications = 'notifications_enabled';
  static const String _keyDailyGoal = 'daily_goal';
  static const String _keyLanguage = 'language';
  static const String _keyRegion = 'region';
  
  // Retention fields
  static const String _keyReminderTime = 'reminder_time';
  static const String _keyCurrentStreak = 'current_streak';
  static const String _keyBestStreak = 'best_streak';
  static const String _keyLastActiveDate = 'last_active_date';
  static const String _keyStreakRecovery = 'streak_recovery_available';
  static const String _keyDailyQuestions = 'daily_questions_answered';

  bool get isOnboardingComplete => _prefs.getBool(_keyOnboardingComplete) ?? false;
  Future<void> setOnboardingComplete() async => _prefs.setBool(_keyOnboardingComplete, true);

  bool get isSoundEnabled => _prefs.getBool(_keySound) ?? true;
  Future<void> setSoundEnabled(bool value) async => _prefs.setBool(_keySound, value);

  bool get isHapticEnabled => _prefs.getBool(_keyHaptic) ?? true;
  Future<void> setHapticEnabled(bool value) async => _prefs.setBool(_keyHaptic, value);

  bool get isNotificationsEnabled => _prefs.getBool(_keyNotifications) ?? true;
  Future<void> setNotificationsEnabled(bool value) async => _prefs.setBool(_keyNotifications, value);

  int get dailyGoal => _prefs.getInt(_keyDailyGoal) ?? 10;
  Future<void> setDailyGoal(int value) async => _prefs.setInt(_keyDailyGoal, value);

  String get language => _prefs.getString(_keyLanguage) ?? 'English';
  Future<void> setLanguage(String value) async => _prefs.setString(_keyLanguage, value);

  String get region => _prefs.getString(_keyRegion) ?? 'United States';
  Future<void> setRegion(String value) async => _prefs.setString(_keyRegion, value);

  String get reminderTime => _prefs.getString(_keyReminderTime) ?? '09:00';
  Future<void> setReminderTime(String value) async => _prefs.setString(_keyReminderTime, value);

  int get currentStreak => _prefs.getInt(_keyCurrentStreak) ?? 0;
  Future<void> setCurrentStreak(int value) async => _prefs.setInt(_keyCurrentStreak, value);

  int get bestStreak => _prefs.getInt(_keyBestStreak) ?? 0;
  Future<void> setBestStreak(int value) async => _prefs.setInt(_keyBestStreak, value);

  String get lastActiveDate => _prefs.getString(_keyLastActiveDate) ?? '';
  Future<void> setLastActiveDate(String value) async => _prefs.setString(_keyLastActiveDate, value);

  bool get streakRecoveryAvailable => _prefs.getBool(_keyStreakRecovery) ?? false;
  Future<void> setStreakRecoveryAvailable(bool value) async => _prefs.setBool(_keyStreakRecovery, value);

  int get dailyQuestionsAnswered => _prefs.getInt(_keyDailyQuestions) ?? 0;
  Future<void> setDailyQuestionsAnswered(int value) async => _prefs.setInt(_keyDailyQuestions, value);

  Future<void> clearAll() async {
    await _prefs.clear();
  }
}

/// Provider for the PreferencesService.
final preferencesServiceProvider = Provider<PreferencesService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return PreferencesService(prefs);
});
