import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/localization/app_localizations_provider.dart';
import '../providers/weather_provider.dart';
import '../../../home/presentation/providers/home_search_provider.dart';

class WeatherCardWidget extends ConsumerWidget {
  const WeatherCardWidget({super.key});

  IconData _getWeatherIcon(int weatherCode) {
    switch (weatherCode) {
      case 0:
        return Icons.wb_sunny_rounded;
      case 1:
      case 2:
      case 3:
        return Icons.wb_cloudy_rounded;
      case 45:
      case 48:
        return Icons.cloud_rounded;
      case 51:
      case 53:
      case 55:
      case 61:
      case 63:
      case 65:
      case 80:
      case 81:
      case 82:
        return Icons.grain_rounded;
      case 71:
      case 73:
      case 75:
        return Icons.ac_unit_rounded;
      case 95:
      case 96:
      case 99:
        return Icons.thunderstorm_rounded;
      default:
        return Icons.wb_sunny_rounded;
    }
  }

  Color _getWeatherColor(int weatherCode) {
    if (weatherCode == 0) return Colors.amber;
    if (weatherCode >= 1 && weatherCode <= 3) return Colors.lightBlueAccent;
    if (weatherCode >= 51 && weatherCode <= 82) return Colors.blue;
    return Colors.cyan;
  }

  String _formatDateSafely(DateTime? date) {
    if (date == null) return 'Bugün';
    try {
      return DateFormat('d MMMM yyyy', 'tr_TR').format(date);
    } catch (_) {
      return '${date.day}.${date.month}.${date.year}';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final loc = ref.watch(locProvider);
    final searchParams = ref.watch(homeSearchProvider).params;

    final targetCity = searchParams.destination.isNotEmpty
        ? searchParams.destination
        : 'Roma (FCO)';
    final targetStartDate = searchParams.startDate ?? DateTime.now();

    final query = WeatherQuery(
      cityName: targetCity,
      startDate: targetStartDate,
    );

    final weatherAsync = ref.watch(cityWeatherProvider(query));

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: weatherAsync.when(
          data: (weather) {
            final minTemp = weather.dailyForecasts.isNotEmpty
                ? weather.dailyForecasts.first.minTemp.round()
                : 18;
            final maxTemp = weather.dailyForecasts.isNotEmpty
                ? weather.dailyForecasts.first.maxTemp.round()
                : 26;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Reliability Notice Badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: weather.isHistoricalAverage
                        ? Colors.orange.withValues(alpha: 0.15)
                        : theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        weather.isHistoricalAverage
                            ? Icons.info_outline_rounded
                            : Icons.verified_outlined,
                        size: 14,
                        color: weather.isHistoricalAverage
                            ? Colors.orange.shade800
                            : theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          weather.reliabilityNotice,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: weather.isHistoricalAverage
                                ? Colors.orange.shade900
                                : theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // City & Target Date Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _getWeatherIcon(weather.weatherCode),
                          color: _getWeatherColor(weather.weatherCode),
                          size: 36,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              weather.cityName,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Seyahat Tarihi: ${_formatDateSafely(targetStartDate)}',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Current Temp Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color:
                            theme.colorScheme.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '${weather.temperature.toStringAsFixed(1)}°C',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          Text(
                            'Min $minTemp° / Max $maxTemp°',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                // Weather Details Row (Description, Wind, Humidity, Precipitation)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      weather.weatherDescription,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: [
                        // Rain Probability
                        const Icon(
                          Icons.umbrella_rounded,
                          size: 15,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '%${weather.precipitationProbability}',
                          style: const TextStyle(
                              fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 10),
                        // Wind
                        Icon(
                          Icons.air_rounded,
                          size: 15,
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '${weather.windSpeed} km/s',
                          style: theme.textTheme.bodySmall,
                        ),
                        const SizedBox(width: 10),
                        // Humidity
                        Icon(
                          Icons.water_drop_rounded,
                          size: 15,
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '%${weather.humidity}',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
                if (weather.dailyForecasts.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  const Divider(height: 1),
                  const SizedBox(height: 10),
                  // Forecast Horizontal Scroll
                  SizedBox(
                    height: 48,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: weather.dailyForecasts.take(5).length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final forecast = weather.dailyForecasts[index];
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest
                                .withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _getWeatherIcon(forecast.weatherCode),
                                size: 16,
                                color: _getWeatherColor(forecast.weatherCode),
                              ),
                              const SizedBox(width: 6),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${forecast.maxTemp.round()}° / ${forecast.minTemp.round()}°',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    loc.precipitationText(forecast.precipitationProbability),
                                    style: TextStyle(
                                      fontSize: 9,
                                      color: theme.colorScheme.onSurface
                                          .withValues(alpha: 0.6),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ],
            );
          },
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 12),
                Text('Destinasyon Hava Durumu Yükleniyor...'),
              ],
            ),
          ),
          error: (err, stack) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              children: [
                const Icon(Icons.cloud_off_rounded, color: Colors.orange),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Hava durumu tahmini alınamadı.',
                    style: TextStyle(fontSize: 12, color: Colors.orange),
                  ),
                ),
                TextButton(
                  onPressed: () => ref.invalidate(cityWeatherProvider(query)),
                  child: const Text('Tekrar Denetle'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
