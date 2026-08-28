import 'package:flutter/foundation.dart';
import '../../domain/models/search_params.dart';

/// Immutable state representation for Home Travel Search.
@immutable
class HomeSearchState {
  final SearchParams params;
  final String? validationError;
  final String? errorFieldKey;
  final bool isSearching;

  const HomeSearchState({
    required this.params,
    this.validationError,
    this.errorFieldKey,
    this.isSearching = false,
  });

  HomeSearchState copyWith({
    SearchParams? params,
    String? validationError,
    String? errorFieldKey,
    bool? isSearching,
    bool clearValidationError = false,
  }) {
    return HomeSearchState(
      params: params ?? this.params,
      validationError: clearValidationError
          ? null
          : (validationError ?? this.validationError),
      errorFieldKey:
          clearValidationError ? null : (errorFieldKey ?? this.errorFieldKey),
      isSearching: isSearching ?? this.isSearching,
    );
  }
}
