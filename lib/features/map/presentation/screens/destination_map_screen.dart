import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../home/presentation/providers/home_search_provider.dart';
import '../widgets/destination_map_widget.dart';

class DestinationMapScreen extends ConsumerWidget {
  const DestinationMapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchParams = ref.watch(homeSearchProvider).params;
    final targetCity = searchParams.destination.isNotEmpty
        ? searchParams.destination
        : 'Roma (FCO)';

    return Scaffold(
      appBar: AppBar(
        title: Text('$targetCity Harita Keşfi'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar for changing destination on the Map Screen
            TextField(
              decoration: InputDecoration(
                hintText: 'Haritada şehir ara (Örn: Paris, Tokyo, Roma)...',
                prefixIcon: const Icon(Icons.map_rounded),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  ref
                      .read(homeSearchProvider.notifier)
                      .setDestination(value.trim());
                }
              },
            ),
            const SizedBox(height: 16),
            // Dedicated Destination Map Widget
            DestinationMapWidget(overrideCity: targetCity),
          ],
        ),
      ),
    );
  }
}
