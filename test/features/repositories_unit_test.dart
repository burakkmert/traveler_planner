import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:travel_app/core/storage/local_storage_service.dart';
import 'package:travel_app/features/home/domain/models/destination.dart';
import 'package:travel_app/features/home/domain/models/recent_search.dart';
import 'package:travel_app/features/saved/data/repositories/user_preferences_repository_impl.dart';
import 'package:travel_app/features/saved/domain/models/recently_viewed_item.dart';
import 'package:travel_app/features/saved/domain/models/saved_travel_plan.dart';

void main() {
  late Directory tempDir;
  late LocalStorageService storageService;
  late UserPreferencesRepositoryImpl repo;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('repo_hive_test');
    Hive.init(tempDir.path);
  });

  setUp(() async {
    storageService = LocalStorageService();
    await storageService.init(isTestEnvironment: true);
    repo = UserPreferencesRepositoryImpl(storageService);
  });

  tearDownAll(() async {
    await Hive.deleteFromDisk();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('UserPreferencesRepository Unit Tests', () {
    test('Saves and retrieves search history items', () async {
      const item = RecentSearch(
        id: 'search-101',
        origin: 'İstanbul',
        destination: 'Atina',
        dateRangeText: '10-15 Ekim',
        passengerCount: 2,
      );

      await repo.addSearchHistory(item);
      final history = repo.getSearchHistory();

      expect(history.length, equals(1));
      expect(history.first.origin, equals('İstanbul'));
      expect(history.first.destination, equals('Atina'));

      await repo.clearSearchHistory();
      final clearedHistory = repo.getSearchHistory();
      expect(clearedHistory, isEmpty);
    });

    test('Toggles favorite destinations and checks isDestinationFavorite status', () async {
      const destination = Destination(
        id: 'dest-roma',
        title: 'Roma',
        country: 'İtalya',
        category: 'Tarih',
        rating: 4.8,
        priceEstimate: '₺12.450',
        imageUrl: 'https://example.com/roma.jpg',
      );

      expect(repo.isDestinationFavorite('dest-roma'), isFalse);

      await repo.toggleFavoriteDestination(destination);
      expect(repo.isDestinationFavorite('dest-roma'), isTrue);

      final favorites = repo.getFavoriteDestinations();
      expect(favorites.map((d) => d.id), contains('dest-roma'));

      await repo.toggleFavoriteDestination(destination);
      expect(repo.isDestinationFavorite('dest-roma'), isFalse);
    });

    test('Saves and removes travel plans', () async {
      final plan = SavedTravelPlan(
        id: 'plan-99',
        origin: 'İstanbul',
        destination: 'Atina',
        startDate: DateTime.now().add(const Duration(days: 10)),
        endDate: DateTime.now().add(const Duration(days: 14)),
        strategyLabel: 'En Dengeli',
        totalScore: 88.0,
        totalPrice: 8900.0,
        weatherSummary: 'Güneşli',
        savedAt: DateTime.now(),
      );

      await repo.saveTravelPlan(plan);
      var plans = repo.getSavedTravelPlans();
      expect(plans.length, equals(1));
      expect(plans.first.destination, equals('Atina'));

      await repo.removeTravelPlan('plan-99');
      plans = repo.getSavedTravelPlans();
      expect(plans, isEmpty);
    });

    test('Adds recently viewed items and fetches list', () async {
      final item = RecentlyViewedItem(
        id: 'rv-paris',
        category: 'destination',
        title: 'Paris, Fransa',
        subtitle: 'Romantizm Başkenti',
        priceText: '₺14.500',
        imageUrl: '',
        viewedAt: DateTime.now(),
      );

      await repo.addRecentlyViewedItem(item);
      final viewed = repo.getRecentlyViewedItems();
      expect(viewed.length, equals(1));
      expect(viewed.first.title, equals('Paris, Fransa'));

      await repo.clearRecentlyViewed();
      final clearedViewed = repo.getRecentlyViewedItems();
      expect(clearedViewed, isEmpty);
    });
  });
}
