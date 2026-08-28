import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/search_params.dart';
import '../../domain/validators/search_validator.dart';
import 'home_search_state.dart';

/// Riverpod StateNotifier managing the travel search form, validations, and state.
class HomeSearchNotifier extends StateNotifier<HomeSearchState> {
  HomeSearchNotifier()
      : super(
          HomeSearchState(
            params: SearchParams(
              origin: 'İstanbul (IST)',
              destination: 'Roma (FCO)',
              startDate: DateTime.now().add(const Duration(days: 1)),
              endDate: DateTime.now().add(const Duration(days: 6)),
              passengerCount: 1,
            ),
          ),
        );

  void setOrigin(String origin) {
    state = state.copyWith(
      params: state.params.copyWith(origin: origin),
      clearValidationError: true,
    );
  }

  void setDestination(String destination) {
    state = state.copyWith(
      params: state.params.copyWith(destination: destination),
      clearValidationError: true,
    );
  }

  void swapLocations() {
    state = state.copyWith(
      params: state.params.copyWith(
        origin: state.params.destination,
        destination: state.params.origin,
      ),
      clearValidationError: true,
    );
  }

  void setDates(DateTime? start, DateTime? end) {
    state = state.copyWith(
      params: state.params.copyWith(startDate: start, endDate: end),
      clearValidationError: true,
    );
  }

  void setPassengerCount(int count) {
    state = state.copyWith(
      params: state.params.copyWith(passengerCount: count),
      clearValidationError: true,
    );
  }

  /// Validates search inputs.
  /// Returns `true` if search parameters are valid, `false` otherwise.
  bool validateAndSubmit() {
    final validation = SearchValidator.validate(state.params);

    if (!validation.isValid) {
      state = state.copyWith(
        validationError: validation.errorMessage,
        errorFieldKey: validation.fieldKey,
        isSearching: false,
      );
      return false;
    }

    state = state.copyWith(
      clearValidationError: true,
      isSearching: true,
    );
    return true;
  }

  void clearError() {
    state = state.copyWith(clearValidationError: true);
  }
}

/// Global Riverpod Provider for Home Search State.
final homeSearchProvider =
    StateNotifierProvider<HomeSearchNotifier, HomeSearchState>((ref) {
  return HomeSearchNotifier();
});
