import 'package:flutter/material.dart';

import '../data/repositories/settings_repository.dart';

/// Manages onboarding completion state.
class OnboardingProvider extends ChangeNotifier {
  final SettingsRepository _settingsRepository;

  bool _isCompleted;

  OnboardingProvider(this._settingsRepository)
    : _isCompleted = _settingsRepository.isOnboardingCompleted();

  bool get isCompleted => _isCompleted;

  Future<void> completeOnboarding() async {
    await _settingsRepository.completeOnboarding();
    _isCompleted = true;
    notifyListeners();
  }
}
