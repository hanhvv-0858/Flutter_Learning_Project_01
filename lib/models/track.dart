/// Represents a single track within an album.
class Track {
  final String id;
  final String name;
  final int durationMs;
  final int trackNumber;

  const Track({
    required this.id,
    required this.name,
    required this.durationMs,
    required this.trackNumber,
  });

  /// Parse from iTunes Lookup API JSON response.
  ///
  /// Lookup returns `trackId` (int), `trackName`, `trackTimeMillis`,
  /// and `trackNumber`.
  factory Track.fromItunesLookup(Map<String, dynamic> json) {
    return Track(
      id: (json['trackId'] ?? '').toString(),
      name: json['trackName'] as String? ?? 'Unknown',
      durationMs: json['trackTimeMillis'] as int? ?? 0,
      trackNumber: json['trackNumber'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'trackId': id,
    'trackName': name,
    'trackTimeMillis': durationMs,
    'trackNumber': trackNumber,
  };

  /// Format duration as mm:ss for display.
  String get formattedDuration {
    final minutes = (durationMs ~/ 60000);
    final seconds = ((durationMs % 60000) ~/ 1000);
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}
