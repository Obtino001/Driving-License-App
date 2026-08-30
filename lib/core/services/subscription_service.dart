library;

import 'package:flutter/foundation.dart';

/// Abstract service for handling premium subscriptions.
/// 
/// This interface can be implemented using RevenueCat, Qonversion, or 
/// native in-app purchases later.
abstract class SubscriptionService {
  /// Stream of the user's premium status.
  Stream<bool> get isPremiumStream;

  /// Gets the current premium status synchronously.
  bool get isPremium;

  /// Initiates the purchase flow for premium.
  Future<bool> purchasePremium();

  /// Restores previous purchases.
  Future<bool> restorePurchases();
}

/// A mock implementation of [SubscriptionService] for development.
class MockSubscriptionService implements SubscriptionService {
  MockSubscriptionService() {
    // For development, we start as free.
    _isPremium = false;
  }

  bool _isPremium = false;
  final _premiumController = ValueNotifier<bool>(false);

  @override
  Stream<bool> get isPremiumStream async* {
    yield _isPremium;
    // Note: In a real app, use a StreamController. For this mock,
    // we use a simple async generator that just yields the initial value.
    // A more robust mock would use a StreamController.
  }

  @override
  bool get isPremium => _isPremium;

  @override
  Future<bool> purchasePremium() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    _isPremium = true;
    _premiumController.value = true;
    return true;
  }

  @override
  Future<bool> restorePurchases() async {
    await Future.delayed(const Duration(seconds: 1));
    // Simulate finding a past purchase
    _isPremium = true;
    _premiumController.value = true;
    return true;
  }
}
