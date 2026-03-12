/// Application configuration — iTunes API base URLs and app constants.
///
/// iTunes RSS Feed and Search APIs are completely free and require no
/// API keys or authentication.
class AppConfig {
  AppConfig._();

  // iTunes API
  static const String itunesBaseUrl = 'https://itunes.apple.com';
  static const String itunesCountryCode = 'us';

  // Splash
  static const Duration splashDuration = Duration(seconds: 2);

  // Pagination
  static const int defaultPageSize = 20;
}
