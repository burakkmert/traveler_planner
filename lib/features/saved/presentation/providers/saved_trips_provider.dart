import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/saved_trip.dart';

/// Riverpod StateNotifier managing the user's saved trip itineraries.
class SavedTripsNotifier extends StateNotifier<List<SavedTrip>> {
  SavedTripsNotifier()
      : super([
          SavedTrip(
            id: 'saved_1',
            title: 'Roma Tarih & Kültür Turu',
            destination: 'Roma (FCO)',
            durationText: '3 Gün 2 Gece',
            estimatedCost: '₺12.450',
            savedAt: DateTime.now().subtract(const Duration(days: 1)),
          ),
        ]);

  void addTrip(SavedTrip trip) {
    if (!state.any((t) => t.id == trip.id || t.title == trip.title)) {
      state = [trip, ...state];
    }
  }

  void removeTrip(String id) {
    state = state.where((t) => t.id != id).toList();
  }

  bool isTripSaved(String title) {
    return state.any((t) => t.title == title);
  }
}

/// Global Riverpod Provider for Saved Trips.
final savedTripsProvider =
    StateNotifierProvider<SavedTripsNotifier, List<SavedTrip>>((ref) {
  return SavedTripsNotifier();
});
