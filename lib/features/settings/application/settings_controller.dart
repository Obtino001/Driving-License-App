import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_provider.dart';
import '../../../core/preferences/preferences_provider.dart';

final settingsProvider = Provider<SettingsController>((ref) {
  return SettingsController(ref);
});

class SettingsController {
  SettingsController(this.ref);
  final Ref ref;

  bool get hapticsEnabled => ref.watch(hapticsProvider);
  bool get reducedMotionEnabled => ref.watch(reducedMotionProvider);

  void toggleHaptics() {
    ref.read(hapticsProvider.notifier).toggle();
  }

  void toggleReducedMotion() {
    ref.read(reducedMotionProvider.notifier).toggle();
  }

  Future<void> resetProgress() async {
    final repo = ref.read(databaseRepositoryProvider);
    await repo.resetProgress();
  }
}
