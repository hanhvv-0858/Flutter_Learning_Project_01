import 'package:flutter_test/flutter_test.dart';
import 'package:example_flutter/models/album.dart';
import 'package:example_flutter/models/favorite.dart';

void main() {
  group('Favorite.fromAlbum', () {
    test('copies album fields and sets savedAt', () {
      const album = Album(
        id: '1',
        name: 'Test',
        artistName: 'Artist',
        imageUrl: 'https://img.com/a.jpg',
        releaseDate: '2025-01-01',
        albumType: 'album',
      );

      final before = DateTime.now();
      final fav = Favorite.fromAlbum(album);
      final after = DateTime.now();

      expect(fav.id, '1');
      expect(fav.name, 'Test');
      expect(fav.artistName, 'Artist');
      expect(fav.imageUrl, 'https://img.com/a.jpg');
      expect(fav.releaseDate, '2025-01-01');
      expect(fav.albumType, 'album');
      expect(
        fav.savedAt.isAfter(before.subtract(const Duration(seconds: 1))),
        isTrue,
      );
      expect(
        fav.savedAt.isBefore(after.add(const Duration(seconds: 1))),
        isTrue,
      );
    });
  });

  group('Favorite.fromMap / toMap', () {
    test('round-trips via map', () {
      final original = Favorite(
        id: '42',
        name: 'Fav Album',
        artistName: 'Fav Artist',
        imageUrl: 'https://img.com/fav.jpg',
        releaseDate: '2025-06-15',
        albumType: 'album',
        savedAt: DateTime.parse('2025-06-15T10:30:00.000'),
      );

      final map = original.toMap();
      final restored = Favorite.fromMap(map);

      expect(restored.id, original.id);
      expect(restored.name, original.name);
      expect(restored.artistName, original.artistName);
      expect(restored.imageUrl, original.imageUrl);
      expect(restored.releaseDate, original.releaseDate);
      expect(restored.albumType, original.albumType);
      expect(restored.savedAt, original.savedAt);
    });

    test('toMap uses snake_case column names', () {
      final fav = Favorite(
        id: '1',
        name: 'N',
        artistName: 'A',
        imageUrl: 'U',
        albumType: 'album',
        savedAt: DateTime.parse('2025-01-01T00:00:00.000'),
      );

      final map = fav.toMap();

      expect(map.containsKey('artist_name'), isTrue);
      expect(map.containsKey('image_url'), isTrue);
      expect(map.containsKey('release_date'), isTrue);
      expect(map.containsKey('album_type'), isTrue);
      expect(map.containsKey('saved_at'), isTrue);
    });

    test('handles null releaseDate in map', () {
      final map = <String, dynamic>{
        'id': '1',
        'name': 'N',
        'artist_name': 'A',
        'image_url': 'U',
        'release_date': null,
        'album_type': 'album',
        'saved_at': '2025-01-01T00:00:00.000',
      };

      final fav = Favorite.fromMap(map);
      expect(fav.releaseDate, isNull);
    });
  });

  group('Favorite.toAlbum', () {
    test('converts back to Album', () {
      final fav = Favorite(
        id: '99',
        name: 'Converted',
        artistName: 'CA',
        imageUrl: 'https://img.com/c.jpg',
        releaseDate: '2025-03-01',
        albumType: 'album',
        savedAt: DateTime.now(),
      );

      final album = fav.toAlbum();

      expect(album.id, '99');
      expect(album.name, 'Converted');
      expect(album.artistName, 'CA');
      expect(album.imageUrl, 'https://img.com/c.jpg');
      expect(album.releaseDate, '2025-03-01');
      expect(album.albumType, 'album');
    });
  });
}
