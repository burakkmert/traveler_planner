import 'package:flutter_test/flutter_test.dart';
import 'package:travel_app/features/home/domain/models/search_params.dart';
import 'package:travel_app/features/home/domain/validators/search_validator.dart';

void main() {
  group('SearchValidator Unit Tests', () {
    test('Valid parameters return success', () {
      final params = SearchParams(
        origin: 'İstanbul',
        destination: 'Roma',
        startDate: DateTime.now().add(const Duration(days: 1)),
        endDate: DateTime.now().add(const Duration(days: 5)),
        passengerCount: 2,
      );

      final result = SearchValidator.validate(params);

      expect(result.isValid, isTrue);
      expect(result.errorMessage, isNull);
    });

    test('Empty origin returns failure', () {
      final params = SearchParams(
        origin: '   ',
        destination: 'Roma',
        startDate: DateTime.now().add(const Duration(days: 1)),
        endDate: DateTime.now().add(const Duration(days: 5)),
        passengerCount: 1,
      );

      final result = SearchValidator.validate(params);

      expect(result.isValid, isFalse);
      expect(result.errorMessage, equals('Kalkış noktası boş bırakılamaz.'));
      expect(result.fieldKey, equals('origin'));
    });

    test('Empty destination returns failure', () {
      final params = SearchParams(
        origin: 'İstanbul',
        destination: '',
        startDate: DateTime.now().add(const Duration(days: 1)),
        endDate: DateTime.now().add(const Duration(days: 5)),
        passengerCount: 1,
      );

      final result = SearchValidator.validate(params);

      expect(result.isValid, isFalse);
      expect(result.errorMessage, equals('Varış noktası boş bırakılamaz.'));
      expect(result.fieldKey, equals('destination'));
    });

    test('Same origin and destination returns failure', () {
      final params = SearchParams(
        origin: 'İstanbul',
        destination: 'istanbul',
        startDate: DateTime.now().add(const Duration(days: 1)),
        endDate: DateTime.now().add(const Duration(days: 5)),
        passengerCount: 1,
      );

      final result = SearchValidator.validate(params);

      expect(result.isValid, isFalse);
      expect(result.errorMessage, equals('Kalkış ve varış noktası aynı olamaz.'));
    });

    test('Past start date returns failure', () {
      final params = SearchParams(
        origin: 'İstanbul',
        destination: 'Roma',
        startDate: DateTime.now().subtract(const Duration(days: 2)),
        endDate: DateTime.now().add(const Duration(days: 5)),
        passengerCount: 1,
      );

      final result = SearchValidator.validate(params);

      expect(result.isValid, isFalse);
      expect(
          result.errorMessage, equals('Başlangıç tarihi geçmiş bir tarih olamaz.'));
    });

    test('End date before start date returns failure', () {
      final start = DateTime.now().add(const Duration(days: 5));
      final end = DateTime.now().add(const Duration(days: 2));

      final params = SearchParams(
        origin: 'İstanbul',
        destination: 'Roma',
        startDate: start,
        endDate: end,
        passengerCount: 1,
      );

      final result = SearchValidator.validate(params);

      expect(result.isValid, isFalse);
      expect(result.errorMessage,
          equals('Dönüş tarihi başlangıç tarihinden önce olamaz.'));
    });

    test('Passenger count out of range (0) returns failure', () {
      final params = SearchParams(
        origin: 'İstanbul',
        destination: 'Roma',
        startDate: DateTime.now().add(const Duration(days: 1)),
        endDate: DateTime.now().add(const Duration(days: 5)),
        passengerCount: 0,
      );

      final result = SearchValidator.validate(params);

      expect(result.isValid, isFalse);
      expect(result.errorMessage,
          equals('Yolcu sayısı 1 ile 9 kişi arasında olmalıdır.'));
    });
  });
}
