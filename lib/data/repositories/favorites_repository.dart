import '../../models/album.dart';
import '../../models/favorite.dart';
import '../sources/favorites_local_source.dart';

/// Abstracts local favorite storage for the business logic layer.
class FavoritesRepository {
  final FavoritesLocalSource _localSource;

  FavoritesRepository(this._localSource);

  Future<List<Favorite>> getAllFavorites() {
    return _localSource.getAll();
  }

  Future<bool> isFavorite(String albumId) async {
    final fav = await _localSource.getById(albumId);
    return fav != null;
  }

  Future<void> addFavorite(Album album) {
    return _localSource.insert(Favorite.fromAlbum(album));
  }

  Future<void> removeFavorite(String albumId) {
    return _localSource.delete(albumId);
  }
}
