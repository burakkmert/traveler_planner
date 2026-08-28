import 'package:flutter/foundation.dart';

/// Data class representing a flight search result offer.
@immutable
class FlightOffer {
  final String id;
  final String airlineName;
  final String airlineCode;
  final String flightNumber;
  final String originCode;
  final String originCity;
  final String destinationCode;
  final String destinationCity;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final String durationText;
  final int stopovers; // 0 = Direkt, 1 = 1 Aktarma
  final double price;
  final String currency;

  const FlightOffer({
    required this.id,
    required this.airlineName,
    required this.airlineCode,
    required this.flightNumber,
    required this.originCode,
    required this.originCity,
    required this.destinationCode,
    required this.destinationCity,
    required this.departureTime,
    required this.arrivalTime,
    required this.durationText,
    required this.stopovers,
    required this.price,
    required this.currency,
  });

  /// Factory converter to safely parse Amadeus Flight Offers API v2 JSON payload.
  factory FlightOffer.fromAmadeusJson(
      Map<String, dynamic> json, String originCity, String destCity) {
    final id = json['id']?.toString() ?? '1';

    // Price section
    final priceObj = json['price'] as Map<String, dynamic>? ?? {};
    final double grandTotal =
        double.tryParse(priceObj['grandTotal']?.toString() ?? '0.0') ?? 0.0;
    final String currencyCode = priceObj['currency']?.toString() ?? 'TRY';

    // Itineraries section
    final itineraries = json['itineraries'] as List<dynamic>? ?? [];
    final firstItinerary = itineraries.isNotEmpty
        ? itineraries.first as Map<String, dynamic>
        : <String, dynamic>{};
    final String durationRaw = firstItinerary['duration']?.toString() ?? 'PT2H30M';

    final segments = firstItinerary['segments'] as List<dynamic>? ?? [];
    final firstSegment = segments.isNotEmpty
        ? segments.first as Map<String, dynamic>
        : <String, dynamic>{};
    final lastSegment = segments.isNotEmpty
        ? segments.last as Map<String, dynamic>
        : <String, dynamic>{};

    final String carrierCode =
        firstSegment['carrierCode']?.toString() ?? 'TK';
    final String number = firstSegment['number']?.toString() ?? '101';

    final departureObj =
        firstSegment['departure'] as Map<String, dynamic>? ?? {};
    final arrivalObj = lastSegment['arrival'] as Map<String, dynamic>? ?? {};

    final String depIata = departureObj['iataCode']?.toString() ?? 'IST';
    final String arrIata = arrivalObj['iataCode']?.toString() ?? 'FCO';

    final DateTime depTime = DateTime.tryParse(
            departureObj['at']?.toString() ?? '') ??
        DateTime.now().add(const Duration(hours: 2));
    final DateTime arrTime =
        DateTime.tryParse(arrivalObj['at']?.toString() ?? '') ??
            DateTime.now().add(const Duration(hours: 5));

    final int numStops = segments.length > 1 ? segments.length - 1 : 0;

    return FlightOffer(
      id: id,
      airlineName: _getAirlineName(carrierCode),
      airlineCode: carrierCode,
      flightNumber: '$carrierCode $number',
      originCode: depIata,
      originCity: originCity,
      destinationCode: arrIata,
      destinationCity: destCity,
      departureTime: depTime,
      arrivalTime: arrTime,
      durationText: _parseDuration(durationRaw),
      stopovers: numStops,
      price: grandTotal,
      currency: currencyCode,
    );
  }

  static String _getAirlineName(String code) {
    switch (code.toUpperCase()) {
      case 'TK':
        return 'Türk Hava Yolları';
      case 'PC':
        return 'Pegasus';
      case 'AZ':
        return 'ITA Airways';
      case 'LH':
        return 'Lufthansa';
      case 'AF':
        return 'Air France';
      case 'BA':
        return 'British Airways';
      case 'EK':
        return 'Emirates';
      case 'QR':
        return 'Qatar Airways';
      default:
        return '$code Airlines';
    }
  }

  static String _parseDuration(String raw) {
    // Converts ISO duration format e.g. "PT2H40M" -> "2sa 40dk"
    final regExp = RegExp(r'PT(?:(\d+)H)?(?:(\d+)M)?');
    final match = regExp.firstMatch(raw);
    if (match != null) {
      final hours = match.group(1) ?? '0';
      final mins = match.group(2) ?? '0';
      if (hours == '0') return '${mins}dk';
      if (mins == '0') return '${hours}sa';
      return '${hours}sa ${mins}dk';
    }
    return '2sa 30dk';
  }
}
