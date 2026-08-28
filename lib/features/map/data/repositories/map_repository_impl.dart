import '../../domain/models/destination_location.dart';
import '../../domain/repositories/map_repository.dart';
import '../datasources/location_remote_datasource.dart';

class MapRepositoryImpl implements MapRepository {
  final LocationRemoteDataSource _remoteDataSource;

  MapRepositoryImpl(this._remoteDataSource);

  @override
  Future<DestinationLocation> getLocationForCity(String cityName) async {
    return await _remoteDataSource.getDestinationLocation(cityName);
  }
}
