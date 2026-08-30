library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Manages the user's favorite road signs (by ID).
/// 
/// In a real app, this would read/write from local storage (e.g., SharedPreferences or Hive).
class FavoriteRoadSignsNotifier extends StateNotifier<Set<String>> {
  FavoriteRoadSignsNotifier() : super({});

  void toggleFavorite(String id) {
    if (state.contains(id)) {
      state = {...state}..remove(id);
    } else {
      state = {...state}..add(id);
    }
  }

  bool isFavorite(String id) => state.contains(id);
}

/// Provider for favorite road signs.
final favoriteRoadSignsProvider = StateNotifierProvider<FavoriteRoadSignsNotifier, Set<String>>(
  (ref) => FavoriteRoadSignsNotifier(),
);
