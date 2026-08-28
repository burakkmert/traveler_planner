import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../home/domain/models/search_params.dart';
import '../../../weather/presentation/providers/weather_provider.dart';
import '../../data/datasources/hotel_remote_datasource.dart';
import '../../data/repositories/hotel_repository_impl.dart';
import '../../domain/models/hotel_offer.dart';
import '../../domain/repositories/hotel_repository.dart';

/// Provider for HotelRemoteDataSource.
final hotelRemoteDataSourceProvider = Provider<HotelRemoteDataSource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return HotelRemoteDataSourceImpl(dioClient);
});

/// Provider for HotelRepository.
final hotelRepositoryProvider = Provider<HotelRepository>((ref) {
  final dataSource = ref.watch(hotelRemoteDataSourceProvider);
  return HotelRepositoryImpl(dataSource);
});

/// Async Provider to fetch hotel search results for given SearchParams.
final hotelSearchResultsProvider =
    FutureProvider.family<List<HotelOffer>, SearchParams>(
        (ref, searchParams) async {
  final repository = ref.watch(hotelRepositoryProvider);
  return await repository.searchHotels(searchParams);
});
