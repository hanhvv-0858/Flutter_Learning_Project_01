import 'package:flutter_test/flutter_test.dart';
import 'package:example_flutter/utils/api_exception.dart';

void main() {
  group('ApiException', () {
    test('toString returns formatted message', () {
      const e = ApiException(404, 'Not found');
      expect(e.toString(), 'ApiException(404): Not found');
    });

    test('isUnauthorized checks 401', () {
      expect(const ApiException(401, '').isUnauthorized, isTrue);
      expect(const ApiException(403, '').isUnauthorized, isFalse);
    });

    test('isForbidden checks 403', () {
      expect(const ApiException(403, '').isForbidden, isTrue);
      expect(const ApiException(401, '').isForbidden, isFalse);
    });

    test('isRateLimited checks 429', () {
      expect(const ApiException(429, '').isRateLimited, isTrue);
      expect(const ApiException(200, '').isRateLimited, isFalse);
    });

    test('isServerError checks >= 500', () {
      expect(const ApiException(500, '').isServerError, isTrue);
      expect(const ApiException(503, '').isServerError, isTrue);
      expect(const ApiException(499, '').isServerError, isFalse);
    });

    test('implements Exception', () {
      const e = ApiException(400, 'Bad');
      expect(e, isA<Exception>());
    });
  });
}
