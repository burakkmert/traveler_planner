import 'package:flutter_test/flutter_test.dart';
import 'package:travel_app/features/home/domain/models/search_params.dart';
import 'package:travel_app/features/home/domain/validators/search_validator.dart';

void main() {
  group('SearchValidator Security & Input Sanitization Tests', () {
    test('Strips HTML script tags and control characters safely', () {
      const maliciousInput = '<script>alert("hack")</script>İstanbul\x00\x1F';
      final sanitized = SearchValidator.sanitizeInput(maliciousInput);

      expect(sanitized, equals('alert("hack")İstanbul'));
      expect(sanitized.contains('<script>'), isFalse);
      expect(sanitized.contains('\x00'), isFalse);
    });

    test('Limits input string length to 100 chars max to prevent buffer overload', () {
      final longInput = 'A' * 150;
      final sanitized = SearchValidator.sanitizeInput(longInput);

      expect(sanitized.length, equals(100));
    });

    test('Validation fails when input consists entirely of malicious HTML tags', () {
      final params = SearchParams(
        origin: '<script></script>',
        destination: 'Roma',
        startDate: DateTime.now().add(const Duration(days: 1)),
        endDate: DateTime.now().add(const Duration(days: 5)),
        passengerCount: 1,
      );

      final result = SearchValidator.validate(params);
      expect(result.isValid, isFalse);
      expect(result.fieldKey, equals('origin'));
    });
  });
}
