import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/localization/app_localizations_provider.dart';
import '../../../flight/presentation/widgets/flight_results_modal.dart';
import '../../../hotel/presentation/widgets/hotel_results_modal.dart';
import '../../../planner/presentation/screens/date_optimizer_screen.dart';
import '../../../saved/presentation/providers/saved_preferences_provider.dart';
import '../../domain/models/recent_search.dart';
import '../providers/home_search_provider.dart';

class TravelSearchCardWidget extends ConsumerWidget {
  const TravelSearchCardWidget({super.key});

  String _formatDateSafely(DateTime date, WidgetRef ref) {
    final loc = ref.read(locProvider);
    return loc.formatDate(date);
  }

  String _getMonthName(int month) {
    const names = [
      '',
      'Oca',
      'Şub',
      'Mar',
      'Nis',
      'May',
      'Haz',
      'Tem',
      'Ağu',
      'Eyl',
      'Eki',
      'Kas',
      'Ara'
    ];
    return (month >= 1 && month <= 12) ? names[month] : '$month';
  }

  void _saveSearchHistory(WidgetRef ref, dynamic searchParams) {
    if (searchParams.origin.toString().isEmpty || searchParams.destination.toString().isEmpty) return;

    final String dateRangeText = (searchParams.startDate != null && searchParams.endDate != null)
        ? '${searchParams.startDate!.day}-${searchParams.endDate!.day} ${_getMonthName(searchParams.startDate!.month)}'
        : 'Esnek Tarih';

    final search = RecentSearch(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      origin: searchParams.origin,
      destination: searchParams.destination,
      dateRangeText: dateRangeText,
      passengerCount: searchParams.passengerCount,
    );

    ref.read(savedPreferencesProvider.notifier).addSearchHistory(search);
  }

