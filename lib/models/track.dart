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

  /// Parse from Spotify API JSON response.
  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Unknown',
      durationMs: json['duration_ms'] as int? ?? 0,
      trackNumber: json['track_number'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'duration_ms': durationMs,
    'track_number': trackNumber,
  };

  /// Format duration as mm:ss for display.
  String get formattedDuration {
    final minutes = (durationMs ~/ 60000);
    final seconds = ((durationMs % 60000) ~/ 1000);
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}
