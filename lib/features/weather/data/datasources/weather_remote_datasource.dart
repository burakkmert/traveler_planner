import '../../../../core/network/dio_client.dart';
import '../../../../core/network/network_exception.dart';
import '../../domain/models/weather_data.dart';

abstract class WeatherRemoteDataSource {
  Future<WeatherData> getWeatherForLocation({
    required double latitude,
    required double longitude,
    required String cityName,
    DateTime? startDate,
  });
}

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  final DioClient _dioClient;

  static const String _baseUrl = 'https://api.open-meteo.com/v1/forecast';

  WeatherRemoteDataSourceImpl(this._dioClient);

  @override
  Future<WeatherData> getWeatherForLocation({
    required double latitude,
    required double longitude,
    required String cityName,
    DateTime? startDate,
  }) async {
    final response = await _dioClient.get(
      _baseUrl,
      queryParameters: {
        'latitude': latitude,
        'longitude': longitude,
        'current':
            'temperature_2m,relative_humidity_2m,weather_code,wind_speed_10m',
        'daily':
            'weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max,precipitation_sum',
        'timezone': 'auto',
        'forecast_days': 14,
      },
    );

    if (response is! Map<String, dynamic>) {
      throw NetworkException.parseError(
          'Open-Meteo yanıtı geçerli bir JSON haritası değil.');
    }

    return WeatherData.fromOpenMeteoJson(
      response,
      cityName,
      targetStartDate: startDate,
    );
  }
}
