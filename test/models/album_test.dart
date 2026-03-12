import 'package:flutter_test/flutter_test.dart';
import 'package:example_flutter/models/album.dart';

void main() {
  group('Album.fromItunesRss', () {
    test('parses full RSS entry correctly', () {
      final json = <String, dynamic>{
        'id': {
          'attributes': {'im:id': '12345'},
        },
        'im:name': {'label': 'Test Album'},
        'im:artist': {'label': 'Test Artist'},
        'im:image': [
          {'label': 'https://example.com/55x55bb.jpg'},
          {'label': 'https://example.com/60x60bb.jpg'},
          {'label': 'https://example.com/170x170bb.jpg'},
        ],
        'im:releaseDate': {
          'attributes': {'label': 'January 1, 2025'},
        },
      };

      final album = Album.fromItunesRss(json);

      expect(album.id, '12345');
      expect(album.name, 'Test Album');
      expect(album.artistName, 'Test Artist');
      expect(album.imageUrl, 'https://example.com/600x600bb.jpg');
      expect(album.releaseDate, 'January 1, 2025');
      expect(album.albumType, 'album');
    });

    test('handles missing fields with defaults', () {
      final album = Album.fromItunesRss(<String, dynamic>{});

      expect(album.id, '');
      expect(album.name, 'Unknown');
      expect(album.artistName, 'Unknown');
      expect(album.imageUrl, '');
      expect(album.releaseDate, isNull);
      expect(album.albumType, 'album');
    });

    test('handles empty images list', () {
      final json = <String, dynamic>{'im:image': <dynamic>[]};
      final album = Album.fromItunesRss(json);
      expect(album.imageUrl, '');
    });
  });

  group('Album.fromItunesSearch', () {
    test('parses search result correctly', () {
      final json = <String, dynamic>{
        'collectionId': 67890,
        'collectionName': 'Search Album',
        'artistName': 'Search Artist',
        'artworkUrl100': 'https://example.com/100x100bb.jpg',
        'releaseDate': '2025-01-15T08:00:00Z',
      };

      final album = Album.fromItunesSearch(json);

      expect(album.id, '67890');
      expect(album.name, 'Search Album');
      expect(album.artistName, 'Search Artist');
      expect(album.imageUrl, 'https://example.com/600x600bb.jpg');
      expect(album.releaseDate, '2025-01-15');
      expect(album.albumType, 'album');
    });

    test('handles missing collectionId', () {
      final album = Album.fromItunesSearch(<String, dynamic>{});
      expect(album.id, '');
      expect(album.name, 'Unknown');
      expect(album.artistName, 'Unknown');
    });

    test('handles short releaseDate', () {
      final json = <String, dynamic>{'releaseDate': '2025'};
      final album = Album.fromItunesSearch(json);
      expect(album.releaseDate, isNull);
    });

    test('handles null releaseDate', () {
      final json = <String, dynamic>{'releaseDate': null};
      final album = Album.fromItunesSearch(json);
      expect(album.releaseDate, isNull);
    });
  });

  group('Album.toJson', () {
    test('serializes all fields', () {
      const album = Album(
        id: '1',
        name: 'Album',
        artistName: 'Artist',
        imageUrl: 'https://img.com/a.jpg',
        releaseDate: '2025-01-01',
        albumType: 'album',
      );

      final json = album.toJson();

      expect(json['id'], '1');
      expect(json['name'], 'Album');
      expect(json['artistName'], 'Artist');
      expect(json['imageUrl'], 'https://img.com/a.jpg');
      expect(json['releaseDate'], '2025-01-01');
      expect(json['albumType'], 'album');
    });

    test('serializes null releaseDate', () {
      const album = Album(
        id: '1',
        name: 'A',
        artistName: 'B',
        imageUrl: '',
        albumType: 'album',
      );
      expect(album.toJson()['releaseDate'], isNull);
    });
  });
}
