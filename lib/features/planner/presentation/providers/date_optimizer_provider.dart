import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/optimization_strategy.dart';
import '../../domain/models/optimized_date_result.dart';
import '../../domain/services/travel_date_optimizer_service.dart';
import 'date_optimizer_state.dart';

class DateOptimizerNotifier extends StateNotifier<DateOptimizerState> {
  final TravelDateOptimizerService _optimizerService;

  DateOptimizerNotifier(this._optimizerService)
      : super(
          DateOptimizerState(
            searchRangeStart: DateTime.now().add(const Duration(days: 2)),
            searchRangeEnd: DateTime.now().add(const Duration(days: 24)),
            stayDurationDays: 5,
            selectedStrategy: OptimizationStrategy.balanced,
            origin: 'İstanbul (IST)',
            destination: 'Roma (FCO)',
          ),
        ) {
    calculateOptimalDates();
  }

  void setStrategy(OptimizationStrategy strategy) {
    if (state.selectedStrategy == strategy) return;
    state = state.copyWith(selectedStrategy: strategy);
    calculateOptimalDates();
  }

  void setStayDuration(int days) {
    if (days < 1 || days > 30) return;
    state = state.copyWith(stayDurationDays: days);
    calculateOptimalDates();
  }

  void setLocations({required String origin, required String destination}) {
    state = state.copyWith(origin: origin, destination: destination);
    calculateOptimalDates();
  }

  void setDateRange(DateTime start, DateTime end) {
    state = state.copyWith(searchRangeStart: start, searchRangeEnd: end);
    calculateOptimalDates();
  }

  void selectResult(OptimizedDateResult result) {
    state = state.copyWith(selectedResult: result);
  }

  Future<void> calculateOptimalDates() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final results = await _optimizerService.findOptimalDates(
        searchRangeStart: state.searchRangeStart,
        searchRangeEnd: state.searchRangeEnd,
        stayDurationDays: state.stayDurationDays,
        strategy: state.selectedStrategy,
        origin: state.origin,
        destination: state.destination,
      );

      state = state.copyWith(
        results: results,
        isLoading: false,
        selectedResult: results.isNotEmpty ? results.first : null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Uygun seyahat tarihleri hesaplanırken bir hata oluştu.',
      );
    }
  }
}

final optimizerServiceProvider = Provider<TravelDateOptimizerService>((ref) {
  return TravelDateOptimizerService();
});

final dateOptimizerProvider =
    StateNotifierProvider<DateOptimizerNotifier, DateOptimizerState>((ref) {
  final service = ref.watch(optimizerServiceProvider);
  return DateOptimizerNotifier(service);
});
