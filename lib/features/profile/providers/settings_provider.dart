library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/preferences_service.dart';
import '../../../core/providers/notification_provider.dart';
import '../../../core/services/notification_service.dart';

class SettingsState {
  const SettingsState({
    required this.soundEnabled,
    required this.hapticEnabled,
    required this.notificationsEnabled,
    required this.dailyGoal,
    required this.language,
    required this.region,
    required this.reminderTime,
    required this.streakRecoveryAvailable,
  });

  final bool soundEnabled;
  final bool hapticEnabled;
  final bool notificationsEnabled;
  final int dailyGoal;
  final String language;
  final String region;
  final String reminderTime;
  final bool streakRecoveryAvailable;

  SettingsState copyWith({
    bool? soundEnabled,
    bool? hapticEnabled,
    bool? notificationsEnabled,
    int? dailyGoal,
    String? language,
    String? region,
    String? reminderTime,
    bool? streakRecoveryAvailable,
  }) {
    return SettingsState(
      soundEnabled: soundEnabled ?? this.soundEnabled,
      hapticEnabled: hapticEnabled ?? this.hapticEnabled,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      dailyGoal: dailyGoal ?? this.dailyGoal,
      language: language ?? this.language,
      region: region ?? this.region,
      reminderTime: reminderTime ?? this.reminderTime,
      streakRecoveryAvailable: streakRecoveryAvailable ?? this.streakRecoveryAvailable,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier(this._prefs, this._notificationService)
      : super(SettingsState(
          soundEnabled: _prefs.isSoundEnabled,
          hapticEnabled: _prefs.isHapticEnabled,
          notificationsEnabled: _prefs.isNotificationsEnabled,
          dailyGoal: _prefs.dailyGoal,
          language: _prefs.language,
          region: _prefs.region,
          reminderTime: _prefs.reminderTime,
          streakRecoveryAvailable: _prefs.streakRecoveryAvailable,
        ));

  final PreferencesService _prefs;
  final NotificationService _notificationService;

  Future<void> toggleSound(bool value) async {
    await _prefs.setSoundEnabled(value);
    state = state.copyWith(soundEnabled: value);
  }

  Future<void> toggleHaptic(bool value) async {
    await _prefs.setHapticEnabled(value);
    state = state.copyWith(hapticEnabled: value);
  }

  Future<void> toggleNotifications(bool value) async {
    await _prefs.setNotificationsEnabled(value);
    state = state.copyWith(notificationsEnabled: value);
    
    if (value) {
      _rescheduleReminder(state.reminderTime);
    } else {
      await _notificationService.cancelReminders();
    }
  }

  Future<void> setDailyGoal(int value) async {
    await _prefs.setDailyGoal(value);
    state = state.copyWith(dailyGoal: value);
  }

  Future<void> setLanguage(String value) async {
    await _prefs.setLanguage(value);
    state = state.copyWith(language: value);
  }

  Future<void> setRegion(String value) async {
    await _prefs.setRegion(value);
    state = state.copyWith(region: value);
  }

  Future<void> setReminderTime(String value) async {
    await _prefs.setReminderTime(value);
    state = state.copyWith(reminderTime: value);
    if (state.notificationsEnabled) {
      _rescheduleReminder(value);
    }
  }

  void _rescheduleReminder(String timeStr) {
    final parts = timeStr.split(':');
    if (parts.length == 2) {
      final time = TimeOfDay(
        hour: int.tryParse(parts[0]) ?? 9,
        minute: int.tryParse(parts[1]) ?? 0,
      );
      _notificationService.scheduleDailyReminder(time, 'Your daily driving practice is waiting!');
    }
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  final prefs = ref.watch(preferencesServiceProvider);
  final notificationService = ref.watch(notificationServiceProvider);
  return SettingsNotifier(prefs, notificationService);
});
