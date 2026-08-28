import 'package:flutter/foundation.dart';

/// Data class holding user travel search inputs.
@immutable
class SearchParams {
  final String origin;
  final String destination;
  final DateTime? startDate;
  final DateTime? endDate;
  final int passengerCount;

  const SearchParams({
    this.origin = 'İstanbul (IST)',
    this.destination = 'Roma (FCO)',
    this.startDate,
    this.endDate,
    this.passengerCount = 1,
  });

  SearchParams copyWith({
    String? origin,
    String? destination,
    DateTime? startDate,
    DateTime? endDate,
    int? passengerCount,
  }) {
    return SearchParams(
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      passengerCount: passengerCount ?? this.passengerCount,
    );
  }
}
