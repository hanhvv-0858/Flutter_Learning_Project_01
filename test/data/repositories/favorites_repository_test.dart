import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:example_flutter/data/repositories/favorites_repository.dart';
import 'package:example_flutter/models/album.dart';
import 'package:example_flutter/models/favorite.dart';

import '../../mocks.mocks.dart';

void main() {
  late MockFavoritesLocalSource mockSource;
  late FavoritesRepository repo;

  setUp(() {
    mockSource = MockFavoritesLocalSource();
    repo = FavoritesRepository(mockSource);
  });

  const album = Album(
    id: '1',
    name: 'Test',
    artistName: 'Artist',
    imageUrl: 'url',
    albumType: 'album',
  );

  group('getAllFavorites', () {
    test('delegates to source getAll', () async {
      when(mockSource.getAll()).thenAnswer((_) async => <Favorite>[]);

      final result = await repo.getAllFavorites();

      expect(result, isEmpty);
      verify(mockSource.getAll()).called(1);
    });
  });

  group('isFavorite', () {
    test('returns true when source returns a favorite', () async {
      final fav = Favorite.fromAlbum(album);
      when(mockSource.getById('1')).thenAnswer((_) async => fav);

      expect(await repo.isFavorite('1'), isTrue);
    });

    test('returns false when source returns null', () async {
      when(mockSource.getById('99')).thenAnswer((_) async => null);

      expect(await repo.isFavorite('99'), isFalse);
    });
  });

  group('addFavorite', () {
    test('inserts Favorite created from Album', () async {
      when(mockSource.insert(any)).thenAnswer((_) async {});

      await repo.addFavorite(album);

      final captured =
          verify(mockSource.insert(captureAny)).captured.single as Favorite;
      expect(captured.id, '1');
      expect(captured.name, 'Test');
    });
  });

  group('removeFavorite', () {
    test('delegates to source delete', () async {
      when(mockSource.delete('1')).thenAnswer((_) async {});

      await repo.removeFavorite('1');

      verify(mockSource.delete('1')).called(1);
    });
  });
}
