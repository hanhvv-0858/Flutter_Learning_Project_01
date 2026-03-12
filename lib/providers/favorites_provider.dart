import 'package:flutter/material.dart';

import '../data/repositories/favorites_repository.dart';
import '../models/favorite.dart';

/// Manages Favorites screen state.
class FavoritesProvider extends ChangeNotifier {
  final FavoritesRepository _favoritesRepository;

  List<Favorite> _favorites = [];
  bool _isLoading = false;

  FavoritesProvider(this._favoritesRepository);

  List<Favorite> get favorites => _favorites;
  bool get isLoading => _isLoading;

  Future<void> loadFavorites() async {
    _isLoading = true;
    notifyListeners();

    _favorites = await _favoritesRepository.getAllFavorites();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> removeFavorite(String id) async {
    await _favoritesRepository.removeFavorite(id);
    _favorites.removeWhere((f) => f.id == id);
    notifyListeners();
  }
}
