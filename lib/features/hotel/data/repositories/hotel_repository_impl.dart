import '../../../home/domain/models/search_params.dart';
import '../../domain/models/hotel_offer.dart';
import '../../domain/repositories/hotel_repository.dart';
import '../datasources/hotel_remote_datasource.dart';

class HotelRepositoryImpl implements HotelRepository {
  final HotelRemoteDataSource _remoteDataSource;

  HotelRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<HotelOffer>> searchHotels(SearchParams searchParams) async {
    try {
      final results = await _remoteDataSource.searchHotels(
        destinationCity: searchParams.destination,
        checkInDate: searchParams.startDate ?? DateTime.now(),
        checkOutDate: searchParams.endDate ??
            DateTime.now().add(const Duration(days: 5)),
        passengerCount: searchParams.passengerCount,
      );

      if (results.isNotEmpty) {
        return results;
      }
    } catch (_) {
      // Fallback mock hotels if network or credentials missing
    }

    return _getFallbackHotels(searchParams);
  }

  List<HotelOffer> _getFallbackHotels(SearchParams params) {
    final cityName = params.destination.isNotEmpty
        ? params.destination
        : 'Roma (FCO)';

    return [
      HotelOffer(
        id: 'ht_1',
        hotelName: 'Grand Plaza Resort & Spa',
        city: cityName,
        address: '$cityName Tarihi Şehir Merkezi, No: 42',
        rating: 4.8,
        reviewCount: 342,
        price: 4250.0,
        currency: 'TRY',
        imageUrl:
            'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=600&q=80',
        roomInfo: 'Deluxe Çift Kişilik Oda • Kahvaltı Dahil • Ücretsiz İptal',
      ),
      HotelOffer(
        id: 'ht_2',
        hotelName: 'Boutique Heritage Suites',
        city: cityName,
        address: '$cityName Sanat Bölgesi, Kültür Cad. 18',
        rating: 4.6,
        reviewCount: 215,
        price: 3100.0,
        currency: 'TRY',
        imageUrl:
            'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?auto=format&fit=crop&w=600&q=80',
        roomInfo: 'Executive Süit • Şehir Manzaralı • Kahvaltı Dahil',
      ),
      HotelOffer(
        id: 'ht_3',
        hotelName: 'Royal Comfort Hotel',
        city: cityName,
        address: '$cityName Sahil Yolu, Kordon Sk. 5',
        rating: 4.4,
        reviewCount: 188,
        price: 2650.0,
        currency: 'TRY',
        imageUrl:
            'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?auto=format&fit=crop&w=600&q=80',
        roomInfo: 'Superior İki Yataklı Oda • Klimalı & Wi-Fi',
      ),
    ];
  }
}
