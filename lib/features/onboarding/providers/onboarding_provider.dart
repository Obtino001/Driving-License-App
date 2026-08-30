library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/preferences_service.dart';

/// Provider managing whether the user has completed onboarding.
final onboardingCompleteProvider = StateNotifierProvider<OnboardingCompleteNotifier, bool>((ref) {
  final prefsService = ref.watch(preferencesServiceProvider);
  return OnboardingCompleteNotifier(prefsService);
});

class OnboardingCompleteNotifier extends StateNotifier<bool> {
  OnboardingCompleteNotifier(this._prefsService) 
      : super(_prefsService.isOnboardingComplete);

  final PreferencesService _prefsService;

  Future<void> completeOnboarding() async {
    await _prefsService.setOnboardingComplete();
    state = true;
  }
}
