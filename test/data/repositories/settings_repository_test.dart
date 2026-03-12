import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:example_flutter/data/repositories/settings_repository.dart';

import '../../mocks.mocks.dart';

void main() {
  late MockPreferencesLocalSource mockSource;
  late SettingsRepository repo;

  setUp(() {
    mockSource = MockPreferencesLocalSource();
    repo = SettingsRepository(mockSource);
  });

  group('isOnboardingCompleted', () {
    test('delegates to source', () {
      when(mockSource.getOnboardingCompleted()).thenReturn(true);
      expect(repo.isOnboardingCompleted(), isTrue);
      verify(mockSource.getOnboardingCompleted()).called(1);
    });
  });

  group('completeOnboarding', () {
    test('sets onboarding to true', () async {
      when(mockSource.setOnboardingCompleted(true)).thenAnswer((_) async {});

      await repo.completeOnboarding();

      verify(mockSource.setOnboardingCompleted(true)).called(1);
    });
  });

  group('getLocale', () {
    test('delegates to source', () {
      when(mockSource.getLocaleCode()).thenReturn('vi');
      expect(repo.getLocale(), 'vi');
    });
  });

  group('setLocale', () {
    test('delegates to source', () async {
      when(mockSource.setLocaleCode('vi')).thenAnswer((_) async {});

      await repo.setLocale('vi');

      verify(mockSource.setLocaleCode('vi')).called(1);
    });
  });
}
