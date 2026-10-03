import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/preferences/preferences_provider.dart';
import 'core/database/database_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  final container = ProviderContainer(
    overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
  );

  // Seed database with JSON content
  try {
    final dbRepo = container.read(databaseRepositoryProvider);
    await dbRepo.seedInitialData();
  } catch (e) {
    debugPrint('Database seeding error: \$e');
  }

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const DmvPracticeApp(),
    ),
  );
}
