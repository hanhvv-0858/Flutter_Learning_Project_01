import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Application configuration — reads Spotify credentials from `.env` at runtime.
///
/// The `.env` file at the project root is bundled as an asset (see pubspec.yaml).
/// It is loaded via `dotenv.load()` in `main()` before `runApp`.
///
/// Alternatively, values can still be overridden at build time via `--dart-define`:
/// ```
/// flutter run \
///   --dart-define=SPOTIFY_CLIENT_ID=xxx \
///   --dart-define=SPOTIFY_CLIENT_SECRET=yyy
/// ```
class AppConfig {
  AppConfig._();

  // Spotify API — reads from .env, falls back to --dart-define, then empty
  static String get spotifyClientId =>
      dotenv.env['SPOTIFY_CLIENT_ID'] ??
      const String.fromEnvironment('SPOTIFY_CLIENT_ID', defaultValue: '');

  static String get spotifyClientSecret =>
      dotenv.env['SPOTIFY_CLIENT_SECRET'] ??
      const String.fromEnvironment('SPOTIFY_CLIENT_SECRET', defaultValue: '');

  static const String spotifyAccountsBaseUrl = 'https://accounts.spotify.com';
  static const String spotifyApiBaseUrl = 'https://api.spotify.com/v1';

  // Splash
  static const Duration splashDuration = Duration(seconds: 2);

  // Pagination
  static const int defaultPageSize = 20;
}
