import '../../models/album.dart';
import '../../models/track.dart';
import '../sources/spotify_remote_source.dart';

/// Abstracts Spotify API data access for the business logic layer.
class MusicRepository {
  final SpotifyRemoteSource _remoteSource;

  MusicRepository(this._remoteSource);

  Future<List<Album>> getNewReleases({int limit = 20, int offset = 0}) {
    return _remoteSource.fetchNewReleases(limit: limit, offset: offset);
  }

  Future<List<Album>> searchAlbums(
    String query, {
    int limit = 20,
    int offset = 0,
  }) {
    return _remoteSource.searchAlbums(query, limit: limit, offset: offset);
  }

  Future<List<Track>> getAlbumTracks(String albumId, {int limit = 20}) {
    return _remoteSource.fetchAlbumTracks(albumId, limit: limit);
  }
}
