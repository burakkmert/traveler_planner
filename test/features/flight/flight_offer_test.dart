import 'package:flutter_test/flutter_test.dart';
import 'package:travel_app/features/flight/domain/models/flight_offer.dart';

void main() {
  group('FlightOffer Parser Unit Tests', () {
    test('Parses Amadeus Flight Offer JSON payload accurately', () {
      final mockAmadeusJson = {
        'id': '101',
        'price': {
          'grandTotal': '3450.50',
          'currency': 'TRY',
        },
        'itineraries': [
          {
            'duration': 'PT2H40M',
            'segments': [
              {
                'carrierCode': 'TK',
                'number': '1865',
                'departure': {
                  'iataCode': 'IST',
                  'at': '2026-09-10T08:45:00',
                },
                'arrival': {
                  'iataCode': 'FCO',
                  'at': '2026-09-10T11:25:00',
                },
              }
            ],
          }
        ],
      };

      final offer = FlightOffer.fromAmadeusJson(
          mockAmadeusJson, 'İstanbul (IST)', 'Roma (FCO)');

      expect(offer.id, equals('101'));
      expect(offer.airlineName, equals('Türk Hava Yolları'));
      expect(offer.airlineCode, equals('TK'));
      expect(offer.flightNumber, equals('TK 1865'));
      expect(offer.originCode, equals('IST'));
      expect(offer.destinationCode, equals('FCO'));
      expect(offer.durationText, equals('2sa 40dk'));
      expect(offer.stopovers, equals(0));
      expect(offer.price, equals(3450.50));
      expect(offer.currency, equals('TRY'));
    });
  });
}
