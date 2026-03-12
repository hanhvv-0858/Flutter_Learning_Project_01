/// Represents a music album from the Spotify API.
class Album {
  final String id;
  final String name;
  final String artistName;
  final String imageUrl;
  final String? releaseDate;
  final String albumType;

  const Album({
    required this.id,
    required this.name,
    required this.artistName,
    required this.imageUrl,
    this.releaseDate,
    required this.albumType,
  });

  /// Parse from Spotify API JSON response.
  ///
  /// The Spotify API nests artist names inside an `artists` array
  /// and images inside an `images` array sorted by size (largest first).
  factory Album.fromJson(Map<String, dynamic> json) {
    // Extract the first artist name, defaulting to 'Unknown'
    final artists = json['artists'] as List<dynamic>? ?? [];
    final artistName = artists.isNotEmpty
        ? (artists[0]['name'] as String? ?? 'Unknown')
        : 'Unknown';

    // Prefer the 300px image (index 1), fall back to first available
    final images = json['images'] as List<dynamic>? ?? [];
    final imageUrl = images.length > 1
        ? images[1]['url'] as String
        : (images.isNotEmpty ? images[0]['url'] as String : '');

    return Album(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Unknown',
      artistName: artistName,
      imageUrl: imageUrl,
      releaseDate: json['release_date'] as String?,
      albumType: json['album_type'] as String? ?? 'album',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'artists': [
      {'name': artistName},
    ],
    'images': [
      {'url': imageUrl},
    ],
    'release_date': releaseDate,
    'album_type': albumType,
  };
}
