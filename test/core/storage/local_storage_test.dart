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
  late UserPreferencesRepositoryImpl repository;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('hive_test_dir');
    Hive.init(tempDir.path);
  });

  setUp(() async {
    storageService = LocalStorageService();
    await storageService.init(isTestEnvironment: true);
    repository = UserPreferencesRepositoryImpl(storageService);
  });

  tearDown(() async {
    await storageService.clearSearchHistory();
    await storageService.clearRecentlyViewed();
  });

  tearDownAll(() async {
    await Hive.deleteFromDisk();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('Local Storage & User Preferences Persistence Tests', () {
    test('Saves search history and retrieves correctly', () async {
      const search = RecentSearch(
        id: 's_1',
        origin: 'İstanbul (IST)',
        destination: 'Roma (FCO)',
        dateRangeText: '10-15 Eylül',
        passengerCount: 2,
      );

      await repository.addSearchHistory(search);
      final history = repository.getSearchHistory();

      expect(history.length, greaterThanOrEqualTo(1));
      expect(history.any((s) => s.id == 's_1' && s.destination == 'Roma (FCO)'), isTrue);
    });

    test('Toggles favorite destinations state accurately', () async {
      const dest = Destination(
        id: 'dest_roma',
        title: 'Roma',
        country: 'İtalya',
        imageUrl: 'https://example.com/roma.jpg',
        rating: 4.8,
        priceEstimate: '₺12.450',
        category: 'Kültür',
      );

      expect(repository.isDestinationFavorite('dest_roma'), isFalse);

      await repository.toggleFavoriteDestination(dest);
      expect(repository.isDestinationFavorite('dest_roma'), isTrue);

      final favorites = repository.getFavoriteDestinations();
      expect(favorites.any((f) => f.id == 'dest_roma'), isTrue);

      await repository.toggleFavoriteDestination(dest);
      expect(repository.isDestinationFavorite('dest_roma'), isFalse);
    });

    test('Saves and removes travel plans', () async {
      final plan = SavedTravelPlan(
        id: 'plan_101',
        origin: 'İstanbul',
        destination: 'Paris',
        startDate: DateTime(2026, 9, 1),
        endDate: DateTime(2026, 9, 6),
        strategyLabel: 'En Dengeli',
        totalScore: 94.0,
        totalPrice: 9800.0,
        weatherSummary: 'Güneşli ve Açık (24°C)',
        savedAt: DateTime.now(),
      );

      await repository.saveTravelPlan(plan);
      final plans = repository.getSavedTravelPlans();

      expect(plans.any((p) => p.id == 'plan_101' && p.destination == 'Paris'), isTrue);

      await repository.removeTravelPlan('plan_101');
      final updatedPlans = repository.getSavedTravelPlans();
      expect(updatedPlans.any((p) => p.id == 'plan_101'), isFalse);
    });

    test('Adds recently viewed items and sorts by timestamp', () async {
      final item1 = RecentlyViewedItem(
        id: 'view_1',
        category: 'hotel',
        title: 'Grand Plaza Resort',
        subtitle: 'Roma Merkez',
        priceText: '₺4.250',
        viewedAt: DateTime.now().subtract(const Duration(minutes: 10)),
      );

      final item2 = RecentlyViewedItem(
        id: 'view_2',
        category: 'flight',
        title: 'THY İstanbul - Roma',
        subtitle: 'Direkt Uçuş',
        priceText: '₺3.450',
        viewedAt: DateTime.now(),
      );

      await repository.addRecentlyViewedItem(item1);
      await repository.addRecentlyViewedItem(item2);

      final items = repository.getRecentlyViewedItems();
      expect(items.length, greaterThanOrEqualTo(2));
      // item2 is newer so should come first
      expect(items.first.id, equals('view_2'));
    });

    test('Data persists across app restarts (Simulated Hive Re-open)', () async {
      const search = RecentSearch(
        id: 'persist_search_1',
        origin: 'İzmir',
        destination: 'Atina',
        dateRangeText: '12-16 Ekim',
        passengerCount: 1,
      );

      await repository.addSearchHistory(search);

      // Simulate App Restart by initializing a new storage service instance on same Hive path
      final newStorageService = LocalStorageService();
      await newStorageService.init(isTestEnvironment: true);
      final newRepository = UserPreferencesRepositoryImpl(newStorageService);

      final reloadedHistory = newRepository.getSearchHistory();
      expect(reloadedHistory.any((s) => s.id == 'persist_search_1'), isTrue);
    });
  });
}
