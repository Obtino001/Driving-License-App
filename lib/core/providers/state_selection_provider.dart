library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/local_database.dart';
import '../models/region_state.dart';

/// Provider for the active state selection ID (e.g., 'us_ca')
final activeStateIdProvider = StateNotifierProvider<ActiveStateIdNotifier, String>((ref) {
  return ActiveStateIdNotifier();
});

class ActiveStateIdNotifier extends StateNotifier<String> {
  ActiveStateIdNotifier() : super('us_generic') {
    _loadState();
  }

  static const _key = 'active_state_id';

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    final savedState = prefs.getString(_key);
    if (savedState != null) {
      state = savedState;
    }
  }

  Future<void> setActiveState(String stateId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, stateId);
    state = stateId;
  }
}

/// Fetches the details of the currently active state from the DB
final activeStateProvider = FutureProvider<RegionState?>((ref) async {
  final stateId = ref.watch(activeStateIdProvider);
  final db = await LocalDatabase.instance.database;
  
  final result = await db.query(
    'states',
    where: 'state_id = ?',
    whereArgs: [stateId],
  );

  if (result.isNotEmpty) {
    return RegionState.fromMap(result.first);
  }
  return null;
});

/// Fetches all available states from the DB
final allStatesProvider = FutureProvider<List<RegionState>>((ref) async {
  final db = await LocalDatabase.instance.database;
  final result = await db.query('states', orderBy: 'state_name ASC');
  return result.map((m) => RegionState.fromMap(m)).toList();
});
