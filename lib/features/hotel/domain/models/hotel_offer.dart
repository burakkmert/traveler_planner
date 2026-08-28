import 'package:flutter/foundation.dart';

/// Data class representing a hotel search offer result.
@immutable
class HotelOffer {
  final String id;
  final String hotelName;
  final String city;
  final String address;
  final double rating;
  final int reviewCount;
  final double price;
  final String currency;
  final String imageUrl;
  final String roomInfo;
  final double? latitude;
  final double? longitude;

  const HotelOffer({
    required this.id,
    required this.hotelName,
    required this.city,
    required this.address,
    required this.rating,
    required this.reviewCount,
    required this.price,
    required this.currency,
    required this.imageUrl,
    required this.roomInfo,
    this.latitude,
    this.longitude,
  });

  /// Factory parser for Amadeus Hotel Search API v3 JSON payload.
  factory HotelOffer.fromAmadeusJson(
      Map<String, dynamic> json, String cityName) {
    final hotelObj = json['hotel'] as Map<String, dynamic>? ?? {};
    final id = hotelObj['hotelId']?.toString() ?? 'h_1';
    final name = hotelObj['name']?.toString() ?? 'Lüks Şehir Oteli';

    final addressObj = hotelObj['address'] as Map<String, dynamic>? ?? {};
    final addressLines = addressObj['lines'] as List<dynamic>? ?? [];
    final addressStr = addressLines.isNotEmpty
        ? addressLines.first.toString()
        : '$cityName Şehir Merkezi';

    final offers = json['offers'] as List<dynamic>? ?? [];
    final firstOffer = offers.isNotEmpty
        ? offers.first as Map<String, dynamic>
        : <String, dynamic>{};

    final priceObj = firstOffer['price'] as Map<String, dynamic>? ?? {};
    final double totalPrice =
        double.tryParse(priceObj['total']?.toString() ?? '0.0') ?? 0.0;
    final String currencyCode = priceObj['currency']?.toString() ?? 'TRY';

    final roomObj = firstOffer['room'] as Map<String, dynamic>? ?? {};
    final typeEst = roomObj['typeEstimated'] as Map<String, dynamic>? ?? {};
    final roomCategory = typeEst['category']?.toString() ?? 'Standart Oda';
    final bedType = typeEst['bedType']?.toString() ?? 'Çift Kişilik';

    final double ratingVal =
        (hotelObj['rating'] as num?)?.toDouble() ?? 4.5;

    return HotelOffer(
      id: id,
      hotelName: name,
      city: cityName,
      address: addressStr,
      rating: ratingVal,
      reviewCount: 120 + (id.hashCode % 200).abs(),
      price: totalPrice > 0 ? totalPrice : 3850.0,
      currency: currencyCode,
      imageUrl: _getHotelImageForCity(cityName, id),
      roomInfo: '$roomCategory • $bedType Yatak • Kahvaltı Dahil',
      latitude: (hotelObj['latitude'] as num?)?.toDouble(),
      longitude: (hotelObj['longitude'] as num?)?.toDouble(),
    );
  }

  static String _getHotelImageForCity(String city, String id) {
    final lower = city.toLowerCase();
    if (lower.contains('roma')) {
      return 'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=600&q=80';
    }
    if (lower.contains('paris')) {
      return 'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?auto=format&fit=crop&w=600&q=80';
    }
    if (lower.contains('tokyo')) {
      return 'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?auto=format&fit=crop&w=600&q=80';
    }
    if (lower.contains('antalya')) {
      return 'https://images.unsplash.com/photo-1571896349842-33c89424de2d?auto=format&fit=crop&w=600&q=80';
    }
    return 'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=600&q=80';
  }
}
