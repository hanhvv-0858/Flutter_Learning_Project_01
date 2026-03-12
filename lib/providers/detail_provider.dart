import 'package:flutter/material.dart';

import '../data/repositories/favorites_repository.dart';
import '../data/repositories/music_repository.dart';
import '../models/album.dart';
import '../models/track.dart';

/// Manages Detail screen state: tracks, favorite toggle.
class DetailProvider extends ChangeNotifier {
  final MusicRepository _musicRepository;
  final FavoritesRepository _favoritesRepository;

  List<Track> _tracks = [];
  bool _isLoadingTracks = false;
  String? _tracksError;
  bool _isFavorite = false;

  DetailProvider(this._musicRepository, this._favoritesRepository);

  List<Track> get tracks => _tracks;
  bool get isLoadingTracks => _isLoadingTracks;
  String? get tracksError => _tracksError;
  bool get isFavorite => _isFavorite;

  Future<void> loadTracks(String albumId) async {
    _isLoadingTracks = true;
    _tracksError = null;
    notifyListeners();

    try {
      _tracks = await _musicRepository.getAlbumTracks(albumId);
      _tracksError = null;
    } catch (e) {
      _tracksError = e.toString();
    } finally {
      _isLoadingTracks = false;
      notifyListeners();
    }
  }

  Future<void> checkFavorite(String albumId) async {
    _isFavorite = await _favoritesRepository.isFavorite(albumId);
    notifyListeners();
  }

  Future<void> toggleFavorite(Album album) async {
    if (_isFavorite) {
      await _favoritesRepository.removeFavorite(album.id);
      _isFavorite = false;
    } else {
      await _favoritesRepository.addFavorite(album);
      _isFavorite = true;
    }
    notifyListeners();
  }
}
