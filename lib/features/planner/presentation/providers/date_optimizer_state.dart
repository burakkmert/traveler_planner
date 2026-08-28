import '../../domain/models/optimization_strategy.dart';
import '../../domain/models/optimized_date_result.dart';

/// State representation for Date Optimizer screen & feature.
class DateOptimizerState {
  final DateTime searchRangeStart;
  final DateTime searchRangeEnd;
  final int stayDurationDays;
  final OptimizationStrategy selectedStrategy;
  final String origin;
  final String destination;
  final List<OptimizedDateResult> results;
  final bool isLoading;
  final String? errorMessage;
  final OptimizedDateResult? selectedResult;

  const DateOptimizerState({
    required this.searchRangeStart,
    required this.searchRangeEnd,
    required this.stayDurationDays,
    required this.selectedStrategy,
    required this.origin,
    required this.destination,
    this.results = const [],
    this.isLoading = false,
    this.errorMessage,
    this.selectedResult,
  });

  DateOptimizerState copyWith({
    DateTime? searchRangeStart,
    DateTime? searchRangeEnd,
    int? stayDurationDays,
    OptimizationStrategy? selectedStrategy,
    String? origin,
    String? destination,
    List<OptimizedDateResult>? results,
    bool? isLoading,
    String? errorMessage,
    OptimizedDateResult? selectedResult,
    bool clearSelectedResult = false,
  }) {
    return DateOptimizerState(
      searchRangeStart: searchRangeStart ?? this.searchRangeStart,
      searchRangeEnd: searchRangeEnd ?? this.searchRangeEnd,
      stayDurationDays: stayDurationDays ?? this.stayDurationDays,
      selectedStrategy: selectedStrategy ?? this.selectedStrategy,
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      results: results ?? this.results,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedResult: clearSelectedResult
          ? null
          : (selectedResult ?? this.selectedResult),
    );
  }
}
