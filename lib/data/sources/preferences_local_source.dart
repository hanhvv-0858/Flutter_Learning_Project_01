import 'package:shared_preferences/shared_preferences.dart';

/// Wrapper around SharedPreferences for type-safe access
/// to onboarding and locale user preferences.
class PreferencesLocalSource {
  final SharedPreferences _prefs;

  static const _keyOnboardingCompleted = 'onboarding_completed';
  static const _keyLocaleCode = 'locale_code';

  PreferencesLocalSource(this._prefs);

  // -- Onboarding --

  bool getOnboardingCompleted() {
    return _prefs.getBool(_keyOnboardingCompleted) ?? false;
  }

  Future<void> setOnboardingCompleted(bool value) async {
    await _prefs.setBool(_keyOnboardingCompleted, value);
  }

  // -- Locale --

  String getLocaleCode() {
    return _prefs.getString(_keyLocaleCode) ?? 'en';
  }

  Future<void> setLocaleCode(String code) async {
    await _prefs.setString(_keyLocaleCode, code);
  }
}
