import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/localization/app_localizations_provider.dart';
import '../../../saved/presentation/providers/saved_preferences_provider.dart';
import '../../domain/models/recent_search.dart';
import '../providers/home_search_provider.dart';

class RecentSearchesWidget extends ConsumerWidget {
  const RecentSearchesWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final loc = ref.watch(locProvider);
    final prefsState = ref.watch(savedPreferencesProvider);

    final List<RecentSearch> searches = prefsState.searchHistory;

    if (searches.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              loc.recentSearches,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                ref.read(savedPreferencesProvider.notifier).clearSearchHistory();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(loc.isTurkish ? 'Arama geçmişi temizlendi.' : 'Search history cleared.'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: Text(loc.clearText),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 88,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: searches.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final search = searches[index];
              return InkWell(
                onTap: () {
                  final notifier = ref.read(homeSearchProvider.notifier);
                  notifier.setOrigin(search.origin);
                  notifier.setDestination(search.destination);
                  notifier.setPassengerCount(search.passengerCount);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${search.origin} ➔ ${search.destination}'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: 210,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.history_rounded, size: 16),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              '${search.origin} ➔ ${search.destination}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${search.dateRangeText} • ${loc.passengerCountText(search.passengerCount)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
