import '../../models/album.dart';
import '../../models/track.dart';
import '../sources/itunes_remote_source.dart';

/// Abstracts iTunes API data access for the business logic layer.
class MusicRepository {
  final ItunesRemoteSource _remoteSource;

  MusicRepository(this._remoteSource);

  Future<List<Album>> getNewReleases({int limit = 20}) {
    return _remoteSource.fetchTopAlbums(limit: limit);
  }

  Future<List<Album>> searchAlbums(String query, {int limit = 20}) {
    return _remoteSource.searchAlbums(query, limit: limit);
  }

  Future<List<Track>> getAlbumTracks(String albumId) {
    return _remoteSource.fetchAlbumTracks(albumId);
  }
}
