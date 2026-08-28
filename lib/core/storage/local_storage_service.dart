import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';

/// Central Local Storage Service handling persistent client data.
/// Uses Hive NoSQL key-value boxes for instant disk access across mobile/web/desktop.
class LocalStorageService {
  static const String searchHistoryBoxName = 'search_history_box';
  static const String favoriteDestinationsBoxName = 'favorite_destinations_box';
  static const String savedTravelPlansBoxName = 'saved_travel_plans_box';
  static const String recentlyViewedBoxName = 'recently_viewed_box';
  static const String appSettingsBoxName = 'app_settings_box';

  Box<String>? _searchHistoryBox;
  Box<String>? _favoriteDestinationsBox;
  Box<String>? _savedTravelPlansBox;
  Box<String>? _recentlyViewedBox;
  Box<String>? _settingsBox;

  bool _isInitialized = false;

  /// Initializes Hive storage boxes.
  Future<void> init({bool isTestEnvironment = false}) async {
    if (_isInitialized) return;

    if (!isTestEnvironment) {
      try {
        await Hive.initFlutter();
      } catch (_) {
        // Already initialized or running in pure Dart environment
      }
    }

    _searchHistoryBox = await _openBoxSafe(searchHistoryBoxName);
    _favoriteDestinationsBox = await _openBoxSafe(favoriteDestinationsBoxName);
    _savedTravelPlansBox = await _openBoxSafe(savedTravelPlansBoxName);
    _recentlyViewedBox = await _openBoxSafe(recentlyViewedBoxName);
    _settingsBox = await _openBoxSafe(appSettingsBoxName);

    _isInitialized = true;
  }

  Future<Box<String>> _openBoxSafe(String boxName) async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<String>(boxName);
    }
    try {
      return await Hive.openBox<String>(boxName);
    } catch (_) {
      // In case of schema corruption or pure memory fallback
      return await Hive.openBox<String>('${boxName}_fallback');
    }
  }

  // --- Search History Operations ---

  List<Map<String, dynamic>> getSearchHistory() {
    if (_searchHistoryBox == null) return [];
    return _searchHistoryBox!.values
        .map((jsonStr) => json.decode(jsonStr) as Map<String, dynamic>)
        .toList();
  }

  static const int maxSearchHistoryItems = 20;

  Future<void> saveSearchHistoryItem(Map<String, dynamic> item) async {
    if (_searchHistoryBox == null) return;
    final rawKey = item['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString();
    final key = rawKey.replaceAll(RegExp(r'[^\w\.-]'), '_');

    await _searchHistoryBox!.put(key, json.encode(item));

    // Cap storage size to prevent memory/storage leaks
    if (_searchHistoryBox!.length > maxSearchHistoryItems) {
      final keysToDelete = _searchHistoryBox!.keys
          .take(_searchHistoryBox!.length - maxSearchHistoryItems)
          .toList();
      await _searchHistoryBox!.deleteAll(keysToDelete);
    }
  }

  Future<void> clearSearchHistory() async {
    await _searchHistoryBox?.clear();
  }

  // --- Favorite Destinations Operations ---

  List<Map<String, dynamic>> getFavoriteDestinations() {
    if (_favoriteDestinationsBox == null) return [];
    return _favoriteDestinationsBox!.values
        .map((jsonStr) => json.decode(jsonStr) as Map<String, dynamic>)
        .toList();
  }

  Future<void> toggleFavoriteDestination(Map<String, dynamic> item) async {
    if (_favoriteDestinationsBox == null) return;
    final id = item['id'].toString();
    if (_favoriteDestinationsBox!.containsKey(id)) {
      await _favoriteDestinationsBox!.delete(id);
    } else {
      await _favoriteDestinationsBox!.put(id, json.encode(item));
    }
  }

  bool isDestinationFavorite(String id) {
    return _favoriteDestinationsBox?.containsKey(id) ?? false;
  }

  // --- Saved Travel Plans Operations ---

  List<Map<String, dynamic>> getSavedTravelPlans() {
    if (_savedTravelPlansBox == null) return [];
    return _savedTravelPlansBox!.values
        .map((jsonStr) => json.decode(jsonStr) as Map<String, dynamic>)
        .toList();
  }

  Future<void> saveTravelPlan(Map<String, dynamic> plan) async {
    if (_savedTravelPlansBox == null) return;
    final id = plan['id'].toString();
    await _savedTravelPlansBox!.put(id, json.encode(plan));
  }

  Future<void> removeTravelPlan(String id) async {
    await _savedTravelPlansBox?.delete(id);
  }

  // --- Recently Viewed Items Operations ---

  List<Map<String, dynamic>> getRecentlyViewedItems() {
    if (_recentlyViewedBox == null) return [];
    final items = _recentlyViewedBox!.values
        .map((jsonStr) => json.decode(jsonStr) as Map<String, dynamic>)
        .toList();

    // Sort descending by viewedAt timestamp
    items.sort((a, b) {
      final aTime = a['viewedAt'] as int? ?? 0;
      final bTime = b['viewedAt'] as int? ?? 0;
      return bTime.compareTo(aTime);
    });

    return items;
  }

  Future<void> addRecentlyViewedItem(Map<String, dynamic> item) async {
    if (_recentlyViewedBox == null) return;
    final id = item['id'].toString();
    final updatedItem = Map<String, dynamic>.from(item);
    if (!updatedItem.containsKey('viewedAt') || updatedItem['viewedAt'] == null) {
      updatedItem['viewedAt'] = DateTime.now().millisecondsSinceEpoch;
    }
    await _recentlyViewedBox!.put(id, json.encode(updatedItem));
  }

  Future<void> clearRecentlyViewed() async {
    await _recentlyViewedBox?.clear();
  }

  // --- App Settings Operations ---

  Map<String, dynamic>? getAppSettings() {
    if (_settingsBox == null || !_settingsBox!.containsKey('user_settings')) return null;
    final jsonStr = _settingsBox!.get('user_settings');
    if (jsonStr == null) return null;
    return json.decode(jsonStr) as Map<String, dynamic>;
  }

  Future<void> saveAppSettings(Map<String, dynamic> settingsMap) async {
    if (_settingsBox == null) return;
    await _settingsBox!.put('user_settings', json.encode(settingsMap));
  }
}
