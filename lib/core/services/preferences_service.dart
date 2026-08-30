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

  bool get isOnboardingComplete => _prefs.getBool(_keyOnboardingComplete) ?? false;

  Future<void> setOnboardingComplete() async {
    await _prefs.setBool(_keyOnboardingComplete, true);
  }
}

/// Provider for the PreferencesService.
final preferencesServiceProvider = Provider<PreferencesService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return PreferencesService(prefs);
});
