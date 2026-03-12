import 'package:flutter_test/flutter_test.dart';
import 'package:example_flutter/models/track.dart';

void main() {
  group('Track.fromItunesLookup', () {
    test('parses full lookup entry', () {
      final json = <String, dynamic>{
        'trackId': 111,
        'trackName': 'Test Track',
        'trackTimeMillis': 245000,
        'trackNumber': 3,
      };

      final track = Track.fromItunesLookup(json);

      expect(track.id, '111');
      expect(track.name, 'Test Track');
      expect(track.durationMs, 245000);
      expect(track.trackNumber, 3);
    });

    test('handles missing fields with defaults', () {
      final track = Track.fromItunesLookup(<String, dynamic>{});

      expect(track.id, '');
      expect(track.name, 'Unknown');
      expect(track.durationMs, 0);
      expect(track.trackNumber, 0);
    });
  });

  group('Track.toJson', () {
    test('serializes all fields', () {
      const track = Track(
        id: '42',
        name: 'Song',
        durationMs: 180000,
        trackNumber: 1,
      );

      final json = track.toJson();

      expect(json['trackId'], '42');
      expect(json['trackName'], 'Song');
      expect(json['trackTimeMillis'], 180000);
      expect(json['trackNumber'], 1);
    });
  });

  group('Track.formattedDuration', () {
    test('formats standard duration', () {
      const track = Track(
        id: '1',
        name: 'A',
        durationMs: 245000, // 4:05
        trackNumber: 1,
      );
      expect(track.formattedDuration, '4:05');
    });

    test('formats zero duration', () {
      const track = Track(id: '1', name: 'A', durationMs: 0, trackNumber: 1);
      expect(track.formattedDuration, '0:00');
    });

    test('formats exact minute', () {
      const track = Track(
        id: '1',
        name: 'A',
        durationMs: 180000, // 3:00
        trackNumber: 1,
      );
      expect(track.formattedDuration, '3:00');
    });

    test('formats single-digit seconds with padding', () {
      const track = Track(
        id: '1',
        name: 'A',
        durationMs: 63000, // 1:03
        trackNumber: 1,
      );
      expect(track.formattedDuration, '1:03');
    });
  });
}
