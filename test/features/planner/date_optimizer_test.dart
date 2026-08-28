import 'package:flutter_test/flutter_test.dart';
import 'package:travel_app/features/planner/domain/models/optimization_strategy.dart';
import 'package:travel_app/features/planner/domain/models/raw_date_candidate.dart';
import 'package:travel_app/features/planner/domain/services/date_normalization_engine.dart';
import 'package:travel_app/features/planner/domain/services/date_scoring_engine.dart';
import 'package:travel_app/features/planner/domain/services/travel_date_optimizer_service.dart';

void main() {
  group('Travel Date Optimizer Unit Tests', () {
    final candidateCheap = RawDateCandidate(
      id: 'c_cheap',
      startDate: DateTime(2026, 9, 1),
      endDate: DateTime(2026, 9, 6),
      flightPrice: 2000.0,
      hotelPrice: 3000.0,
      weatherScore: 50.0,
      travelDurationHours: 8.0,
      transferCount: 2,
      weatherSummary: 'Bulutlu',
    );

    final candidateSunny = RawDateCandidate(
      id: 'c_sunny',
      startDate: DateTime(2026, 9, 7),
      endDate: DateTime(2026, 9, 12),
      flightPrice: 4500.0,
      hotelPrice: 6000.0,
      weatherScore: 98.0,
      travelDurationHours: 6.0,
      transferCount: 1,
      weatherSummary: 'Güneşli',
    );

    final candidateFast = RawDateCandidate(
      id: 'c_fast',
      startDate: DateTime(2026, 9, 13),
      endDate: DateTime(2026, 9, 18),
      flightPrice: 5000.0,
      hotelPrice: 7000.0,
      weatherScore: 70.0,
      travelDurationHours: 3.5,
      transferCount: 0,
      weatherSummary: 'Açık',
    );

    final testCandidates = [candidateCheap, candidateSunny, candidateFast];

    test('Min-Max Normalization accurately scales prices to [0.0 - 1.0]', () {
      final bounds = CandidateSetBounds.fromCandidates(testCandidates);

      expect(bounds.minFlightPrice, equals(2000.0));
      expect(bounds.maxFlightPrice, equals(5000.0));

      final cheapFlightScore = DateNormalizationEngine.normalizeFlightPrice(
        candidateCheap.flightPrice,
        bounds,
      );
      final expensiveFlightScore = DateNormalizationEngine.normalizeFlightPrice(
        candidateFast.flightPrice,
        bounds,
      );

      expect(cheapFlightScore, equals(1.0)); // Lowest price gets max score
      expect(expensiveFlightScore, equals(0.0)); // Highest price gets 0 score
    });

    test('Cheapest Strategy prioritizes lowest flight + hotel cost', () {
      final results = DateScoringEngine.evaluateAndRank(
        candidates: testCandidates,
        strategy: OptimizationStrategy.cheapest,
      );

      expect(results.first.candidate.id, equals('c_cheap'));
      expect(results.first.rank, equals(1));
    });

    test('Best Weather Strategy prioritizes candidate with highest weather score', () {
      final results = DateScoringEngine.evaluateAndRank(
        candidates: testCandidates,
        strategy: OptimizationStrategy.bestWeather,
      );

      expect(results.first.candidate.id, equals('c_sunny'));
      expect(results.first.rank, equals(1));
    });

    test('Fastest Strategy prioritizes shortest duration and 0 layovers', () {
      final results = DateScoringEngine.evaluateAndRank(
        candidates: testCandidates,
        strategy: OptimizationStrategy.fastest,
      );

      expect(results.first.candidate.id, equals('c_fast'));
      expect(results.first.rank, equals(1));
    });

    test('Single candidate edge case handles zero division without crash', () {
      final singleList = [candidateCheap];
      final results = DateScoringEngine.evaluateAndRank(
        candidates: singleList,
        strategy: OptimizationStrategy.balanced,
      );

      expect(results.length, equals(1));
      expect(results.first.totalScore, greaterThan(0.0));
    });

    test('TravelDateOptimizerService generates and ranks window candidates', () async {
      final service = TravelDateOptimizerService();
      final results = await service.findOptimalDates(
        searchRangeStart: DateTime.now().add(const Duration(days: 1)),
        searchRangeEnd: DateTime.now().add(const Duration(days: 20)),
        stayDurationDays: 5,
        strategy: OptimizationStrategy.balanced,
        origin: 'İstanbul',
        destination: 'Roma',
      );

      expect(results, isNotEmpty);
      expect(results.first.totalScore, greaterThanOrEqualTo(results.last.totalScore));
    });
  });
}
