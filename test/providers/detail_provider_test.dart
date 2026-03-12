import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:example_flutter/models/album.dart';
import 'package:example_flutter/models/track.dart';
import 'package:example_flutter/providers/detail_provider.dart';

import '../mocks.mocks.dart';

void main() {
  late MockMusicRepository mockMusicRepo;
  late MockFavoritesRepository mockFavRepo;
  late DetailProvider provider;

  const album = Album(
    id: '1',
    name: 'Test Album',
    artistName: 'Artist',
    imageUrl: '',
    albumType: 'album',
  );

  const track = Track(
    id: '10',
    name: 'Song',
    durationMs: 200000,
    trackNumber: 1,
  );

  setUp(() {
    mockMusicRepo = MockMusicRepository();
    mockFavRepo = MockFavoritesRepository();
    provider = DetailProvider(mockMusicRepo, mockFavRepo);
  });

  group('initial state', () {
    test('has empty tracks and not favorite', () {
      expect(provider.tracks, isEmpty);
      expect(provider.isLoadingTracks, isFalse);
      expect(provider.tracksError, isNull);
      expect(provider.isFavorite, isFalse);
    });
  });

  group('loadTracks', () {
    test('success sets tracks', () async {
      when(mockMusicRepo.getAlbumTracks('1')).thenAnswer((_) async => [track]);

      await provider.loadTracks('1');

      expect(provider.tracks, [track]);
      expect(provider.isLoadingTracks, isFalse);
      expect(provider.tracksError, isNull);
    });

    test('error sets tracksError', () async {
      when(mockMusicRepo.getAlbumTracks('1')).thenThrow(Exception('fail'));

      await provider.loadTracks('1');

      expect(provider.tracksError, contains('fail'));
      expect(provider.isLoadingTracks, isFalse);
    });
  });

  group('checkFavorite', () {
    test('sets isFavorite from repository', () async {
      when(mockFavRepo.isFavorite('1')).thenAnswer((_) async => true);

      await provider.checkFavorite('1');

      expect(provider.isFavorite, isTrue);
    });
  });

  group('toggleFavorite', () {
    test('adds favorite when not favorite', () async {
      when(mockFavRepo.isFavorite('1')).thenAnswer((_) async => false);
      when(mockFavRepo.addFavorite(album)).thenAnswer((_) async {});

      await provider.checkFavorite('1');
      await provider.toggleFavorite(album);

      expect(provider.isFavorite, isTrue);
      verify(mockFavRepo.addFavorite(album)).called(1);
    });

    test('removes favorite when already favorite', () async {
      when(mockFavRepo.isFavorite('1')).thenAnswer((_) async => true);
      when(mockFavRepo.removeFavorite('1')).thenAnswer((_) async {});

      await provider.checkFavorite('1');
      await provider.toggleFavorite(album);

      expect(provider.isFavorite, isFalse);
      verify(mockFavRepo.removeFavorite('1')).called(1);
    });
  });
}
