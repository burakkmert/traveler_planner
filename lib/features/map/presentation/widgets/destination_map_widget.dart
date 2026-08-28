import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/map_provider.dart';
import '../../../home/presentation/providers/home_search_provider.dart';

class DestinationMapWidget extends ConsumerStatefulWidget {
  final String? overrideCity;

  const DestinationMapWidget({
    super.key,
    this.overrideCity,
  });

  @override
  ConsumerState<DestinationMapWidget> createState() =>
      _DestinationMapWidgetState();
}

class _DestinationMapWidgetState extends ConsumerState<DestinationMapWidget> {
  int _zoomLevel = 13;

  void _zoomIn() {
    setState(() {
      if (_zoomLevel < 17) _zoomLevel += 1;
    });
  }

  void _zoomOut() {
    setState(() {
      if (_zoomLevel > 3) _zoomLevel -= 1;
    });
  }

  /// Converts Latitude/Longitude and Zoom level to Web Mercator Tile (X, Y) coordinates.
  (int, int) _latLngToTile(double lat, double lng, int zoom) {
    final n = pow(2, zoom);
    final xTile = ((lng + 180.0) / 360.0 * n).floor();
    final latRad = lat * pi / 180.0;
    final yTile =
        ((1.0 - (log(tan(latRad) + (1 / cos(latRad))) / pi)) / 2.0 * n).floor();
    return (xTile, yTile);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final searchParams = ref.watch(homeSearchProvider).params;

    final targetCity = widget.overrideCity ??
        (searchParams.destination.isNotEmpty
            ? searchParams.destination
            : 'Roma (FCO)');

    final locationAsync = ref.watch(destinationLocationProvider(targetCity));

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: locationAsync.when(
        data: (location) {
          final centerTile = _latLngToTile(
              location.latitude, location.longitude, _zoomLevel);
          final int cx = centerTile.$1;
          final int cy = centerTile.$2;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Real Interactive CartoDB Voyager Street & Land Tile Map Container
              Container(
                height: 280,
                width: double.infinity,
                color: const Color(0xFFE5E3DF),
                child: Stack(
                  children: [
                    // 3x3 Real Tile Grid Renderer (CORS-friendly CartoDB Voyager tiles)
                    ClipRect(
                      child: OverflowBox(
                        maxWidth: 768,
                        maxHeight: 768,
                        child: SizedBox(
                          width: 768,
                          height: 768,
                          child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                            ),
                            itemCount: 9,
                            itemBuilder: (context, index) {
                              final dx = (index % 3) - 1;
                              final dy = (index ~/ 3) - 1;
                              final tileX = cx + dx;
                              final tileY = cy + dy;

                              final tileUrl =
                                  'https://basemaps.cartocdn.com/rastertiles/voyager/$_zoomLevel/$tileX/$tileY.png';

                              return Image.network(
                                tileUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Image.network(
                                  'https://tile.openstreetmap.org/$_zoomLevel/$tileX/$tileY.png',
                                  fit: BoxFit.cover,
                                  errorBuilder: (c, e, s) => Container(
                                    color: const Color(0xFFE5E3DF),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),

                    // Soft Overlay for Dark/Light Theme Integration
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withValues(alpha: 0.25),
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.45),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),

                    // Center Pin Marker with City Badge Overlay
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // City Badge Overlay
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.35),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Text(
                              '${location.city}, ${location.country}',
                              style: TextStyle(
                                color: theme.colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          // Pulsing Red/Primary Pin Marker
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.35),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: const CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.redAccent,
                              child: Icon(
                                Icons.location_on_rounded,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Map Coordinates Overlay Badge
                    Positioned(
                      bottom: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.my_location_rounded,
                                size: 14, color: Colors.amber),
                            const SizedBox(width: 6),
                            Text(
                              location.formattedCoordinates,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Zoom Controls (+ / -)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Column(
                        children: [
                          FloatingActionButton.small(
                            heroTag: 'mapZoomInBtn',
                            elevation: 3,
                            backgroundColor: theme.colorScheme.surface,
                            foregroundColor: theme.colorScheme.onSurface,
                            onPressed: _zoomIn,
                            child: const Icon(Icons.add_rounded),
                          ),
                          const SizedBox(height: 8),
                          FloatingActionButton.small(
                            heroTag: 'mapZoomOutBtn',
                            elevation: 3,
                            backgroundColor: theme.colorScheme.surface,
                            foregroundColor: theme.colorScheme.onSurface,
                            onPressed: _zoomOut,
                            child: const Icon(Icons.remove_rounded),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Location Info & Attractions Body
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Destinasyon Harita Bilgisi',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary
                                .withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            location.countryCode,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      location.description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.8),
                      ),
                    ),
                    if (location.popularAttractions.isNotEmpty) ...[
                      const SizedBox(height: 14),
                      Text(
                        'Popüler Gezi Durakları',
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: location.popularAttractions
                            .map(
                              (attraction) => Chip(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                labelPadding: EdgeInsets.zero,
                                avatar:
                                    const Icon(Icons.place_rounded, size: 14),
                                label: Text(
                                  attraction,
                                  style: const TextStyle(fontSize: 11),
                                ),
                                backgroundColor: theme
                                    .colorScheme.surfaceContainerHighest
                                    .withValues(alpha: 0.4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const SizedBox(
          height: 280,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 12),
                Text('Gerçek Şehir Haritası Yükleniyor...'),
              ],
            ),
          ),
        ),
        error: (err, stack) => SizedBox(
          height: 180,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.map_rounded, color: Colors.orange, size: 36),
                const SizedBox(height: 8),
                Text('Harita konumu alınamadı: $err'),
                TextButton(
                  onPressed: () =>
                      ref.invalidate(destinationLocationProvider(targetCity)),
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
