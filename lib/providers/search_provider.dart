import 'package:flutter/material.dart';

import '../data/repositories/music_repository.dart';
import '../models/album.dart';

/// Manages Search screen state: query results, loading, error, empty.
class SearchProvider extends ChangeNotifier {
  final MusicRepository _musicRepository;

  List<Album> _results = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _isEmpty = false;
  bool _hasSearched = false;

  SearchProvider(this._musicRepository);

  List<Album> get results => _results;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isEmpty => _isEmpty;
  bool get hasSearched => _hasSearched;

  Future<void> search(String query) async {
    if (query.trim().isEmpty) return;

    _isLoading = true;
    _errorMessage = null;
    _isEmpty = false;
    _hasSearched = true;
    notifyListeners();

    try {
      _results = await _musicRepository.searchAlbums(query.trim());
      _isEmpty = _results.isEmpty;
      _errorMessage = null;
    } catch (e, stackTrace) {
      _errorMessage = e.toString();
      debugPrint('SearchProvider.search error: $e\n$stackTrace');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    _results = [];
    _isLoading = false;
    _errorMessage = null;
    _isEmpty = false;
    _hasSearched = false;
    notifyListeners();
  }
}
