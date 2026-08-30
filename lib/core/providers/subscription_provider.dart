library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/subscription_service.dart';

/// Provides the singleton instance of the subscription service.
final subscriptionServiceProvider = Provider<SubscriptionService>((ref) {
  return MockSubscriptionService();
});

/// A StateNotifier that listens to the SubscriptionService and provides
/// a simple synchronous boolean state representing if the user is Premium.
class SubscriptionNotifier extends StateNotifier<bool> {
  SubscriptionNotifier(this._service) : super(_service.isPremium);

  final SubscriptionService _service;

  Future<void> purchasePremium() async {
    final success = await _service.purchasePremium();
    if (success) {
      state = true;
    }
  }

  Future<void> restorePurchases() async {
    final success = await _service.restorePurchases();
    if (success) {
      state = true;
    }
  }
}

/// The primary provider to watch when gating premium features.
/// Use `ref.watch(isPremiumProvider)` in widgets.
final isPremiumProvider = StateNotifierProvider<SubscriptionNotifier, bool>((ref) {
  final service = ref.watch(subscriptionServiceProvider);
  return SubscriptionNotifier(service);
});
