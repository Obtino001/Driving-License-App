import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';

final signsProvider = FutureProvider<List<RoadSign>>((ref) async {
  final repo = ref.watch(databaseRepositoryProvider);
  return repo.getRoadSigns();
});
