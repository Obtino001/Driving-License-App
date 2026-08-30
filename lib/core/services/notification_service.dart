library;

import 'package:flutter/material.dart';

/// Abstract service for scheduling local notifications.
abstract class NotificationService {
  Future<void> initialize();

  /// Schedules a recurring daily reminder.
  Future<void> scheduleDailyReminder(TimeOfDay time, String message);

  /// Cancels all scheduled reminders.
  Future<void> cancelReminders();
}

/// A mock implementation of NotificationService for development.
/// In production, this would use `flutter_local_notifications`.
class MockNotificationService implements NotificationService {
  @override
  Future<void> initialize() async {
    debugPrint('MockNotificationService: Initialized');
  }

  @override
  Future<void> scheduleDailyReminder(TimeOfDay time, String message) async {
    debugPrint(
      'MockNotificationService: Scheduled daily reminder at ${time.hour}:${time.minute.toString().padLeft(2, '0')} - "$message"',
    );
  }

  @override
  Future<void> cancelReminders() async {
    debugPrint('MockNotificationService: Cancelled all reminders');
  }
}
