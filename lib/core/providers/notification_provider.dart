library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/notification_service.dart';

/// Provides the singleton instance of the Notification service.
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return MockNotificationService()..initialize();
});
