import 'package:flutter/foundation.dart';

/// Data class representing a recent travel search history entry.
@immutable
class RecentSearch {
  final String id;
  final String origin;
  final String destination;
  final String dateRangeText;
  final int passengerCount;

  const RecentSearch({
    required this.id,
    required this.origin,
    required this.destination,
    required this.dateRangeText,
    required this.passengerCount,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'origin': origin,
      'destination': destination,
      'dateRangeText': dateRangeText,
      'passengerCount': passengerCount,
    };
  }

  factory RecentSearch.fromJson(Map<String, dynamic> json) {
    return RecentSearch(
      id: json['id'] as String,
      origin: json['origin'] as String,
      destination: json['destination'] as String,
      dateRangeText: json['dateRangeText'] as String,
      passengerCount: json['passengerCount'] as int? ?? 1,
    );
  }
}
