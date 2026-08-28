import 'package:flutter_test/flutter_test.dart';
import 'package:travel_app/core/network/network_exception.dart';
import 'package:travel_app/features/flight/domain/models/flight_offer.dart';
import 'package:travel_app/features/flight/domain/repositories/flight_repository.dart';
import 'package:travel_app/features/home/domain/models/search_params.dart';
import 'package:travel_app/features/hotel/domain/models/hotel_offer.dart';
import 'package:travel_app/features/hotel/domain/repositories/hotel_repository.dart';
import 'package:travel_app/features/planner/domain/models/optimization_strategy.dart';
import 'package:travel_app/features/planner/domain/models/raw_date_candidate.dart';
import 'package:travel_app/features/planner/domain/services/date_normalization_engine.dart';
import 'package:travel_app/features/planner/domain/services/date_scoring_engine.dart';
import 'package:travel_app/features/planner/domain/services/travel_date_optimizer_service.dart';
import 'package:travel_app/features/weather/domain/models/weather_data.dart';
import 'package:travel_app/features/weather/domain/repositories/weather_repository.dart';

// Mock Repositories for Edge Cases Testing
class MockEmptyFlightRepo implements FlightRepository {
  @override
  Future<List<FlightOffer>> searchFlights(SearchParams params) async => [];
}

class MockErrorFlightRepo implements FlightRepository {
  @override
  Future<List<FlightOffer>> searchFlights(SearchParams params) async {
    throw const NetworkException(message: 'Sunucu Hatası (500)', statusCode: 500);
  }
}

class MockEmptyHotelRepo implements HotelRepository {
  @override
  Future<List<HotelOffer>> searchHotels(SearchParams params) async => [];
}

class MockErrorHotelRepo implements HotelRepository {
  @override
  Future<List<HotelOffer>> searchHotels(SearchParams params) async {
    throw const NetworkException(message: 'Servis Kullanılamıyor (503)', statusCode: 503);
  }
}

class MockErrorWeatherRepo implements WeatherRepository {
  @override
  Future<WeatherData> getWeatherForCity(
    String cityName, {
    double? lat,
    double? lng,
    DateTime? startDate,
  }) async {
    throw Exception('Weather API Unavailable');
  }
}

void main() {
  group('Travel Date Optimizer Edge Cases Tests', () {
    late DateTime now;

    setUp(() {
      now = DateTime.now();
    });

    test('Edge Case 1: Empty API response falls back safely without crashing', () async {
      final service = TravelDateOptimizerService(
        flightRepository: MockEmptyFlightRepo(),
        hotelRepository: MockEmptyHotelRepo(),
      );

      final results = await service.findOptimalDates(
        searchRangeStart: now.add(const Duration(days: 1)),
        searchRangeEnd: now.add(const Duration(days: 10)),
        stayDurationDays: 3,
        strategy: OptimizationStrategy.balanced,
        origin: 'IST',
        destination: 'ROM',
      );

      expect(results, isNotEmpty);
      expect(results.first.rank, equals(1));
      expect(results.first.totalScore, greaterThan(0));
    });

    test('Edge Case 2: API throws NetworkException or 500 error gracefully without unhandled exception', () async {
      final service = TravelDateOptimizerService(
        flightRepository: MockErrorFlightRepo(),
        hotelRepository: MockErrorHotelRepo(),
        weatherRepository: MockErrorWeatherRepo(),
      );

      final results = await service.findOptimalDates(
        searchRangeStart: now.add(const Duration(days: 1)),
        searchRangeEnd: now.add(const Duration(days: 10)),
        stayDurationDays: 3,
        strategy: OptimizationStrategy.cheapest,
        origin: 'IST',
        destination: 'PAR',
      );

      expect(results, isNotEmpty);
      expect(results.first.candidate.totalPrice, greaterThan(0));
    });

    test('Edge Case 3: Zero or identical prices scale smoothly without division by zero NaN', () {
      final candidates = [
        RawDateCandidate(
          id: '1',
          startDate: now,
          endDate: now.add(const Duration(days: 3)),
          flightPrice: 0.0,
          hotelPrice: 0.0,
          weatherScore: 80.0,
          travelDurationHours: 2.0,
          transferCount: 0,
          weatherSummary: 'Güneşli (24°C)',
        ),
        RawDateCandidate(
          id: '2',
          startDate: now.add(const Duration(days: 2)),
          endDate: now.add(const Duration(days: 5)),
          flightPrice: 0.0,
          hotelPrice: 0.0,
          weatherScore: 80.0,
          travelDurationHours: 2.0,
          transferCount: 0,
          weatherSummary: 'Güneşli (24°C)',
        ),
      ];

      final bounds = CandidateSetBounds.fromCandidates(candidates);
      final normFlightPrice = DateNormalizationEngine.normalizeFlightPrice(candidates[0].flightPrice, bounds);

      expect(normFlightPrice.isNaN, isFalse);
      expect(normFlightPrice.isInfinite, isFalse);

      final evaluated = DateScoringEngine.evaluateAndRank(
        candidates: candidates,
        strategy: OptimizationStrategy.balanced,
      );
      expect(evaluated.length, equals(2));
      expect(evaluated.first.totalScore.isNaN, isFalse);
    });

    test('Edge Case 4: Invalid date ranges (end before start or duration <= 0) return empty list safely', () async {
      final service = TravelDateOptimizerService();

      final invalidEndBeforeStart = await service.findOptimalDates(
        searchRangeStart: now.add(const Duration(days: 10)),
        searchRangeEnd: now.add(const Duration(days: 2)),
        stayDurationDays: 3,
        strategy: OptimizationStrategy.balanced,
        origin: 'IST',
        destination: 'ROM',
      );

      expect(invalidEndBeforeStart, isEmpty);

      final invalidZeroDuration = await service.findOptimalDates(
        searchRangeStart: now,
        searchRangeEnd: now.add(const Duration(days: 10)),
        stayDurationDays: 0,
        strategy: OptimizationStrategy.balanced,
        origin: 'IST',
        destination: 'ROM',
      );

      expect(invalidZeroDuration, isEmpty);
    });

    test('Edge Case 5: Large search window (100+ candidates) scores and ranks efficiently', () async {
      final service = TravelDateOptimizerService();

      final results = await service.findOptimalDates(
        searchRangeStart: now.add(const Duration(days: 1)),
        searchRangeEnd: now.add(const Duration(days: 180)), // 6-month window
        stayDurationDays: 5,
        strategy: OptimizationStrategy.cheapest,
        origin: 'IST',
        destination: 'ROM',
      );

      expect(results.length, greaterThan(30));
      expect(results.first.rank, equals(1));
      // Verify ranks are strictly ascending 1, 2, 3...
      for (int i = 0; i < results.length; i++) {
        expect(results[i].rank, equals(i + 1));
      }
    });
  });
}
