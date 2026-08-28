import '../../domain/models/weather_data.dart';
import '../../domain/repositories/weather_repository.dart';
import '../datasources/weather_remote_datasource.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource _remoteDataSource;

  WeatherRepositoryImpl(this._remoteDataSource);

  @override
  Future<WeatherData> getWeatherForCity(
    String cityName, {
    double? lat,
    double? lng,
    DateTime? startDate,
  }) async {
    final double targetLat = lat ?? _getCoordinatesForCity(cityName).$1;
    final double targetLng = lng ?? _getCoordinatesForCity(cityName).$2;

    try {
      return await _remoteDataSource.getWeatherForLocation(
        latitude: targetLat,
        longitude: targetLng,
        cityName: cityName,
        startDate: startDate,
      );
    } catch (_) {
      // Fallback mock weather data to prevent app crash if network is unavailable
      return _getFallbackWeather(cityName, startDate);
    }
  }

  WeatherData _getFallbackWeather(String city, DateTime? start) {
    return WeatherData(
      cityName: city,
      temperature: 24.0,
      weatherCode: 0,
      weatherDescription: 'Açık / Güneşli',
      windSpeed: 12.5,
      humidity: 45,
      precipitationProbability: 10,
      precipitationSum: 0.0,
      isHistoricalAverage: false,
      reliabilityNotice: 'Canlı Tahmin Servisine Erişilemedi (Örnek Veri)',
      dailyForecasts: const [
        DailyForecast(
          dateText: 'Bugün',
          maxTemp: 26.0,
          minTemp: 18.0,
          weatherCode: 0,
          precipitationProbability: 10,
          precipitationSum: 0.0,
        ),
        DailyForecast(
          dateText: 'Yarın',
          maxTemp: 27.0,
          minTemp: 19.0,
          weatherCode: 1,
          precipitationProbability: 15,
          precipitationSum: 0.0,
        ),
      ],
    );
  }

  (double, double) _getCoordinatesForCity(String city) {
    final lower = city.toLowerCase();
    if (lower.contains('roma')) return (41.9028, 12.4964);
    if (lower.contains('paris')) return (48.8566, 2.3522);
    if (lower.contains('tokyo')) return (35.6762, 139.6503);
    if (lower.contains('ankara')) return (39.9334, 32.8597);
    if (lower.contains('izmir')) return (38.4237, 27.1428);
    if (lower.contains('antalya')) return (36.8969, 30.7133);
    if (lower.contains('kapadokya')) return (38.6431, 34.8289);
    if (lower.contains('londra') || lower.contains('london')) {
      return (51.5074, -0.1278);
    }
    return (41.0082, 28.9784); // Default to Istanbul
  }
}
