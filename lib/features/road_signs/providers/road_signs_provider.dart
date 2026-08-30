import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/road_sign.dart';
import '../data/repositories/road_signs_repository.dart';

class FavoriteRoadSignsNotifier extends StateNotifier<Set<String>> {
  FavoriteRoadSignsNotifier(this._repo) : super({}) {
    _loadFavorites();
  }

  final SqlRoadSignsRepository _repo;

  Future<void> _loadFavorites() async {
    final favorites = await _repo.getFavoriteSignIds();
    state = favorites;
  }

  Future<void> toggleFavorite(String id) async {
    // Optimistic UI update
    if (state.contains(id)) {
      state = {...state}..remove(id);
    } else {
      state = {...state}..add(id);
    }
    // Persist to DB
    await _repo.toggleFavorite(id);
  }

  bool isFavorite(String id) => state.contains(id);
}

final favoriteRoadSignsProvider = StateNotifierProvider<FavoriteRoadSignsNotifier, Set<String>>((ref) {
  final repo = ref.watch(sqlRoadSignsRepositoryProvider);
  return FavoriteRoadSignsNotifier(repo);
});

final allRoadSignsProvider = FutureProvider<List<RoadSign>>((ref) async {
  final repo = ref.watch(sqlRoadSignsRepositoryProvider);
  return repo.getAllSigns();
});
