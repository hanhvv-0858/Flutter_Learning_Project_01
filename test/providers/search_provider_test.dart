import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:example_flutter/models/album.dart';
import 'package:example_flutter/providers/search_provider.dart';

import '../mocks.mocks.dart';

void main() {
  late MockMusicRepository mockRepo;
  late SearchProvider provider;

  const album = Album(
    id: '1',
    name: 'Result',
    artistName: 'A',
    imageUrl: '',
    albumType: 'album',
  );

  setUp(() {
    mockRepo = MockMusicRepository();
    provider = SearchProvider(mockRepo);
  });

  group('initial state', () {
    test('has no results and not searched', () {
      expect(provider.results, isEmpty);
      expect(provider.isLoading, isFalse);
      expect(provider.errorMessage, isNull);
      expect(provider.isEmpty, isFalse);
      expect(provider.hasSearched, isFalse);
    });
  });

  group('search', () {
    test('success with results', () async {
      when(mockRepo.searchAlbums('rock')).thenAnswer((_) async => [album]);

      await provider.search('rock');

      expect(provider.results, [album]);
      expect(provider.isEmpty, isFalse);
      expect(provider.hasSearched, isTrue);
      expect(provider.isLoading, isFalse);
    });

    test('success with empty results sets isEmpty', () async {
      when(mockRepo.searchAlbums('zzz')).thenAnswer((_) async => []);

      await provider.search('zzz');

      expect(provider.results, isEmpty);
      expect(provider.isEmpty, isTrue);
      expect(provider.hasSearched, isTrue);
    });

    test('error path sets errorMessage', () async {
      when(mockRepo.searchAlbums('bad')).thenThrow(Exception('fail'));

      await provider.search('bad');

      expect(provider.errorMessage, contains('fail'));
      expect(provider.isLoading, isFalse);
    });

    test('empty query does nothing', () async {
      await provider.search('  ');

      verifyNever(mockRepo.searchAlbums(any));
      expect(provider.hasSearched, isFalse);
    });

    test('trims query before searching', () async {
      when(mockRepo.searchAlbums('rock')).thenAnswer((_) async => [album]);

      await provider.search('  rock  ');

      verify(mockRepo.searchAlbums('rock')).called(1);
    });
  });

  group('clear', () {
    test('resets all state', () async {
      when(mockRepo.searchAlbums('rock')).thenAnswer((_) async => [album]);

      await provider.search('rock');
      provider.clear();

      expect(provider.results, isEmpty);
      expect(provider.isLoading, isFalse);
      expect(provider.errorMessage, isNull);
      expect(provider.isEmpty, isFalse);
      expect(provider.hasSearched, isFalse);
    });
  });
}
