import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/location_remote_datasource.dart';
import '../../data/repositories/map_repository_impl.dart';
import '../../domain/models/destination_location.dart';
import '../../domain/repositories/map_repository.dart';

/// Provider for LocationRemoteDataSource.
final locationRemoteDataSourceProvider =
    Provider<LocationRemoteDataSource>((ref) {
  return LocationRemoteDataSourceImpl();
});

/// Provider for MapRepository.
final mapRepositoryProvider = Provider<MapRepository>((ref) {
  final dataSource = ref.watch(locationRemoteDataSourceProvider);
  return MapRepositoryImpl(dataSource);
});

/// Async Provider to fetch destination location details for a given city.
final destinationLocationProvider =
    FutureProvider.family<DestinationLocation, String>((ref, cityName) async {
  final repository = ref.watch(mapRepositoryProvider);
  return await repository.getLocationForCity(cityName);
});
