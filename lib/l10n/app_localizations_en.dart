// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Music Explorer';

  @override
  String get splashLoading => 'Loading...';

  @override
  String get onboardingTitle1 => 'Discover Music';

  @override
  String get onboardingDesc1 =>
      'Browse the latest album releases from around the world.';

  @override
  String get onboardingTitle2 => 'Search & Explore';

  @override
  String get onboardingDesc2 =>
      'Find your favorite albums and explore track details.';

  @override
  String get onboardingTitle3 => 'Save Favorites';

  @override
  String get onboardingDesc3 =>
      'Save albums to your favorites for quick offline access.';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingGetStarted => 'Get Started';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get homeTitle => 'New Releases';

  @override
  String get detailTitle => 'Album Details';

  @override
  String get detailTracks => 'Tracks';

  @override
  String detailReleaseDate(String date) {
    return 'Released: $date';
  }

  @override
  String get detailSaveToFavorites => 'Save to Favorites';

  @override
  String get detailRemoveFromFavorites => 'Remove from Favorites';

  @override
  String get detailSaved => 'Saved to favorites!';

  @override
  String get detailRemoved => 'Removed from favorites.';

  @override
  String get favoritesTitle => 'Favorites';

  @override
  String get favoritesEmpty =>
      'No favorites yet. Save albums from the detail screen!';

  @override
  String get favoritesSwipeHint => 'Swipe to remove';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsEnglish => 'English';

  @override
  String get settingsVietnamese => 'Tiếng Việt';

  @override
  String get searchTitle => 'Search Albums';

  @override
  String get searchHint => 'Search for albums...';

  @override
  String get searchNoResults => 'No results found.';

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';

  @override
  String get errorNetwork =>
      'No internet connection. Please check your network.';

  @override
  String get retryButton => 'Retry';

  @override
  String get navHome => 'Home';

  @override
  String get navFavorites => 'Favorites';

  @override
  String get navSettings => 'Settings';
}
