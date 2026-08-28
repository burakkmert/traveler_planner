import 'package:flutter_test/flutter_test.dart';
import 'package:travel_app/features/map/domain/models/destination_location.dart';

void main() {
  group('DestinationLocation Model Unit Tests', () {
    test('Parses JSON accurately and formats coordinates correctly', () {
      final json = {
        'city': 'Roma',
        'country': 'İtalya',
        'countryCode': 'IT',
        'latitude': 41.9028,
        'longitude': 12.4964,
        'description': 'Tarihi kent',
        'popularAttractions': ['Kolezyum', 'Vatikan'],
      };

      final location = DestinationLocation.fromJson(json);

      expect(location.city, equals('Roma'));
      expect(location.country, equals('İtalya'));
      expect(location.countryCode, equals('IT'));
      expect(location.latitude, equals(41.9028));
      expect(location.longitude, equals(12.4964));
      expect(location.formattedCoordinates, contains('41.9028° N, 12.4964° E'));
      expect(location.popularAttractions.length, equals(2));
    });
  });
}
