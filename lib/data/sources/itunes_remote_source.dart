import 'dart:convert';
import 'dart:developer' as dev;

import 'package:http/http.dart' as http;

import '../../config/app_config.dart';
import '../../models/album.dart';
import '../../models/track.dart';
import '../../utils/api_exception.dart';

const _logName = 'ItunesRemoteSource';

/// Handles all HTTP communication with the iTunes RSS/Search/Lookup APIs.
///
/// No authentication required — all Apple iTunes APIs are free and open.
class ItunesRemoteSource {
  final http.Client _client;

  ItunesRemoteSource({http.Client? client}) : _client = client ?? http.Client();

  /// Fetch top albums from iTunes RSS Feed.
  Future<List<Album>> fetchTopAlbums({
    int limit = AppConfig.defaultPageSize,
  }) async {
    final url =
        '${AppConfig.itunesBaseUrl}/${AppConfig.itunesCountryCode}'
        '/rss/topalbums/limit=$limit/json';

    dev.log('GET $url', name: _logName);

    final response = await _get(url);
    final feed = response['feed'] as Map<String, dynamic>? ?? {};
    final entries = (feed['entry'] as List<dynamic>?) ?? [];

    dev.log('fetchTopAlbums: ${entries.length} entries', name: _logName);

    return entries
        .map((json) => Album.fromItunesRss(json as Map<String, dynamic>))
        .toList();
  }

  /// Search for albums via iTunes Search API.
  Future<List<Album>> searchAlbums(
    String query, {
    int limit = AppConfig.defaultPageSize,
  }) async {
    final uri = Uri.parse('${AppConfig.itunesBaseUrl}/search').replace(
      queryParameters: {
        'term': query,
        'entity': 'album',
        'limit': '$limit',
        'country': AppConfig.itunesCountryCode,
      },
    );

    dev.log('GET $uri', name: _logName);

    final body = await _getUri(uri);
    final results = (body['results'] as List<dynamic>?) ?? [];

    dev.log(
      'searchAlbums("$query"): ${results.length} results',
      name: _logName,
    );

    return results
        .map((json) => Album.fromItunesSearch(json as Map<String, dynamic>))
        .toList();
  }

  /// Fetch tracks for a specific album via iTunes Lookup API.
  Future<List<Track>> fetchAlbumTracks(String collectionId) async {
    final uri = Uri.parse(
      '${AppConfig.itunesBaseUrl}/lookup',
    ).replace(queryParameters: {'id': collectionId, 'entity': 'song'});

    dev.log('GET $uri', name: _logName);

    final body = await _getUri(uri);
    final results = (body['results'] as List<dynamic>?) ?? [];

    // First result is the collection itself; filter to tracks only
    final trackResults = results
        .where((r) => (r as Map<String, dynamic>)['wrapperType'] == 'track')
        .toList();

    dev.log(
      'fetchAlbumTracks($collectionId): ${trackResults.length} tracks',
      name: _logName,
    );

    return trackResults
        .map((json) => Track.fromItunesLookup(json as Map<String, dynamic>))
        .toList();
  }

  /// GET request with a plain URL string.
  Future<Map<String, dynamic>> _get(String url) async {
    return _getUri(Uri.parse(url));
  }

  /// GET request with a [Uri].
  Future<Map<String, dynamic>> _getUri(Uri uri) async {
    final response = await _client.get(uri);

    dev.log('Response: status=${response.statusCode} url=$uri', name: _logName);

    if (response.statusCode != 200) {
      dev.log(
        'API Error! status=${response.statusCode} url=$uri\n'
        'Raw body: ${response.body}',
        name: _logName,
        level: 1000,
      );

      throw ApiException(
        response.statusCode,
        'API request failed: ${response.body}',
      );
    }

    dev.log('Success: ${response.body.length} bytes received', name: _logName);
    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}
