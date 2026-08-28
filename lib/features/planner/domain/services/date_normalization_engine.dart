import 'dart:math';
import '../models/raw_date_candidate.dart';

/// Structure holding min-max bounds for candidate set normalization.
class CandidateSetBounds {
  final double minFlightPrice;
  final double maxFlightPrice;
  final double minHotelPrice;
  final double maxHotelPrice;
  final double minDurationHours;
  final double maxDurationHours;

  const CandidateSetBounds({
    required this.minFlightPrice,
    required this.maxFlightPrice,
    required this.minHotelPrice,
    required this.maxHotelPrice,
    required this.minDurationHours,
    required this.maxDurationHours,
  });

  factory CandidateSetBounds.fromCandidates(List<RawDateCandidate> candidates) {
    if (candidates.isEmpty) {
      return const CandidateSetBounds(
        minFlightPrice: 0,
        maxFlightPrice: 1,
        minHotelPrice: 0,
        maxHotelPrice: 1,
        minDurationHours: 0,
        maxDurationHours: 1,
      );
    }

    double minFlight = candidates.first.flightPrice;
    double maxFlight = candidates.first.flightPrice;
    double minHotel = candidates.first.hotelPrice;
    double maxHotel = candidates.first.hotelPrice;
    double minDuration = candidates.first.travelDurationHours;
    double maxDuration = candidates.first.travelDurationHours;

    for (final c in candidates) {
      minFlight = min(minFlight, c.flightPrice);
      maxFlight = max(maxFlight, c.flightPrice);
      minHotel = min(minHotel, c.hotelPrice);
      maxHotel = max(maxHotel, c.hotelPrice);
      minDuration = min(minDuration, c.travelDurationHours);
      maxDuration = max(maxDuration, c.travelDurationHours);
    }

    return CandidateSetBounds(
      minFlightPrice: minFlight,
      maxFlightPrice: maxFlight,
      minHotelPrice: minHotel,
      maxHotelPrice: maxHotel,
      minDurationHours: minDuration,
      maxDurationHours: maxDuration,
    );
  }
}

/// Normalization engine performing Min-Max scaling for travel indicators.
class DateNormalizationEngine {
  static const double _epsilon = 0.0001;

  /// Normalizes flight price (Lower is better: 1.0 for cheapest, 0.0 for most expensive).
  static double normalizeFlightPrice(double price, CandidateSetBounds bounds) {
    final range = bounds.maxFlightPrice - bounds.minFlightPrice;
    if (range <= _epsilon) return 1.0;
    final normalizedCost = (price - bounds.minFlightPrice) / range;
    return (1.0 - normalizedCost).clamp(0.0, 1.0);
  }

  /// Normalizes hotel price (Lower is better).
  static double normalizeHotelPrice(double price, CandidateSetBounds bounds) {
    final range = bounds.maxHotelPrice - bounds.minHotelPrice;
    if (range <= _epsilon) return 1.0;
    final normalizedCost = (price - bounds.minHotelPrice) / range;
    return (1.0 - normalizedCost).clamp(0.0, 1.0);
  }

  /// Normalizes weather score (0-100 raw score to 0.0-1.0 scale).
  static double normalizeWeather(double rawWeatherScore) {
    return (rawWeatherScore / 100.0).clamp(0.0, 1.0);
  }

  /// Normalizes travel duration (Lower is better).
  static double normalizeDuration(double durationHours, CandidateSetBounds bounds) {
    final range = bounds.maxDurationHours - bounds.minDurationHours;
    if (range <= _epsilon) return 1.0;
    final normalizedDuration = (durationHours - bounds.minDurationHours) / range;
    return (1.0 - normalizedDuration).clamp(0.0, 1.0);
  }

  /// Normalizes transfer layovers (0 transfers = 1.0, 1 transfer = 0.6, 2+ transfers = 0.2).
  static double normalizeTransfers(int transferCount) {
    if (transferCount <= 0) return 1.0;
    if (transferCount == 1) return 0.6;
    return 0.2;
  }
}
