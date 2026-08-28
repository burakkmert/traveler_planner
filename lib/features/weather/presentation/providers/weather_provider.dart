import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/datasources/weather_remote_datasource.dart';
import '../../data/repositories/weather_repository_impl.dart';
import '../../domain/models/weather_data.dart';
import '../../domain/repositories/weather_repository.dart';

@immutable
class WeatherQuery {
  final String cityName;
  final DateTime? startDate;

  const WeatherQuery({
    required this.cityName,
    this.startDate,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeatherQuery &&
          runtimeType == other.runtimeType &&
          cityName == other.cityName &&
          startDate == other.startDate;

  @override
  int get hashCode => cityName.hashCode ^ startDate.hashCode;
}

/// Provider for global DioClient.
final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient();
});

/// Provider for WeatherRemoteDataSource.
final weatherRemoteDataSourceProvider =
    Provider<WeatherRemoteDataSource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return WeatherRemoteDataSourceImpl(dioClient);
});

/// Provider for WeatherRepository.
final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  final dataSource = ref.watch(weatherRemoteDataSourceProvider);
  return WeatherRepositoryImpl(dataSource);
});

/// Async Provider to fetch weather data for a given WeatherQuery (City & Target Start Date).
final cityWeatherProvider =
    FutureProvider.family<WeatherData, WeatherQuery>((ref, query) async {
  final repository = ref.watch(weatherRepositoryProvider);
  return await repository.getWeatherForCity(
    query.cityName,
    startDate: query.startDate,
  );
});
