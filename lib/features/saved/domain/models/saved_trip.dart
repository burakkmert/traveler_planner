import 'package:flutter/foundation.dart';

/// Data class representing a saved trip route.
@immutable
class SavedTrip {
  final String id;
  final String title;
  final String destination;
  final String durationText;
  final String estimatedCost;
  final DateTime savedAt;

  const SavedTrip({
    required this.id,
    required this.title,
    required this.destination,
    required this.durationText,
    required this.estimatedCost,
    required this.savedAt,
  });
}
