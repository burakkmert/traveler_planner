import '../models/weather_data.dart';

abstract class WeatherRepository {
  Future<WeatherData> getWeatherForCity(
    String cityName, {
    double? lat,
    double? lng,
    DateTime? startDate,
  });
}
