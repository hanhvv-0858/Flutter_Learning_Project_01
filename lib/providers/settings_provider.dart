import 'package:flutter/material.dart';

import '../data/repositories/settings_repository.dart';

/// Manages locale and app-wide settings state.
class SettingsProvider extends ChangeNotifier {
  final SettingsRepository _settingsRepository;
  late Locale _locale;

  SettingsProvider(this._settingsRepository) {
    final code = _settingsRepository.getLocale();
    _locale = Locale(code);
  }

  Locale get locale => _locale;

  Future<void> setLocale(String code) async {
    await _settingsRepository.setLocale(code);
    _locale = Locale(code);
    notifyListeners();
  }
}
