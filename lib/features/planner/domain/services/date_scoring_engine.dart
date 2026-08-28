import '../models/optimization_strategy.dart';
import '../models/optimized_date_result.dart';
import '../models/raw_date_candidate.dart';
import 'date_normalization_engine.dart';

/// Weighted Scoring Engine for calculating travel score and ranking candidate dates.
class DateScoringEngine {
  /// Evaluates and scores all raw candidates against the selected [strategy].
  /// Returns a sorted list of [OptimizedDateResult] descending by total score.
  static List<OptimizedDateResult> evaluateAndRank({
    required List<RawDateCandidate> candidates,
    required OptimizationStrategy strategy,
  }) {
    if (candidates.isEmpty) return [];

    final bounds = CandidateSetBounds.fromCandidates(candidates);
    final weights = strategy.weights;

    final results = candidates.map((candidate) {
      final flightScore = DateNormalizationEngine.normalizeFlightPrice(
        candidate.flightPrice,
        bounds,
      );
      final hotelScore = DateNormalizationEngine.normalizeHotelPrice(
        candidate.hotelPrice,
        bounds,
      );
      final weatherScore = DateNormalizationEngine.normalizeWeather(
        candidate.weatherScore,
      );
      final durationScore = DateNormalizationEngine.normalizeDuration(
        candidate.travelDurationHours,
        bounds,
      );
      final transferScore = DateNormalizationEngine.normalizeTransfers(
        candidate.transferCount,
      );

      final totalScoreUnit = (flightScore * weights.flightWeight) +
          (hotelScore * weights.hotelWeight) +
          (weatherScore * weights.weatherWeight) +
          (durationScore * weights.durationWeight) +
          (transferScore * weights.transferWeight);

      final totalScore = (totalScoreUnit * 100.0).clamp(0.0, 100.0);

      return OptimizedDateResult(
        candidate: candidate,
        flightScore: flightScore,
        hotelScore: hotelScore,
        weatherScore: weatherScore,
        durationScore: durationScore,
        transferScore: transferScore,
        totalScore: totalScore,
      );
    }).toList();

    // Sort descending by totalScore
    results.sort((a, b) => b.totalScore.compareTo(a.totalScore));

    // Assign rank
    return List.generate(results.length, (index) {
      return results[index].copyWith(rank: index + 1);
    });
  }
}
