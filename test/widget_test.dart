import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_app/main.dart';
import 'package:travel_app/features/weather/presentation/providers/weather_provider.dart';
import 'package:travel_app/features/weather/domain/models/weather_data.dart';

void main() {
  testWidgets('TravelApp smoke test', (WidgetTester tester) async {
    const mockWeather = WeatherData(
      cityName: 'Roma',
      temperature: 22.0,
      weatherCode: 0,
      weatherDescription: 'Açık',
      windSpeed: 10.0,
      humidity: 50,
      precipitationProbability: 10,
      precipitationSum: 0.0,
      isHistoricalAverage: false,
      reliabilityNotice: 'Canlı Tahmin Servisi',
      dailyForecasts: [],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          cityWeatherProvider.overrideWith((ref, arg) async => mockWeather),
        ],
        child: const TravelApp(),
      ),
    );

    await tester.pump();

    expect(find.byType(TravelApp), findsOneWidget);
  });
}
