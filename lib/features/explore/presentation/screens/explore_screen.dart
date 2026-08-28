import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../map/presentation/widgets/destination_map_widget.dart';
import '../../../saved/domain/models/saved_trip.dart';
import '../../../saved/presentation/providers/saved_trips_provider.dart';

class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  void _showRouteDetails(BuildContext context, WidgetRef ref, int index) {
    final theme = Theme.of(context);
    final routeTitles = [
      'Roma Kültür & Tarih Turu',
      'Paris Romantizm & Müze Gezisi',
      'Tokyo Modern & Doğa Keşfi',
      'Kapadokya Balon & Vadi Turu',
      'Atina Antik Şehir Gezisi',
    ];
    final routeTitle = routeTitles[index % routeTitles.length];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.75,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView(
                controller: scrollController,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          routeTitle,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Consumer(
                        builder: (context, ref, child) {
                          final savedList = ref.watch(savedTripsProvider);
                          final currentlySaved =
                              savedList.any((t) => t.title == routeTitle);

                          return IconButton(
                            icon: Icon(
                              currentlySaved
                                  ? Icons.bookmark_rounded
                                  : Icons.bookmark_border_rounded,
                              color: currentlySaved ? Colors.amber : null,
                              size: 28,
                            ),
                            onPressed: () {
                              if (currentlySaved) {
                                final tripToRemove = savedList.firstWhere(
                                    (t) => t.title == routeTitle);
                                ref
                                    .read(savedTripsProvider.notifier)
                                    .removeTrip(tripToRemove.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Rota kayıtlardan çıkarıldı.'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              } else {
                                final newTrip = SavedTrip(
                                  id: 'saved_${DateTime.now().millisecondsSinceEpoch}',
                                  title: routeTitle,
                                  destination: 'Popüler Rota',
                                  durationText: '3 Gün 2 Gece',
                                  estimatedCost: '₺14.500',
                                  savedAt: DateTime.now(),
                                );
                                ref
                                    .read(savedTripsProvider.notifier)
                                    .addTrip(newTrip);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Rota başarıyla Kayıtlılara eklendi! 🔖'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '3 Günlük Özel Gezi Programı • Tahmini Bütçe: ₺14.500',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Map Preview in Route Detail Modal
                  DestinationMapWidget(overrideCity: routeTitle.split(' ').first),
                  const SizedBox(height: 16),
                  Text(
                    'Günlük Aktivite Detayları',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildDayCard(
                    context,
                    day: '1. Gün',
                    title: 'Varış ve Şehir Tanıtım Turu',
                    desc:
                        'Otele yerleşme, tarihi şehir merkezinde yürüyüş ve lokal akşam yemeği.',
                  ),
                  const SizedBox(height: 10),
                  _buildDayCard(
                    context,
                    day: '2. Gün',
                    title: 'Müzeler ve Kültür Durakları',
                    desc:
                        'Ana sanat müzesi ziyareti, tarihi meydanlarda kahve molası ve panaroma seyri.',
                  ),
                  const SizedBox(height: 10),
                  _buildDayCard(
                    context,
                    day: '3. Gün',
                    title: 'Hediyelik Alışverişi & Dönüş',
                    desc:
                        'Yerel pazarların gezilmesi, hatıra fotoğrafı çekimi ve havalimanı transferi.',
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.check_rounded),
                    label: const Text('Kapat'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDayCard(BuildContext context,
      {required String day, required String title, required String desc}) {
    final theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    day,
                    style: TextStyle(
                      color: theme.colorScheme.onPrimary,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              desc,
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Harita & Destinasyon Keşfi'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Prominent Map Canvas View
            const DestinationMapWidget(),
            const SizedBox(height: 20),
            Text(
              'Popüler Rotalar',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final titles = [
                  'Roma Kültür & Tarih Turu',
                  'Paris Romantizm & Müze Gezisi',
                  'Tokyo Modern & Doğa Keşfi',
                  'Kapadokya Balon & Vadi Turu',
                  'Atina Antik Şehir Gezisi',
                ];
                final title = titles[index % titles.length];

                return Card(
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.explore_rounded),
                    ),
                    title: Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text('3 Günlük Kültür & Lezzet Gezisi'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => _showRouteDetails(context, ref, index),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
