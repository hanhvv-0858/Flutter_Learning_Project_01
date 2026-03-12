import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:example_flutter/providers/onboarding_provider.dart';

import '../mocks.mocks.dart';

void main() {
  late MockSettingsRepository mockRepo;

  setUp(() {
    mockRepo = MockSettingsRepository();
  });

  group('OnboardingProvider', () {
    test('initial state reads from repository', () {
      when(mockRepo.isOnboardingCompleted()).thenReturn(false);

      final provider = OnboardingProvider(mockRepo);

      expect(provider.isCompleted, isFalse);
      verify(mockRepo.isOnboardingCompleted()).called(1);
    });

    test('initial state is true when already completed', () {
      when(mockRepo.isOnboardingCompleted()).thenReturn(true);

      final provider = OnboardingProvider(mockRepo);

      expect(provider.isCompleted, isTrue);
    });

    test('completeOnboarding sets flag and notifies', () async {
      when(mockRepo.isOnboardingCompleted()).thenReturn(false);
      when(mockRepo.completeOnboarding()).thenAnswer((_) async {});

      final provider = OnboardingProvider(mockRepo);
      var notified = false;
      provider.addListener(() => notified = true);

      await provider.completeOnboarding();

      expect(provider.isCompleted, isTrue);
      expect(notified, isTrue);
      verify(mockRepo.completeOnboarding()).called(1);
    });
  });
}
