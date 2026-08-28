import '../../domain/models/destination_location.dart';

abstract class LocationRemoteDataSource {
  Future<DestinationLocation> getDestinationLocation(String cityName);
}

class LocationRemoteDataSourceImpl implements LocationRemoteDataSource {

  LocationRemoteDataSourceImpl();

  @override
  Future<DestinationLocation> getDestinationLocation(String cityName) async {
    final lower = cityName.toLowerCase();

    if (lower.contains('roma') || lower.contains('rome')) {
      return const DestinationLocation(
        city: 'Roma',
        country: 'İtalya',
        countryCode: 'IT',
        latitude: 41.9028,
        longitude: 12.4964,
        description:
            'Antik mimarisi, Kolezyum, Vatikan ve leziz gastronomisi ile ünlü tarihi İtalya başkenti.',
        popularAttractions: ['Kolezyum', 'Trevi Çeşmesi', 'Pantheon', 'Vatikan'],
      );
    }

    if (lower.contains('paris')) {
      return const DestinationLocation(
        city: 'Paris',
        country: 'Fransa',
        countryCode: 'FR',
        latitude: 48.8566,
        longitude: 2.3522,
        description:
            'Eyfel Kulesi, Louvre Müzesi ve romantik bulvarlarıyla ünlü ışıklar şehri.',
        popularAttractions: ['Eyfel Kulesi', 'Louvre Müzesi', 'Şanzelize', 'Notre Dame'],
      );
    }

    if (lower.contains('tokyo')) {
      return const DestinationLocation(
        city: 'Tokyo',
        country: 'Japonya',
        countryCode: 'JP',
        latitude: 35.6762,
        longitude: 139.6503,
        description:
            'Geleneksel tapınakları ultra-modern teknoloji ve gökdelenlerle buluşturan küresel metropol.',
        popularAttractions: ['Shibuya Kavşağı', 'Senso-ji Tapınağı', 'Tokyo Kulesi', 'Akihabara'],
      );
    }

    if (lower.contains('antalya')) {
      return const DestinationLocation(
        city: 'Antalya',
        country: 'Türkiye',
        countryCode: 'TR',
        latitude: 36.8969,
        longitude: 30.7133,
        description:
            'Akdeniz turizminin başkenti, masmavi koylar, Kaleiçi ve antik kentler cenneti.',
        popularAttractions: ['Kaleiçi', 'Düden Şelalesi', 'Konyaaltı Plajı', 'Aspendos'],
      );
    }

    if (lower.contains('ankara')) {
      return const DestinationLocation(
        city: 'Ankara',
        country: 'Türkiye',
        countryCode: 'TR',
        latitude: 39.9334,
        longitude: 32.8597,
        description:
            'Türkiye Cumhuriyeti\'nin başkenti, Anıtkabir ve zengin müzelere ev sahipliği yapan kent.',
        popularAttractions: ['Anıtkabir', 'Ankara Kalesi', 'Anadolu Medeniyetleri Müzesi'],
      );
    }

    if (lower.contains('izmir')) {
      return const DestinationLocation(
        city: 'İzmir',
        country: 'Türkiye',
        countryCode: 'TR',
        latitude: 38.4237,
        longitude: 27.1428,
        description:
            'Ege\'nin incisi, Saat Kulesi, Kordon boyu ve Efes Antik Kenti kapısı.',
        popularAttractions: ['Saat Kulesi', 'Kordon', 'Efes Antik Kenti', 'Alaçatı'],
      );
    }

    if (lower.contains('kapadokya')) {
      return const DestinationLocation(
        city: 'Kapadokya',
        country: 'Türkiye',
        countryCode: 'TR',
        latitude: 38.6431,
        longitude: 34.8289,
        description:
            'Peri bacaları, sıcak hava balonları ve yeraltı şehirleriyle büyüleyici coğrafya.',
        popularAttractions: ['Göreme Açık Hava Müzesi', 'Balon Turu', 'Uçhisar Kalesi'],
      );
    }

    if (lower.contains('londra') || lower.contains('london')) {
      return const DestinationLocation(
        city: 'Londra',
        country: 'Birleşik Krallık',
        countryCode: 'GB',
        latitude: 51.5074,
        longitude: -0.1278,
        description:
            'Big Ben, London Eye ve Thames nehri etrafındaki dünyaca ünlü kültür metropolü.',
        popularAttractions: ['Big Ben', 'London Eye', 'British Museum', 'Tower Bridge'],
      );
    }

    // Default Fallback: Istanbul
    return const DestinationLocation(
      city: 'İstanbul',
      country: 'Türkiye',
      countryCode: 'TR',
      latitude: 41.0082,
      longitude: 28.9784,
      description:
          'Asya ve Avrupa kıtalarını birleştiren, Ayasofya ve Boğaz manzaralarıyla tarihi dünya kenti.',
      popularAttractions: ['Ayasofya', 'Sultanahmet Camii', 'Topkapı Sarayı', 'Kapalıçarşı'],
    );
  }
}
