const _kUnknown = 'Unknown';
const _kImageSize = '600x600bb';

/// Represents a music album from the iTunes API.
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

  /// Parse from iTunes RSS Feed JSON entry.
  ///
  /// RSS feed nests data inside label objects:
  /// `im:name.label`, `im:artist.label`, `im:image[].label`, `id.attributes.im:id`
  factory Album.fromItunesRss(Map<String, dynamic> json) {
    final id =
        (json['id'] as Map<String, dynamic>?)?['attributes']?['im:id']
            as String? ??
        '';

    final name =
        (json['im:name'] as Map<String, dynamic>?)?['label'] as String? ??
        _kUnknown;

    final artistName =
        (json['im:artist'] as Map<String, dynamic>?)?['label'] as String? ??
        _kUnknown;

    // Use the largest image (index 2 = 170px), then upscale to 600px
    final images = json['im:image'] as List<dynamic>? ?? [];
    var imageUrl = '';
    if (images.isNotEmpty) {
      final raw =
          (images.last as Map<String, dynamic>)['label'] as String? ?? '';
      imageUrl = raw.replaceAll('170x170bb', _kImageSize);
    }

    final releaseDate =
        (json['im:releaseDate']
                as Map<String, dynamic>?)?['attributes']?['label']
            as String?;

    return Album(
      id: id,
      name: name,
      artistName: artistName,
      imageUrl: imageUrl,
      releaseDate: releaseDate,
      albumType: 'album',
    );
  }

  /// Parse from iTunes Search API JSON result.
  ///
  /// Search API uses flat keys: `collectionId`, `collectionName`,
  /// `artistName`, `artworkUrl100`.
  factory Album.fromItunesSearch(Map<String, dynamic> json) {
    final id = (json['collectionId'] ?? '').toString();

    // Upscale artwork from 100x100 to 600x600
    final rawArt = json['artworkUrl100'] as String? ?? '';
    final imageUrl = rawArt.replaceAll('100x100bb', _kImageSize);

    // releaseDate comes as ISO 8601 timestamp, extract date part
    final rawDate = json['releaseDate'] as String?;
    String? releaseDate;
    if (rawDate != null && rawDate.length >= 10) {
      releaseDate = rawDate.substring(0, 10);
    }

    return Album(
      id: id,
      name: json['collectionName'] as String? ?? _kUnknown,
      artistName: json['artistName'] as String? ?? _kUnknown,
      imageUrl: imageUrl,
      releaseDate: releaseDate,
      albumType: 'album',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'artistName': artistName,
    'imageUrl': imageUrl,
    'releaseDate': releaseDate,
    'albumType': albumType,
  };
}
