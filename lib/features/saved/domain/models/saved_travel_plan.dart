/// Represents a user-saved optimal travel date plan.
class SavedTravelPlan {
  final String id;
  final String origin;
  final String destination;
  final DateTime startDate;
  final DateTime endDate;
  final String strategyLabel;
  final double totalScore;
  final double totalPrice;
  final String weatherSummary;
  final DateTime savedAt;

  const SavedTravelPlan({
    required this.id,
    required this.origin,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.strategyLabel,
    required this.totalScore,
    required this.totalPrice,
    required this.weatherSummary,
    required this.savedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'origin': origin,
      'destination': destination,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'strategyLabel': strategyLabel,
      'totalScore': totalScore,
      'totalPrice': totalPrice,
      'weatherSummary': weatherSummary,
      'savedAt': savedAt.toIso8601String(),
    };
  }

  factory SavedTravelPlan.fromJson(Map<String, dynamic> json) {
    return SavedTravelPlan(
      id: json['id'] as String,
      origin: json['origin'] as String,
      destination: json['destination'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      strategyLabel: json['strategyLabel'] as String,
      totalScore: (json['totalScore'] as num).toDouble(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      weatherSummary: json['weatherSummary'] as String,
      savedAt: DateTime.parse(json['savedAt'] as String),
    );
  }
}
