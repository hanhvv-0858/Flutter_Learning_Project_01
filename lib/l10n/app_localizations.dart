import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi'),
  ];

  /// Application title
  ///
  /// In en, this message translates to:
  /// **'Music Explorer'**
  String get appTitle;

  /// Splash screen loading text
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get splashLoading;

  /// Onboarding page 1 title
  ///
  /// In en, this message translates to:
  /// **'Discover Music'**
  String get onboardingTitle1;

  /// Onboarding page 1 description
  ///
  /// In en, this message translates to:
  /// **'Browse the latest album releases from around the world.'**
  String get onboardingDesc1;

  /// Onboarding page 2 title
  ///
  /// In en, this message translates to:
  /// **'Search & Explore'**
  String get onboardingTitle2;

  /// Onboarding page 2 description
  ///
  /// In en, this message translates to:
  /// **'Find your favorite albums and explore track details.'**
  String get onboardingDesc2;

  /// Onboarding page 3 title
  ///
  /// In en, this message translates to:
  /// **'Save Favorites'**
  String get onboardingTitle3;

  /// Onboarding page 3 description
  ///
  /// In en, this message translates to:
  /// **'Save albums to your favorites for quick offline access.'**
  String get onboardingDesc3;

  /// Onboarding next button
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// Onboarding final page button
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get onboardingGetStarted;

  /// Onboarding skip button
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// Home screen title
  ///
  /// In en, this message translates to:
  /// **'New Releases'**
  String get homeTitle;

  /// Detail screen title
  ///
  /// In en, this message translates to:
  /// **'Album Details'**
  String get detailTitle;

  /// Track list section header
  ///
  /// In en, this message translates to:
  /// **'Tracks'**
  String get detailTracks;

  /// Release date label
  ///
  /// In en, this message translates to:
  /// **'Released: {date}'**
  String detailReleaseDate(String date);

  /// Save button label
  ///
  /// In en, this message translates to:
  /// **'Save to Favorites'**
  String get detailSaveToFavorites;

  /// Remove button label
  ///
  /// In en, this message translates to:
  /// **'Remove from Favorites'**
  String get detailRemoveFromFavorites;

  /// Snackbar message after saving
  ///
  /// In en, this message translates to:
  /// **'Saved to favorites!'**
  String get detailSaved;

  /// Snackbar message after removing
  ///
  /// In en, this message translates to:
  /// **'Removed from favorites.'**
  String get detailRemoved;

  /// Favorites screen title
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favoritesTitle;

  /// Empty state message on favorites
  ///
  /// In en, this message translates to:
  /// **'No favorites yet. Save albums from the detail screen!'**
  String get favoritesEmpty;

  /// Swipe instructions
  ///
  /// In en, this message translates to:
  /// **'Swipe to remove'**
  String get favoritesSwipeHint;

  /// Settings screen title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// Language section header
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// English option
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsEnglish;

  /// Vietnamese option
  ///
  /// In en, this message translates to:
  /// **'Tiếng Việt'**
  String get settingsVietnamese;

  /// Search screen title
  ///
  /// In en, this message translates to:
  /// **'Search Albums'**
  String get searchTitle;

  /// Search field hint text
  ///
  /// In en, this message translates to:
  /// **'Search for albums...'**
  String get searchHint;

  /// Empty search results
  ///
  /// In en, this message translates to:
  /// **'No results found.'**
  String get searchNoResults;

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorGeneric;

  /// Network error message
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Please check your network.'**
  String get errorNetwork;

  /// Retry button label
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryButton;

  /// Bottom nav home label
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// Bottom nav favorites label
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get navFavorites;

  /// Bottom nav settings label
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