  Future<void> _selectDateRange(BuildContext context, WidgetRef ref) async {
    final searchState = ref.read(homeSearchProvider);
    final searchParams = searchState.params;
    final DateTime initialStart = searchParams.startDate ?? DateTime.now();
    final DateTime initialEnd =
        searchParams.endDate ?? DateTime.now().add(const Duration(days: 5));

    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: DateTimeRange(start: initialStart, end: initialEnd),
      helpText: 'Seyahat Tarihlerini Seçin',
      cancelText: 'Vazgeç',
      confirmText: 'Uygula',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context),
          child: child!,
        );
      },
    );

    if (picked != null) {
      ref.read(homeSearchProvider.notifier).setDates(picked.start, picked.end);
    }
  }

  void _showPassengerPicker(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Consumer(
          builder: (context, ref, child) {
            final params = ref.watch(homeSearchProvider).params;
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Kişi Sayısı Seçin',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Yolcular',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            'Yetişkin ve Çocuk (1-9 kişi)',
                            style: TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton.outlined(
                            icon: const Icon(Icons.remove_rounded),
                            onPressed: params.passengerCount > 1
                                ? () => ref
                                    .read(homeSearchProvider.notifier)
                                    .setPassengerCount(params.passengerCount - 1)
                                : null,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              '${params.passengerCount}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton.outlined(
                            icon: const Icon(Icons.add_rounded),
                            onPressed: params.passengerCount < 9
                                ? () => ref
                                    .read(homeSearchProvider.notifier)
                                    .setPassengerCount(params.passengerCount + 1)
                                : null,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Tamam'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final loc = ref.watch(locProvider);
    final searchState = ref.watch(homeSearchProvider);
    final searchParams = searchState.params;

    final bool hasOriginError = searchState.errorFieldKey == 'origin';
    final bool hasDestError = searchState.errorFieldKey == 'destination';
    final bool hasDateError = searchState.errorFieldKey == 'startDate' ||
        searchState.errorFieldKey == 'endDate';

    final String startDateStr = searchParams.startDate != null
        ? _formatDateSafely(searchParams.startDate!, ref)
        : loc.selectStart;

    final String endDateStr = searchParams.endDate != null
        ? _formatDateSafely(searchParams.endDate!, ref)
        : loc.selectEnd;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(
          color: searchState.validationError != null
              ? theme.colorScheme.error.withValues(alpha: 0.5)
              : theme.colorScheme.onSurface.withValues(alpha: 0.1),
          width: searchState.validationError != null ? 1.5 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Validation Error Banner if present
            if (searchState.validationError != null) ...[
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      color: theme.colorScheme.onErrorContainer,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        searchState.validationError!,
                        style: TextStyle(
                          color: theme.colorScheme.onErrorContainer,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 18),
                      color: theme.colorScheme.onErrorContainer,
                      onPressed: () {
                        ref.read(homeSearchProvider.notifier).clearError();
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Origin & Destination Inputs with Swap Button
            Stack(
              alignment: Alignment.centerRight,
              children: [
                Column(
                  children: [
                    // Origin Input
                    InkWell(
                      onTap: () =>
                          _showLocationSearch(context, ref, isOrigin: true),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest
                              .withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(16),
                          border: hasOriginError
                              ? Border.all(
                                  color: theme.colorScheme.error, width: 1.5)
                              : null,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.flight_takeoff_rounded,
                              color: hasOriginError
                                  ? theme.colorScheme.error
                                  : theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    loc.originLabel,
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: hasOriginError
                                          ? theme.colorScheme.error
                                          : theme.colorScheme.onSurface
                                              .withValues(alpha: 0.6),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    searchParams.origin.isEmpty
                                        ? 'Şehir veya havalimanı seçin'
                                        : searchParams.origin,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: searchParams.origin.isEmpty
                                          ? theme.colorScheme.onSurface
                                              .withValues(alpha: 0.4)
                                          : null,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 40),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Destination Input
                    InkWell(
                      onTap: () =>
                          _showLocationSearch(context, ref, isOrigin: false),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest
                              .withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(16),
                          border: hasDestError
                              ? Border.all(
                                  color: theme.colorScheme.error, width: 1.5)
                              : null,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.flight_land_rounded,
                              color: hasDestError
                                  ? theme.colorScheme.error
                                  : theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    loc.destinationLabel,
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: hasDestError
                                          ? theme.colorScheme.error
                                          : theme.colorScheme.onSurface
                                              .withValues(alpha: 0.6),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    searchParams.destination.isEmpty
                                        ? 'Şehir veya havalimanı seçin'
                                        : searchParams.destination,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: searchParams.destination.isEmpty
                                          ? theme.colorScheme.onSurface
                                              .withValues(alpha: 0.4)
                                          : null,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 40),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                // Location Swap Button
                Positioned(
                  right: 8,
                  child: Material(
                    color: Colors.transparent,
                    shape: const CircleBorder(),
                    clipBehavior: Clip.antiAlias,
                    elevation: 4,
                    child: InkWell(
                      onTap: () {
                        ref.read(homeSearchProvider.notifier).swapLocations();
                      },
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: theme.colorScheme.primary,
                        child: Icon(
                          Icons.swap_vert_rounded,
                          size: 22,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Date & Passenger Selectors Row
            Row(
              children: [
                // Dates Selector
                Expanded(
                  child: InkWell(
                    onTap: () => _selectDateRange(context, ref),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest
                            .withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(16),
                        border: hasDateError
                            ? Border.all(
                                color: theme.colorScheme.error, width: 1.5)
                            : null,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today_rounded,
                            size: 20,
                            color: hasDateError
                                ? theme.colorScheme.error
                                : theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  loc.datesLabel,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: hasDateError
                                        ? theme.colorScheme.error
                                        : theme.colorScheme.onSurface
                                            .withValues(alpha: 0.6),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  searchParams.startDate != null
                                      ? '$startDateStr - $endDateStr'
                                      : 'Tarih Seç',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Passenger Count Selector
                Expanded(
                  child: InkWell(
                    onTap: () => _showPassengerPicker(context, ref),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest
                            .withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.people_outline_rounded,
                            size: 20,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Kişi',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: hasDateError
                                        ? theme.colorScheme.error
                                        : theme.colorScheme.onSurface
                                            .withValues(alpha: 0.6),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${searchParams.passengerCount} Yolcu',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Smart Date Optimizer Button
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DateOptimizerScreen(),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.indigo.shade50, Colors.blue.shade50],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.indigo.shade200),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.indigo,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.auto_awesome,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            loc.dateOptimizerTitle,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Colors.indigo,
                            ),
                          ),
                          Text(
                            loc.dateOptimizerSubtitle,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.indigo.shade800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.indigo,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Search CTA Buttons Row (Uçuş Ara & Otel Bul)
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        final isValid = ref
                            .read(homeSearchProvider.notifier)
                            .validateAndSubmit();

                        if (isValid) {
                          _saveSearchHistory(ref, searchParams);
                          FlightResultsModal.show(context, searchParams);
                        }
                      },
                      icon: const Icon(Icons.flight_takeoff_rounded, size: 18),
                      label: Text(
                        loc.searchFlights,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        final isValid = ref
                            .read(homeSearchProvider.notifier)
                            .validateAndSubmit();

                        if (isValid) {
                          _saveSearchHistory(ref, searchParams);
                          HotelResultsModal.show(context, searchParams);
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: theme.colorScheme.primary,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      icon: const Icon(Icons.hotel_rounded, size: 18),
                      label: Text(
                        loc.findHotels,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showLocationSearch(BuildContext context, WidgetRef ref,
      {required bool isOrigin}) {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController controller = TextEditingController();
        final popularCities = [
          'İstanbul (IST)',
          'Ankara (ESB)',
          'İzmir (ADB)',
          'Antalya (AYT)',
          'Roma (FCO)',
          'Paris (CDG)',
          'Tokyo (HND)',
          'Londra (LHR)',
          '',
        ];

        return AlertDialog(
          title: Text(isOrigin ? 'Kalkış Noktası Seçin' : 'Varış Noktası Seçin'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Şehir veya Havalimanı ara...',
                  prefixIcon: Icon(Icons.search_rounded),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 200,
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: popularCities.length,
                  itemBuilder: (context, index) {
                    final city = popularCities[index];
                    return ListTile(
                      dense: true,
                      leading: Icon(
                        city.isEmpty
                            ? Icons.cleaning_services_rounded
                            : Icons.location_on_outlined,
                        color: city.isEmpty ? Colors.red : null,
                      ),
                      title: Text(city.isEmpty ? '[Boş Bırak (Test)]' : city),
                      onTap: () {
                        if (isOrigin) {
                          ref
                              .read(homeSearchProvider.notifier)
                              .setOrigin(city);
                        } else {
                          ref
                              .read(homeSearchProvider.notifier)
                              .setDestination(city);
                        }
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Kapat'),
            ),
          ],
        );
      },
    );
  }
}
