import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:example_flutter/data/repositories/music_repository.dart';
import 'package:example_flutter/models/album.dart';
import 'package:example_flutter/models/track.dart';

import '../../mocks.mocks.dart';

void main() {
  late MockItunesRemoteSource mockSource;
  late MusicRepository repo;

  setUp(() {
    mockSource = MockItunesRemoteSource();
    repo = MusicRepository(mockSource);
  });

  group('getNewReleases', () {
    test('delegates to fetchTopAlbums with limit', () async {
      final albums = [
        const Album(
          id: '1',
          name: 'A',
          artistName: 'B',
          imageUrl: '',
          albumType: 'album',
        ),
      ];
      when(
        mockSource.fetchTopAlbums(limit: 10),
      ).thenAnswer((_) async => albums);

      final result = await repo.getNewReleases(limit: 10);

      expect(result, albums);
      verify(mockSource.fetchTopAlbums(limit: 10)).called(1);
    });
  });

  group('searchAlbums', () {
    test('delegates to source searchAlbums', () async {
      when(
        mockSource.searchAlbums('rock', limit: 5),
      ).thenAnswer((_) async => <Album>[]);

      final result = await repo.searchAlbums('rock', limit: 5);

      expect(result, isEmpty);
      verify(mockSource.searchAlbums('rock', limit: 5)).called(1);
    });
  });

  group('getAlbumTracks', () {
    test('delegates to fetchAlbumTracks', () async {
      final tracks = [
        const Track(id: '1', name: 'T', durationMs: 1000, trackNumber: 1),
      ];
      when(mockSource.fetchAlbumTracks('123')).thenAnswer((_) async => tracks);

      final result = await repo.getAlbumTracks('123');

      expect(result, tracks);
      verify(mockSource.fetchAlbumTracks('123')).called(1);
    });
  });
}
