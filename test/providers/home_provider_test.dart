import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:example_flutter/models/album.dart';
import 'package:example_flutter/providers/home_provider.dart';

import '../mocks.mocks.dart';

void main() {
  late MockMusicRepository mockRepo;
  late HomeProvider provider;

  setUp(() {
    mockRepo = MockMusicRepository();
    provider = HomeProvider(mockRepo);
  });

  const album = Album(
    id: '1',
    name: 'Album',
    artistName: 'Artist',
    imageUrl: '',
    albumType: 'album',
  );

  group('initial state', () {
    test('has empty albums and no loading', () {
      expect(provider.albums, isEmpty);
      expect(provider.isLoading, isFalse);
      expect(provider.errorMessage, isNull);
    });
  });

  group('fetchNewReleases', () {
    test('success path sets albums', () async {
      when(mockRepo.getNewReleases()).thenAnswer((_) async => [album]);

      await provider.fetchNewReleases();

      expect(provider.albums, [album]);
      expect(provider.isLoading, isFalse);
      expect(provider.errorMessage, isNull);
    });

    test('error path sets errorMessage', () async {
      when(mockRepo.getNewReleases()).thenThrow(Exception('network error'));

      await provider.fetchNewReleases();

      expect(provider.errorMessage, contains('network error'));
      expect(provider.isLoading, isFalse);
    });

    test('sets isLoading during fetch', () async {
      var wasLoading = false;
      when(mockRepo.getNewReleases()).thenAnswer((_) async {
        wasLoading = provider.isLoading;
        return [album];
      });

      await provider.fetchNewReleases();

      expect(wasLoading, isTrue);
    });
  });

  group('retry', () {
    test('delegates to fetchNewReleases', () async {
      when(mockRepo.getNewReleases()).thenAnswer((_) async => [album]);

      await provider.retry();

      verify(mockRepo.getNewReleases()).called(1);
      expect(provider.albums, [album]);
    });
  });
}
