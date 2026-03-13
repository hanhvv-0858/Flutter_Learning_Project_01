import 'package:flutter/material.dart';

import '../data/repositories/music_repository.dart';
import '../models/album.dart';

/// Manages Home screen state: loading, data (albums), error.
class HomeProvider extends ChangeNotifier {
  final MusicRepository _musicRepository;

  List<Album> _albums = [];
  bool _isLoading = false;
  String? _errorMessage;

  HomeProvider(this._musicRepository);

  List<Album> get albums => _albums;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchNewReleases() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _albums = await _musicRepository.getNewReleases();
      _errorMessage = null;
    } catch (e, stackTrace) {
      _errorMessage = e.toString();
      debugPrint('HomeProvider.fetchNewReleases error: $e\n$stackTrace');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> retry() async {
    await fetchNewReleases();
  }
}
