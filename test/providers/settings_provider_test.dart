import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:example_flutter/providers/settings_provider.dart';

import '../mocks.mocks.dart';

void main() {
  late MockSettingsRepository mockRepo;

  setUp(() {
    mockRepo = MockSettingsRepository();
  });

  group('SettingsProvider', () {
    test('initial locale from repository', () {
      when(mockRepo.getLocale()).thenReturn('en');

      final provider = SettingsProvider(mockRepo);

      expect(provider.locale, const Locale('en'));
    });

    test('setLocale updates locale and notifies', () async {
      when(mockRepo.getLocale()).thenReturn('en');
      when(mockRepo.setLocale('vi')).thenAnswer((_) async {});

      final provider = SettingsProvider(mockRepo);
      var notified = false;
      provider.addListener(() => notified = true);

      await provider.setLocale('vi');

      expect(provider.locale, const Locale('vi'));
      expect(notified, isTrue);
      verify(mockRepo.setLocale('vi')).called(1);
    });
  });
}
