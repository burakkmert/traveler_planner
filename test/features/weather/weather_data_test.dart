import 'package:flutter_test/flutter_test.dart';
import 'package:travel_app/features/weather/domain/models/weather_data.dart';

void main() {
  group('WeatherData Parser Unit Tests', () {
    test('Parses Open-Meteo JSON payload accurately', () {
      final mockJson = {
        'current': {
          'temperature_2m': 24.5,
          'weather_code': 0,
          'wind_speed_10m': 12.3,
          'relative_humidity_2m': 55,
        },
        'daily': {
          'time': ['2026-08-28', '2026-08-29'],
          'temperature_2m_max': [26.0, 27.5],
          'temperature_2m_min': [18.0, 19.0],
          'weather_code': [0, 1],
          'precipitation_probability_max': [20, 10],
          'precipitation_sum': [0.5, 0.0],
        }
      };

      final weather = WeatherData.fromOpenMeteoJson(mockJson, 'İstanbul');

      expect(weather.cityName, equals('İstanbul'));
      expect(weather.temperature, equals(24.5));
      expect(weather.weatherDescription, equals('Açık / Güneşli'));
      expect(weather.windSpeed, equals(12.3));
      expect(weather.humidity, equals(55));
      expect(weather.precipitationProbability, equals(20));
      expect(weather.dailyForecasts.length, equals(2));
      expect(weather.dailyForecasts.first.maxTemp, equals(26.0));
      expect(weather.dailyForecasts.first.precipitationProbability, equals(20));
    });
  });
}
