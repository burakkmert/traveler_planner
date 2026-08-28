import 'raw_date_candidate.dart';

/// Represents an evaluated, normalized, and scored travel date recommendation.
class OptimizedDateResult {
  final RawDateCandidate candidate;
  final double flightScore; // 0.0 - 1.0
  final double hotelScore; // 0.0 - 1.0
  final double weatherScore; // 0.0 - 1.0
  final double durationScore; // 0.0 - 1.0
  final double transferScore; // 0.0 - 1.0
  final double totalScore; // 0.0 - 100.0
  final int rank;

  const OptimizedDateResult({
    required this.candidate,
    required this.flightScore,
    required this.hotelScore,
    required this.weatherScore,
    required this.durationScore,
    required this.transferScore,
    required this.totalScore,
    this.rank = 0,
  });

  OptimizedDateResult copyWith({
    RawDateCandidate? candidate,
    double? flightScore,
    double? hotelScore,
    double? weatherScore,
    double? durationScore,
    double? transferScore,
    double? totalScore,
    int? rank,
  }) {
    return OptimizedDateResult(
      candidate: candidate ?? this.candidate,
      flightScore: flightScore ?? this.flightScore,
      hotelScore: hotelScore ?? this.hotelScore,
      weatherScore: weatherScore ?? this.weatherScore,
      durationScore: durationScore ?? this.durationScore,
      transferScore: transferScore ?? this.transferScore,
      totalScore: totalScore ?? this.totalScore,
      rank: rank ?? this.rank,
    );
  }
}
