/// MaterialApp configuration with theming and navigation.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/app_theme.dart';
import '../navigation/app_shell.dart';
import '../features/onboarding/presentation/onboarding_screen.dart';
import '../features/onboarding/providers/onboarding_provider.dart';
import '../core/config/app_config.dart';

/// Global theme mode state.
final themeModeProvider = StateProvider<ThemeMode>((_) => ThemeMode.system);

/// Root application widget.
class DriveWiseApp extends ConsumerWidget {
  const DriveWiseApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final hasCompletedOnboarding = ref.watch(onboardingCompleteProvider);

    return MaterialApp(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      home: hasCompletedOnboarding ? const AppShell() : const OnboardingScreen(),
    );
  }
}
