import 'package:flutter_test/flutter_test.dart';
import 'package:travel_app/features/hotel/domain/models/hotel_offer.dart';

void main() {
  group('HotelOffer Parser Unit Tests', () {
    test('Parses Amadeus Hotel Offer JSON payload accurately', () {
      final mockAmadeusJson = {
        'hotel': {
          'hotelId': 'HT101',
          'name': 'Grand Roma Luxury Hotel',
          'rating': 4.8,
          'address': {
            'lines': ['Piazza Venezia 12'],
          },
        },
        'offers': [
          {
            'price': {
              'total': '4250.00',
              'currency': 'TRY',
            },
            'room': {
              'typeEstimated': {
                'category': 'Deluxe Room',
                'bedType': 'King',
              },
            },
          }
        ],
      };

      final offer =
          HotelOffer.fromAmadeusJson(mockAmadeusJson, 'Roma (FCO)');

      expect(offer.id, equals('HT101'));
      expect(offer.hotelName, equals('Grand Roma Luxury Hotel'));
      expect(offer.city, equals('Roma (FCO)'));
      expect(offer.address, equals('Piazza Venezia 12'));
      expect(offer.rating, equals(4.8));
      expect(offer.price, equals(4250.00));
      expect(offer.currency, equals('TRY'));
      expect(offer.roomInfo, contains('Deluxe Room'));
    });
  });
}
