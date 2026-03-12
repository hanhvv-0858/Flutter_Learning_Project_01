import '../sources/preferences_local_source.dart';

/// Abstracts user preference storage for the business logic layer.
class SettingsRepository {
  final PreferencesLocalSource _localSource;

  SettingsRepository(this._localSource);

  bool isOnboardingCompleted() {
    return _localSource.getOnboardingCompleted();
  }

  Future<void> completeOnboarding() {
    return _localSource.setOnboardingCompleted(true);
  }

  String getLocale() {
    return _localSource.getLocaleCode();
  }

  Future<void> setLocale(String code) {
    return _localSource.setLocaleCode(code);
  }
}
