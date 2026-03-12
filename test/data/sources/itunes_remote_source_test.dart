import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import 'package:example_flutter/data/sources/itunes_remote_source.dart';
import 'package:example_flutter/utils/api_exception.dart';

import '../../mocks.mocks.dart';

void main() {
  late MockClient mockClient;
  late ItunesRemoteSource source;

  setUp(() {
    mockClient = MockClient();
    source = ItunesRemoteSource(client: mockClient);
  });

  group('fetchTopAlbums', () {
    test('returns list of albums on 200', () async {
      final body = jsonEncode({
        'feed': {
          'entry': [
            {
              'id': {
                'attributes': {'im:id': '1'},
              },
              'im:name': {'label': 'Album 1'},
              'im:artist': {'label': 'Artist 1'},
              'im:image': [
                {'label': 'https://img.com/170x170bb.jpg'},
              ],
            },
          ],
        },
      });
      when(
        mockClient.get(any),
      ).thenAnswer((_) async => http.Response(body, 200));

      final albums = await source.fetchTopAlbums(limit: 1);

      expect(albums.length, 1);
      expect(albums.first.id, '1');
      expect(albums.first.name, 'Album 1');
    });

    test('returns empty list when no entries', () async {
      final body = jsonEncode({'feed': <String, dynamic>{}});
      when(
        mockClient.get(any),
      ).thenAnswer((_) async => http.Response(body, 200));

      final albums = await source.fetchTopAlbums();

      expect(albums, isEmpty);
    });

    test('throws ApiException on non-200', () async {
      when(
        mockClient.get(any),
      ).thenAnswer((_) async => http.Response('server error', 500));

      expect(() => source.fetchTopAlbums(), throwsA(isA<ApiException>()));
    });
  });

  group('searchAlbums', () {
    test('returns list of albums on 200', () async {
      final body = jsonEncode({
        'results': [
          {
            'collectionId': 42,
            'collectionName': 'Search Result',
            'artistName': 'Artist',
            'artworkUrl100': 'https://img.com/100x100bb.jpg',
          },
        ],
      });
      when(
        mockClient.get(any),
      ).thenAnswer((_) async => http.Response(body, 200));

      final albums = await source.searchAlbums('test', limit: 5);

      expect(albums.length, 1);
      expect(albums.first.id, '42');
      expect(albums.first.name, 'Search Result');
    });

    test('throws ApiException on 429', () async {
      when(
        mockClient.get(any),
      ).thenAnswer((_) async => http.Response('rate limited', 429));

      expect(
        () => source.searchAlbums('test'),
        throwsA(
          isA<ApiException>().having(
            (e) => e.isRateLimited,
            'isRateLimited',
            isTrue,
          ),
        ),
      );
    });
  });

  group('fetchAlbumTracks', () {
    test('returns tracks filtering out collection wrapper', () async {
      final body = jsonEncode({
        'results': [
          {'wrapperType': 'collection', 'collectionId': 1},
          {
            'wrapperType': 'track',
            'trackId': 10,
            'trackName': 'Song 1',
            'trackTimeMillis': 200000,
            'trackNumber': 1,
          },
          {
            'wrapperType': 'track',
            'trackId': 11,
            'trackName': 'Song 2',
            'trackTimeMillis': 180000,
            'trackNumber': 2,
          },
        ],
      });
      when(
        mockClient.get(any),
      ).thenAnswer((_) async => http.Response(body, 200));

      final tracks = await source.fetchAlbumTracks('1');

      expect(tracks.length, 2);
      expect(tracks.first.name, 'Song 1');
      expect(tracks.last.trackNumber, 2);
    });

    test('returns empty list when no tracks', () async {
      final body = jsonEncode({
        'results': [
          {'wrapperType': 'collection', 'collectionId': 1},
        ],
      });
      when(
        mockClient.get(any),
      ).thenAnswer((_) async => http.Response(body, 200));

      final tracks = await source.fetchAlbumTracks('1');

      expect(tracks, isEmpty);
    });

    test('throws ApiException on 404', () async {
      when(
        mockClient.get(any),
      ).thenAnswer((_) async => http.Response('not found', 404));

      expect(
        () => source.fetchAlbumTracks('999'),
        throwsA(
          isA<ApiException>().having((e) => e.statusCode, 'statusCode', 404),
        ),
      );
    });
  });
}
