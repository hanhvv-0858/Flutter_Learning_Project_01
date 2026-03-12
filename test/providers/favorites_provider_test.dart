import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:example_flutter/models/favorite.dart';
import 'package:example_flutter/providers/favorites_provider.dart';

import '../mocks.mocks.dart';

void main() {
  late MockFavoritesRepository mockRepo;
  late FavoritesProvider provider;

  setUp(() {
    mockRepo = MockFavoritesRepository();
    provider = FavoritesProvider(mockRepo);
  });

  final fav = Favorite(
    id: '1',
    name: 'Fav',
    artistName: 'A',
    imageUrl: 'url',
    albumType: 'album',
    savedAt: DateTime(2025, 1, 1),
  );

  group('initial state', () {
    test('has empty favorites and not loading', () {
      expect(provider.favorites, isEmpty);
      expect(provider.isLoading, isFalse);
    });
  });

  group('loadFavorites', () {
    test('fetches and sets favorites', () async {
      when(mockRepo.getAllFavorites()).thenAnswer((_) async => [fav]);

      await provider.loadFavorites();

      expect(provider.favorites, [fav]);
      expect(provider.isLoading, isFalse);
    });
  });

  group('removeFavorite', () {
    test('removes from repo and local list', () async {
      when(mockRepo.getAllFavorites()).thenAnswer((_) async => [fav]);
      when(mockRepo.removeFavorite('1')).thenAnswer((_) async {});

      await provider.loadFavorites();
      await provider.removeFavorite('1');

      expect(provider.favorites, isEmpty);
      verify(mockRepo.removeFavorite('1')).called(1);
    });
  });
}
