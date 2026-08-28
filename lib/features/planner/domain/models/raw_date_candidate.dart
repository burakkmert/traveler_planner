/// Holds raw, un-normalized travel indicators for a specific date range candidate.
class RawDateCandidate {
  final String id;
  final DateTime startDate;
  final DateTime endDate;
  final double flightPrice;
  final double hotelPrice;
  final double weatherScore; // Raw weather score 0.0 - 100.0
  final double travelDurationHours; // Total travel duration in hours
  final int transferCount; // Total layovers / transfers
  final String weatherSummary;

  const RawDateCandidate({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.flightPrice,
    required this.hotelPrice,
    required this.weatherScore,
    required this.travelDurationHours,
    required this.transferCount,
    required this.weatherSummary,
  });

  double get totalPrice => flightPrice + hotelPrice;

  int get stayDurationDays => endDate.difference(startDate).inDays;
}
