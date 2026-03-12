import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../config/app_config.dart';
import '../../models/album.dart';
import '../../models/track.dart';
import '../../utils/api_exception.dart';

/// Handles all HTTP communication with the Spotify Web API.
///
/// Uses Client Credentials flow for authentication. The token is stored
/// in memory and refreshed automatically on 401 responses.
class SpotifyRemoteSource {
  final http.Client _client;

  String? _accessToken;

  SpotifyRemoteSource({http.Client? client})
    : _client = client ?? http.Client();

  /// Authenticate using Client Credentials flow.
  Future<void> authenticate() async {
    final credentials = base64Encode(
      utf8.encode(
        '${AppConfig.spotifyClientId}:${AppConfig.spotifyClientSecret}',
      ),
    );

    final response = await _client.post(
      Uri.parse('${AppConfig.spotifyAccountsBaseUrl}/api/token'),
      headers: {
        'Authorization': 'Basic $credentials',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: 'grant_type=client_credentials',
    );

    if (response.statusCode != 200) {
      throw ApiException(response.statusCode, 'Authentication failed');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    _accessToken = data['access_token'] as String;
  }

  /// Fetch new album releases.
  Future<List<Album>> fetchNewReleases({
    int limit = AppConfig.defaultPageSize,
    int offset = 0,
  }) async {
    final data = await _get(
      '${AppConfig.spotifyApiBaseUrl}/browse/new-releases',
      queryParams: {'limit': '$limit', 'offset': '$offset'},
    );
    final items = (data['albums']['items'] as List<dynamic>?) ?? [];
    return items
        .map((json) => Album.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Search for albums matching query.
  Future<List<Album>> searchAlbums(
    String query, {
    int limit = AppConfig.defaultPageSize,
    int offset = 0,
  }) async {
    final data = await _get(
      '${AppConfig.spotifyApiBaseUrl}/search',
      queryParams: {
        'q': query,
        'type': 'album',
        'limit': '$limit',
        'offset': '$offset',
      },
    );
    final items = (data['albums']['items'] as List<dynamic>?) ?? [];
    return items
        .map((json) => Album.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Fetch tracks for a specific album.
  Future<List<Track>> fetchAlbumTracks(
    String albumId, {
    int limit = AppConfig.defaultPageSize,
  }) async {
    final data = await _get(
      '${AppConfig.spotifyApiBaseUrl}/albums/$albumId/tracks',
      queryParams: {'limit': '$limit'},
    );
    final items = (data['items'] as List<dynamic>?) ?? [];
    return items
        .map((json) => Track.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Generic GET request with auto-retry on 401.
  Future<Map<String, dynamic>> _get(
    String url, {
    Map<String, String>? queryParams,
    bool isRetry = false,
  }) async {
    if (_accessToken == null) {
      await authenticate();
    }

    final uri = Uri.parse(url).replace(queryParameters: queryParams);
    final response = await _client.get(
      uri,
      headers: {'Authorization': 'Bearer $_accessToken'},
    );

    if (response.statusCode == 401 && !isRetry) {
      await authenticate();
      return _get(url, queryParams: queryParams, isRetry: true);
    }

    if (response.statusCode != 200) {
      throw ApiException(
        response.statusCode,
        'API request failed: ${response.body}',
      );
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}
