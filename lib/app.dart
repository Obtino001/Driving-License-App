import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'core/routing/app_router.dart';
import 'core/preferences/preferences_provider.dart';
import 'core/utils/haptics.dart';

class DmvPracticeApp extends ConsumerWidget {
  const DmvPracticeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<bool>(
      hapticsProvider,
      (previous, next) => AppHaptics.enabled = next,
    );

    return MaterialApp.router(
      title: 'DMV Practice',
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
