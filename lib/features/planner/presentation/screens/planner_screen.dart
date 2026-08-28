import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../home/presentation/providers/home_search_provider.dart';
import '../../../weather/presentation/widgets/weather_card_widget.dart';

class PlannerScreen extends ConsumerStatefulWidget {
  const PlannerScreen({super.key});

  @override
  ConsumerState<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends ConsumerState<PlannerScreen> {
  bool _isGenerating = false;
  bool _isGenerated = false;

  void _generateTripPlan() async {
    setState(() {
      _isGenerating = true;
      _isGenerated = false;
    });

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isGenerating = false;
        _isGenerated = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final searchState = ref.watch(homeSearchProvider);
    final searchParams = searchState.params;

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Seyahat Planlayıcı'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // AI Header Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.auto_awesome_rounded,
                size: 54,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Akıllı AI Rota Motoru',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.flight_takeoff_rounded,
                            size: 18, color: theme.colorScheme.primary),
                        const SizedBox(width: 8),
                        Text(
                          '${searchParams.origin}  ➔  ${searchParams.destination}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${searchParams.passengerCount} Yolcu • Özel AI Gezi Planı',
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Live Weather Card Integration on Planner Screen
            const WeatherCardWidget(),
            const SizedBox(height: 20),
            if (_isGenerating) ...[
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                'Gemini AI ${searchParams.destination} için harika bir gezi planı hazırlıyor...',
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ] else ...[
              ElevatedButton.icon(
                onPressed: _generateTripPlan,
                icon: const Icon(Icons.auto_awesome_rounded),
                label: const Text('AI ile Rota Oluştur'),
              ),
            ],
            if (_isGenerated) ...[
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.check_circle_rounded, color: Colors.green),
                  const SizedBox(width: 8),
                  Text(
                    'Örnek AI Rotanız Hazır!',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildItineraryDayCard(
                context,
                dayTitle: '1. Gün: Şehre Varış ve Tarihi Merkez',
                activities: [
                  '10:00 - Havalimanından merkeze varış ve otele giriş',
                  '12:30 - Tarihi meydanda öğle yemeği ve İtalyan kahvesi',
                  '15:00 - Şehir simgesi antik eserlerin gezilmesi',
                  '19:30 - Akşam yemeği ve açık hava yürüyüşü',
                ],
              ),
              const SizedBox(height: 12),
              _buildItineraryDayCard(
                context,
                dayTitle: '2. Gün: Kültür, Müze ve Lezzet Durakları',
                activities: [
                  '09:30 - Sanat müzesi turu',
                  '13:00 - Yerel pazardan hediyelik ve atıştırmalıklar',
                  '16:30 - Manzara seyir tepesi fotoğraf molası',
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildItineraryDayCard(BuildContext context,
      {required String dayTitle, required List<String> activities}) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dayTitle,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 10),
            ...activities.map(
              (act) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    const Icon(Icons.circle, size: 6, color: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        act,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
