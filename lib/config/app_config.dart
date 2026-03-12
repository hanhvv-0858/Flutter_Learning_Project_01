/// Application configuration loaded from environment variables.
///
/// Spotify API credentials are passed via `--dart-define` at build time:
/// ```
/// flutter run \
///   --dart-define=SPOTIFY_CLIENT_ID=xxx \
///   --dart-define=SPOTIFY_CLIENT_SECRET=yyy
/// ```
class AppConfig {
  AppConfig._();

  // Spotify API
  static const String spotifyClientId = String.fromEnvironment(
    'SPOTIFY_CLIENT_ID',
    defaultValue: '',
  );
  static const String spotifyClientSecret = String.fromEnvironment(
    'SPOTIFY_CLIENT_SECRET',
    defaultValue: '',
  );
  static const String spotifyAccountsBaseUrl = 'https://accounts.spotify.com';
  static const String spotifyApiBaseUrl = 'https://api.spotify.com/v1';

  // Splash
  static const Duration splashDuration = Duration(seconds: 2);

  // Pagination
  static const int defaultPageSize = 20;
}
