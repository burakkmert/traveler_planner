import '../models/destination_location.dart';

abstract class MapRepository {
  Future<DestinationLocation> getLocationForCity(String cityName);
}
