import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_database.dart';
import 'database_repository.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final databaseRepositoryProvider = Provider<DatabaseRepository>((ref) {
  return DatabaseRepository(ref.watch(databaseProvider));
});
