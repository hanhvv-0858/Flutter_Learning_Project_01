import 'album.dart';

/// Represents a locally saved album (favorite).
///
/// Mirrors [Album] fields with an added [savedAt] timestamp.
/// Stored in the local Sqflite database.
class Favorite {
  final String id;
  final String name;
  final String artistName;
  final String imageUrl;
  final String? releaseDate;
  final String albumType;
  final DateTime savedAt;

  const Favorite({
    required this.id,
    required this.name,
    required this.artistName,
    required this.imageUrl,
    this.releaseDate,
    required this.albumType,
    required this.savedAt,
  });

  /// Create a Favorite from an Album, setting savedAt to now.
  factory Favorite.fromAlbum(Album album) {
    return Favorite(
      id: album.id,
      name: album.name,
      artistName: album.artistName,
      imageUrl: album.imageUrl,
      releaseDate: album.releaseDate,
      albumType: album.albumType,
      savedAt: DateTime.now(),
    );
  }

  /// Parse from Sqflite row map.
  factory Favorite.fromMap(Map<String, dynamic> map) {
    return Favorite(
      id: map['id'] as String,
      name: map['name'] as String,
      artistName: map['artist_name'] as String,
      imageUrl: map['image_url'] as String,
      releaseDate: map['release_date'] as String?,
      albumType: map['album_type'] as String,
      savedAt: DateTime.parse(map['saved_at'] as String),
    );
  }

  /// Convert to Sqflite row map.
  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'artist_name': artistName,
    'image_url': imageUrl,
    'release_date': releaseDate,
    'album_type': albumType,
    'saved_at': savedAt.toIso8601String(),
  };

  /// Convert back to Album (for display in shared widgets).
  Album toAlbum() => Album(
    id: id,
    name: name,
    artistName: artistName,
    imageUrl: imageUrl,
    releaseDate: releaseDate,
    albumType: albumType,
  );
}
