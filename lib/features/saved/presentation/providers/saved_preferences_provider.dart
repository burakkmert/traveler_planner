import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/storage/local_storage_service.dart';
import '../../../home/data/mock_home_data.dart';
import '../../../home/domain/models/destination.dart';
import '../../../home/domain/models/recent_search.dart';
import '../../data/repositories/user_preferences_repository_impl.dart';
import '../../domain/models/recently_viewed_item.dart';
import '../../domain/models/saved_travel_plan.dart';
import '../../domain/repositories/user_preferences_repository.dart';

class SavedPreferencesState {
  final List<RecentSearch> searchHistory;
  final List<Destination> favoriteDestinations;
  final List<SavedTravelPlan> savedTravelPlans;
  final List<RecentlyViewedItem> recentlyViewedItems;
  final bool isInitialized;

  const SavedPreferencesState({
    this.searchHistory = const [],
    this.favoriteDestinations = const [],
    this.savedTravelPlans = const [],
    this.recentlyViewedItems = const [],
    this.isInitialized = false,
  });

  SavedPreferencesState copyWith({
    List<RecentSearch>? searchHistory,
    List<Destination>? favoriteDestinations,
    List<SavedTravelPlan>? savedTravelPlans,
    List<RecentlyViewedItem>? recentlyViewedItems,
    bool? isInitialized,
  }) {
    return SavedPreferencesState(
      searchHistory: searchHistory ?? this.searchHistory,
      favoriteDestinations: favoriteDestinations ?? this.favoriteDestinations,
      savedTravelPlans: savedTravelPlans ?? this.savedTravelPlans,
      recentlyViewedItems: recentlyViewedItems ?? this.recentlyViewedItems,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }
}

class SavedPreferencesNotifier extends StateNotifier<SavedPreferencesState> {
  final UserPreferencesRepository _repository;

  SavedPreferencesNotifier(this._repository) : super(const SavedPreferencesState()) {
    loadPreferences();
  }

  void loadPreferences() {
    var history = _repository.getSearchHistory();
    if (history.isEmpty) {
      for (final mockSearch in MockHomeData.recentSearches) {
        _repository.addSearchHistory(mockSearch);
      }
      history = _repository.getSearchHistory();
    }

    final favorites = _repository.getFavoriteDestinations();
    final plans = _repository.getSavedTravelPlans();
    final recent = _repository.getRecentlyViewedItems();

    state = state.copyWith(
      searchHistory: history,
      favoriteDestinations: favorites,
      savedTravelPlans: plans,
      recentlyViewedItems: recent,
      isInitialized: true,
    );
  }

  Future<void> addSearchHistory(RecentSearch search) async {
    await _repository.addSearchHistory(search);
    loadPreferences();
  }

  Future<void> clearSearchHistory() async {
    await _repository.clearSearchHistory();
    loadPreferences();
  }

  Future<void> toggleFavoriteDestination(Destination destination) async {
    await _repository.toggleFavoriteDestination(destination);
    loadPreferences();
  }

  Future<void> saveTravelPlan(SavedTravelPlan plan) async {
    await _repository.saveTravelPlan(plan);
    loadPreferences();
  }

  Future<void> removeTravelPlan(String id) async {
    await _repository.removeTravelPlan(id);
    loadPreferences();
  }

  Future<void> addRecentlyViewed(RecentlyViewedItem item) async {
    await _repository.addRecentlyViewedItem(item);
    loadPreferences();
  }

  bool isFavoriteDestination(String id) {
    return state.favoriteDestinations.any((d) => d.id == id);
  }
}

final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  final service = LocalStorageService();
  service.init();
  return service;
});

final userPreferencesRepositoryProvider = Provider<UserPreferencesRepository>((ref) {
  final storageService = ref.watch(localStorageServiceProvider);
  return UserPreferencesRepositoryImpl(storageService);
});

final savedPreferencesProvider =
    StateNotifierProvider<SavedPreferencesNotifier, SavedPreferencesState>((ref) {
  final repo = ref.watch(userPreferencesRepositoryProvider);
  return SavedPreferencesNotifier(repo);
});
