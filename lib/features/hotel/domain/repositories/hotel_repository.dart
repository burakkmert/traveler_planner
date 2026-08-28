import '../../../home/domain/models/search_params.dart';
import '../models/hotel_offer.dart';

abstract class HotelRepository {
  Future<List<HotelOffer>> searchHotels(SearchParams searchParams);
}
