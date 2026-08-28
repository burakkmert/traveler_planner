import 'dart:math';
import '../../../flight/domain/repositories/flight_repository.dart';
import '../../../hotel/domain/repositories/hotel_repository.dart';
import '../../../weather/domain/repositories/weather_repository.dart';
import '../../../home/domain/models/search_params.dart';
import '../models/optimization_strategy.dart';
import '../models/optimized_date_result.dart';
import '../models/raw_date_candidate.dart';
import 'date_scoring_engine.dart';

/// Service orchestrating candidate window generation and scoring evaluation.
/// Supports integration with [FlightRepository], [HotelRepository], and [WeatherRepository].
class TravelDateOptimizerService {
  final FlightRepository? flightRepository;
  final HotelRepository? hotelRepository;
  final WeatherRepository? weatherRepository;
  final Random _random;

  TravelDateOptimizerService({
    this.flightRepository,
    this.hotelRepository,
    this.weatherRepository,
    Random? random,
  }) : _random = random ?? Random(42);

  /// Evaluates optimal travel dates within [searchRangeStart] to [searchRangeEnd]
  /// for a trip lasting [stayDurationDays].
  Future<List<OptimizedDateResult>> findOptimalDates({
    required DateTime searchRangeStart,
    required DateTime searchRangeEnd,
    required int stayDurationDays,
    required OptimizationStrategy strategy,
    required String origin,
    required String destination,
  }) async {
    if (stayDurationDays <= 0 || searchRangeEnd.isBefore(searchRangeStart)) {
      return [];
    }

    final candidates = await _generateCandidates(
      searchRangeStart: searchRangeStart,
      searchRangeEnd: searchRangeEnd,
      stayDurationDays: stayDurationDays,
      origin: origin,
      destination: destination,
    );

    return DateScoringEngine.evaluateAndRank(
      candidates: candidates,
      strategy: strategy,
    );
  }

  Future<List<RawDateCandidate>> _generateCandidates({
    required DateTime searchRangeStart,
    required DateTime searchRangeEnd,
    required int stayDurationDays,
    required String origin,
    required String destination,
  }) async {
    final List<RawDateCandidate> list = [];
    DateTime currentStart = searchRangeStart;

    int index = 1;
    while (currentStart.add(Duration(days: stayDurationDays)).isBefore(
          searchRangeEnd.add(const Duration(days: 1)),
        )) {
      final startDate = DateTime(
        currentStart.year,
        currentStart.month,
        currentStart.day,
      );
      final endDate = startDate.add(Duration(days: stayDurationDays));

      final isWeekendDeparture =
          startDate.weekday == DateTime.friday || startDate.weekday == DateTime.saturday;

      double flightPrice = 3200 + (isWeekendDeparture ? 1400 : 0) + (index * 75 % 900).toDouble();
      double hotelPrice = (1200 + (isWeekendDeparture ? 400 : 0) + (index * 110 % 600)).toDouble() * stayDurationDays;
      double weatherScore = (72 + sin(index * 0.5) * 22).clamp(40.0, 98.0);
      int transferCount = (index % 3 == 0) ? 1 : ((index % 7 == 0) ? 2 : 0);
      double flightDurationHours = 3.5 + (transferCount * 2.5) + (index % 2 * 0.5);
      String weatherSummary = 'Güneşli ve Açık (24°C)';

      // Try live or repository queries if available
      if (flightRepository != null) {
        try {
          final flightOffers = await flightRepository!.searchFlights(
            SearchParams(
              origin: origin,
              destination: destination,
              startDate: startDate,
              endDate: endDate,
            ),
          );
          if (flightOffers.isNotEmpty) {
            flightPrice = flightOffers.first.price;
            transferCount = flightOffers.first.stopovers;
          }
        } catch (_) {}
      }

      if (hotelRepository != null) {
        try {
          final hotelOffers = await hotelRepository!.searchHotels(
            SearchParams(
              origin: origin,
              destination: destination,
              startDate: startDate,
              endDate: endDate,
            ),
          );
          if (hotelOffers.isNotEmpty) {
            hotelPrice = hotelOffers.first.price * stayDurationDays;
          }
        } catch (_) {}
      }

      if (weatherRepository != null) {
        try {
          final weatherData = await weatherRepository!.getWeatherForCity(
            destination,
            startDate: startDate,
          );
          weatherSummary = '${weatherData.weatherDescription} (${weatherData.temperature.toStringAsFixed(0)}°C)';
          // Normalize weather to 0-100 score based on temperature & precipitation
          if (weatherData.precipitationProbability < 20 && weatherData.temperature >= 20) {
            weatherScore = 95.0;
          } else if (weatherData.precipitationProbability > 50) {
            weatherScore = 50.0;
          }
        } catch (_) {}
      }

      if (weatherScore < 60 && weatherRepository == null) {
        weatherSummary = 'Parçalı Bulutlu, Rüzgarlı (17°C)';
      } else if (weatherScore > 85 && weatherRepository == null) {
        weatherSummary = 'İdeal Ilık Hava (23°C)';
      }

      list.add(
        RawDateCandidate(
          id: 'cand_$index',
          startDate: startDate,
          endDate: endDate,
          flightPrice: flightPrice,
          hotelPrice: hotelPrice,
          weatherScore: weatherScore,
          travelDurationHours: flightDurationHours,
          transferCount: transferCount,
          weatherSummary: weatherSummary,
        ),
      );

      currentStart = currentStart.add(const Duration(days: 2));
      index++;
    }

    return list;
  }
}
