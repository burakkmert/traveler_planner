import '../../../home/domain/models/destination.dart';
import '../../../home/domain/models/recent_search.dart';
import '../models/recently_viewed_item.dart';
import '../models/saved_travel_plan.dart';

abstract class UserPreferencesRepository {
  // Search History
  List<RecentSearch> getSearchHistory();
  Future<void> addSearchHistory(RecentSearch search);
  Future<void> clearSearchHistory();

  // Favorite Destinations
  List<Destination> getFavoriteDestinations();
  Future<void> toggleFavoriteDestination(Destination destination);
  bool isDestinationFavorite(String id);

  // Saved Travel Plans
  List<SavedTravelPlan> getSavedTravelPlans();
  Future<void> saveTravelPlan(SavedTravelPlan plan);
  Future<void> removeTravelPlan(String id);

  // Recently Viewed Items
  List<RecentlyViewedItem> getRecentlyViewedItems();
  Future<void> addRecentlyViewedItem(RecentlyViewedItem item);
  Future<void> clearRecentlyViewed();
}
