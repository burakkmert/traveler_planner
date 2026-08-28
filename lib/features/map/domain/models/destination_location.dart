import 'package:flutter/foundation.dart';

/// Data class representing geographic location details for a travel destination.
@immutable
class DestinationLocation {
  final String city;
  final String country;
  final String countryCode;
  final double latitude;
  final double longitude;
  final String description;
  final List<String> popularAttractions;

  const DestinationLocation({
    required this.city,
    required this.country,
    required this.countryCode,
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.popularAttractions,
  });

  String get formattedCoordinates =>
      '${latitude.toStringAsFixed(4)}° N, ${longitude.toStringAsFixed(4)}° E';

  /// Factory constructor parsing location JSON data.
  factory DestinationLocation.fromJson(Map<String, dynamic> json) {
    final List<dynamic> attractionsRaw = json['popularAttractions'] as List<dynamic>? ?? [];

    return DestinationLocation(
      city: json['city']?.toString() ?? 'Bilinmeyen Şehir',
      country: json['country']?.toString() ?? 'Bilinmeyen Ülke',
      countryCode: json['countryCode']?.toString() ?? 'TR',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 41.0082,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 28.9784,
      description: json['description']?.toString() ?? '',
      popularAttractions: attractionsRaw.map((e) => e.toString()).toList(),
    );
  }
}
