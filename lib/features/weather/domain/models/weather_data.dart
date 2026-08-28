import 'package:flutter/foundation.dart';

/// Data class representing weather forecast details for a specific destination and date range.
@immutable
class WeatherData {
  final String cityName;
  final double temperature;
  final int weatherCode;
  final String weatherDescription;
  final double windSpeed;
  final int humidity;
  final int precipitationProbability;
  final double precipitationSum;
  final bool isHistoricalAverage;
  final String reliabilityNotice;
  final List<DailyForecast> dailyForecasts;

  const WeatherData({
    required this.cityName,
    required this.temperature,
    required this.weatherCode,
    required this.weatherDescription,
    required this.windSpeed,
    required this.humidity,
    required this.precipitationProbability,
    required this.precipitationSum,
    required this.isHistoricalAverage,
    required this.reliabilityNotice,
    required this.dailyForecasts,
  });

  /// Factory constructor to parse Open-Meteo JSON payload with travel date awareness.
  factory WeatherData.fromOpenMeteoJson(
    Map<String, dynamic> json,
    String cityName, {
    DateTime? targetStartDate,
  }) {
    final current = json['current'] as Map<String, dynamic>? ?? {};
    final daily = json['daily'] as Map<String, dynamic>? ?? {};

    final double temp = (current['temperature_2m'] as num?)?.toDouble() ?? 22.0;
    final int code = (current['weather_code'] as num?)?.toInt() ?? 0;
    final double wind = (current['wind_speed_10m'] as num?)?.toDouble() ?? 12.0;
    final int hum = (current['relative_humidity_2m'] as num?)?.toInt() ?? 50;

    final List<dynamic> times = daily['time'] as List<dynamic>? ?? [];
    final List<dynamic> maxTemps =
        daily['temperature_2m_max'] as List<dynamic>? ?? [];
    final List<dynamic> minTemps =
        daily['temperature_2m_min'] as List<dynamic>? ?? [];
    final List<dynamic> codes = daily['weather_code'] as List<dynamic>? ?? [];
    final List<dynamic> precipProbs =
        daily['precipitation_probability_max'] as List<dynamic>? ?? [];
    final List<dynamic> precipSums =
        daily['precipitation_sum'] as List<dynamic>? ?? [];

    final List<DailyForecast> forecasts = [];
    for (int i = 0; i < times.length; i++) {
      forecasts.add(
        DailyForecast(
          dateText: times[i].toString(),
          maxTemp: (maxTemps.length > i ? (maxTemps[i] as num?)?.toDouble() : 25.0) ?? 25.0,
          minTemp: (minTemps.length > i ? (minTemps[i] as num?)?.toDouble() : 16.0) ?? 16.0,
          weatherCode: (codes.length > i ? (codes[i] as num?)?.toInt() : 0) ?? 0,
          precipitationProbability:
              (precipProbs.length > i ? (precipProbs[i] as num?)?.toInt() : 15) ?? 15,
          precipitationSum:
              (precipSums.length > i ? (precipSums[i] as num?)?.toDouble() : 0.0) ?? 0.0,
        ),
      );
    }

    // Determine forecast horizon reliability
    final now = DateTime.now();
    final start = targetStartDate ?? now;
    final daysDifference = start.difference(now).inDays;

    final bool isFarFuture = daysDifference > 14;
    final String notice = isFarFuture
        ? 'Seyahat tarihiniz 14 günün ötesinde olduğu için mevsimsel iklim ortalamaları gösterilmektedir.'
        : daysDifference > 7
            ? 'Seyahat tarihinize 7 günden fazla olduğu için tahminlerde güncellemeler olabilir.'
            : 'Canlı Meteorolojik Tahmin (Open-Meteo API)';

    final int currentPrecipProb = forecasts.isNotEmpty
        ? forecasts.first.precipitationProbability
        : 15;
    final double currentPrecipSum =
        forecasts.isNotEmpty ? forecasts.first.precipitationSum : 0.0;

    return WeatherData(
      cityName: cityName,
      temperature: temp,
      weatherCode: code,
      weatherDescription: _getWmoDescription(code),
      windSpeed: wind,
      humidity: hum,
      precipitationProbability: currentPrecipProb,
      precipitationSum: currentPrecipSum,
      isHistoricalAverage: isFarFuture,
      reliabilityNotice: notice,
      dailyForecasts: forecasts,
    );
  }

  static String _getWmoDescription(int code) {
    switch (code) {
      case 0:
        return 'Açık / Güneşli';
      case 1:
      case 2:
      case 3:
        return 'Parçalı Bulutlu';
      case 45:
      case 48:
        return 'Sisli';
      case 51:
      case 53:
      case 55:
        return 'Çiseleyen Yağmur';
      case 61:
      case 63:
      case 65:
        return 'Yağmurlu';
      case 71:
      case 73:
      case 75:
        return 'Kar Yağışlı';
      case 80:
      case 81:
      case 82:
        return 'Sağanak Yağışlı';
      case 95:
      case 96:
      case 99:
        return 'Fırtınalı / Gök Gürültülü';
      default:
        return 'Ilıman';
    }
  }
}

@immutable
class DailyForecast {
  final String dateText;
  final double maxTemp;
  final double minTemp;
  final int weatherCode;
  final int precipitationProbability;
  final double precipitationSum;

  const DailyForecast({
    required this.dateText,
    required this.maxTemp,
    required this.minTemp,
    required this.weatherCode,
    required this.precipitationProbability,
    required this.precipitationSum,
  });
}
