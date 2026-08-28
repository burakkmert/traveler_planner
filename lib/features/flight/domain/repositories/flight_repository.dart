import '../../../home/domain/models/search_params.dart';
import '../models/flight_offer.dart';

abstract class FlightRepository {
  Future<List<FlightOffer>> searchFlights(SearchParams searchParams);
}
