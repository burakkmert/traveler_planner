import '../../../../core/storage/local_storage_service.dart';
import '../../../home/domain/models/destination.dart';
import '../../../home/domain/models/recent_search.dart';
import '../../domain/models/recently_viewed_item.dart';
import '../../domain/models/saved_travel_plan.dart';
import '../../domain/repositories/user_preferences_repository.dart';

class UserPreferencesRepositoryImpl implements UserPreferencesRepository {
  final LocalStorageService _storageService;

  UserPreferencesRepositoryImpl(this._storageService);

  @override
  List<RecentSearch> getSearchHistory() {
    final raw = _storageService.getSearchHistory();
    return raw.map((json) => RecentSearch.fromJson(json)).toList();
  }

  @override
  Future<void> addSearchHistory(RecentSearch search) async {
    await _storageService.saveSearchHistoryItem(search.toJson());
  }

  @override
  Future<void> clearSearchHistory() async {
    await _storageService.clearSearchHistory();
  }

  @override
  List<Destination> getFavoriteDestinations() {
    final raw = _storageService.getFavoriteDestinations();
    return raw.map((json) => Destination.fromJson(json)).toList();
  }

  @override
  Future<void> toggleFavoriteDestination(Destination destination) async {
    await _storageService.toggleFavoriteDestination(destination.toJson());
  }

  @override
  bool isDestinationFavorite(String id) {
    return _storageService.isDestinationFavorite(id);
  }

  @override
  List<SavedTravelPlan> getSavedTravelPlans() {
    final raw = _storageService.getSavedTravelPlans();
    return raw.map((json) => SavedTravelPlan.fromJson(json)).toList();
  }

  @override
  Future<void> saveTravelPlan(SavedTravelPlan plan) async {
    await _storageService.saveTravelPlan(plan.toJson());
  }

  @override
  Future<void> removeTravelPlan(String id) async {
    await _storageService.removeTravelPlan(id);
  }

  @override
  List<RecentlyViewedItem> getRecentlyViewedItems() {
    final raw = _storageService.getRecentlyViewedItems();
    return raw.map((json) => RecentlyViewedItem.fromJson(json)).toList();
  }

  @override
  Future<void> addRecentlyViewedItem(RecentlyViewedItem item) async {
    await _storageService.addRecentlyViewedItem(item.toJson());
  }

  @override
  Future<void> clearRecentlyViewed() async {
    await _storageService.clearRecentlyViewed();
  }
}
