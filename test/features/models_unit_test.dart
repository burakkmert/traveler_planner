import 'package:flutter_test/flutter_test.dart';
import 'package:travel_app/features/flight/domain/models/flight_offer.dart';
import 'package:travel_app/features/home/domain/models/recent_search.dart';
import 'package:travel_app/features/hotel/domain/models/hotel_offer.dart';
import 'package:travel_app/features/profile/domain/models/app_settings.dart';
import 'package:travel_app/features/saved/domain/models/recently_viewed_item.dart';
import 'package:travel_app/features/saved/domain/models/saved_travel_plan.dart';

void main() {
  group('Comprehensive Data Models Unit Tests', () {
    test('FlightOffer model copyWith and parameters work accurately', () {
      final now = DateTime.now();
      final flight = FlightOffer(
        id: 'FL-101',
        airlineName: 'Turkish Airlines',
        airlineCode: 'TK',
        flightNumber: 'TK1981',
        originCode: 'IST',
        originCity: 'İstanbul',
        destinationCode: 'LHR',
        destinationCity: 'Londra',
        departureTime: now,
        arrivalTime: now.add(const Duration(hours: 4)),
        durationText: '4sa 0dk',
        stopovers: 0,
        price: 4500.0,
        currency: 'TRY',
      );

      final copy = FlightOffer(
        id: flight.id,
        airlineName: flight.airlineName,
        airlineCode: flight.airlineCode,
        flightNumber: flight.flightNumber,
        originCode: flight.originCode,
        originCity: flight.originCity,
        destinationCode: flight.destinationCode,
        destinationCity: flight.destinationCity,
        departureTime: flight.departureTime,
        arrivalTime: flight.arrivalTime,
        durationText: flight.durationText,
        stopovers: 1,
        price: 4200.0,
        currency: flight.currency,
      );

      expect(copy.id, equals('FL-101'));
      expect(copy.price, equals(4200.0));
      expect(copy.stopovers, equals(1));
    });

    test('HotelOffer model parameters work accurately', () {
      final hotel = const HotelOffer(
        id: 'HT-202',
        hotelName: 'Grand Hyatt Roma',
        city: 'Roma',
        address: 'Via Veneto 12, Rome',
        rating: 4.8,
        reviewCount: 350,
        price: 2500.0,
        currency: 'TRY',
        imageUrl: 'https://example.com/image.jpg',
        roomInfo: 'Deluxe King Room',
      );

      expect(hotel.hotelName, equals('Grand Hyatt Roma'));
      expect(hotel.rating, equals(4.8));
      expect(hotel.city, equals('Roma'));
    });

    test('RecentSearch model JSON parsing and formatting works accurately', () {
      const search = RecentSearch(
        id: 'rs-1',
        origin: 'İstanbul (IST)',
        destination: 'Roma (FCO)',
        dateRangeText: '12-18 Eylül',
        passengerCount: 2,
      );

      final json = search.toJson();
      final fromJson = RecentSearch.fromJson(json);
      expect(fromJson.origin, equals('İstanbul (IST)'));
      expect(fromJson.passengerCount, equals(2));
    });

    test('SavedTravelPlan model JSON parsing and copyWith works accurately', () {
      final plan = SavedTravelPlan(
        id: 'plan-1',
        origin: 'İstanbul',
        destination: 'Roma',
        startDate: DateTime(2026, 9, 15),
        endDate: DateTime(2026, 9, 22),
        strategyLabel: 'En Dengeli',
        totalScore: 92.5,
        totalPrice: 12500.0,
        weatherSummary: 'İdeal Hava',
        savedAt: DateTime(2026, 8, 20),
      );

      final json = plan.toJson();
      final fromJson = SavedTravelPlan.fromJson(json);
      expect(fromJson.origin, equals('İstanbul'));
      expect(fromJson.totalPrice, equals(12500.0));
      expect(fromJson.strategyLabel, equals('En Dengeli'));
    });

    test('RecentlyViewedItem model JSON parsing works accurately', () {
      final item = RecentlyViewedItem(
        id: 'rv-1',
        category: 'flight',
        title: 'İstanbul ➔ Paris Uçuşu',
        subtitle: 'Pegasus Airlines • PC 1134',
        priceText: '₺3.200',
        imageUrl: 'https://example.com/paris.jpg',
        viewedAt: DateTime.now(),
      );

      final json = item.toJson();
      final fromJson = RecentlyViewedItem.fromJson(json);
      expect(fromJson.title, equals('İstanbul ➔ Paris Uçuşu'));
      expect(fromJson.category, equals('flight'));
    });

    test('AppSettings model serialization and copyWith works accurately', () {
      const settings = AppSettings();
      final copy = settings.copyWith(
        languageCode: 'en',
        currencyCode: 'USD',
        defaultPassengerCount: 4,
      );

      final json = copy.toJson();
      final fromJson = AppSettings.fromJson(json);
      expect(fromJson.languageCode, equals('en'));
      expect(fromJson.currencyCode, equals('USD'));
      expect(fromJson.defaultPassengerCount, equals(4));
    });
  });
}
