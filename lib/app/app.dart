/// MaterialApp configuration with theming and navigation.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/app_theme.dart';
import '../navigation/app_shell.dart';

/// Global theme mode state.
final themeModeProvider = StateProvider<ThemeMode>((_) => ThemeMode.system);

/// Root application widget.
class DriveWiseApp extends ConsumerWidget {
  const DriveWiseApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'DriveWise',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      home: const AppShell(),
    );
  }
}
