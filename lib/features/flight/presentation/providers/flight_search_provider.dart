import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../home/domain/models/search_params.dart';
import '../../../weather/presentation/providers/weather_provider.dart';
import '../../data/datasources/flight_remote_datasource.dart';
import '../../data/repositories/flight_repository_impl.dart';
import '../../domain/models/flight_offer.dart';
import '../../domain/repositories/flight_repository.dart';

/// Provider for FlightRemoteDataSource.
final flightRemoteDataSourceProvider = Provider<FlightRemoteDataSource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return FlightRemoteDataSourceImpl(dioClient);
});

/// Provider for FlightRepository.
final flightRepositoryProvider = Provider<FlightRepository>((ref) {
  final dataSource = ref.watch(flightRemoteDataSourceProvider);
  return FlightRepositoryImpl(dataSource);
});

/// Async Provider to fetch flight search results for given SearchParams.
final flightSearchResultsProvider =
    FutureProvider.family<List<FlightOffer>, SearchParams>(
        (ref, searchParams) async {
  final repository = ref.watch(flightRepositoryProvider);
  return await repository.searchFlights(searchParams);
});
