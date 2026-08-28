import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:travel_app/core/storage/local_storage_service.dart';
import 'package:travel_app/features/planner/domain/models/optimization_strategy.dart';
import 'package:travel_app/features/profile/domain/models/app_settings.dart';

void main() {
  late Directory tempDir;
  late LocalStorageService storageService;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('settings_hive_test');
    Hive.init(tempDir.path);
  });

  setUp(() async {
    storageService = LocalStorageService();
    await storageService.init(isTestEnvironment: true);
  });

  tearDownAll(() async {
    await Hive.deleteFromDisk();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('AppSettings & Storage Persistence Unit Tests', () {
    test('Default AppSettings initializes with sensible defaults', () {
      const settings = AppSettings();

      expect(settings.themeModeStr, equals('dark'));
      expect(settings.languageCode, equals('tr'));
      expect(settings.currencyCode, equals('TRY'));
      expect(settings.priceAlertsEnabled, isTrue);
      expect(settings.flightRemindersEnabled, isTrue);
      expect(settings.promotionsEnabled, isFalse);
      expect(settings.defaultPassengerCount, equals(1));
      expect(settings.defaultStrategy, equals(OptimizationStrategy.balanced));
    });

    test('AppSettings JSON serialization and deserialization is accurate', () {
      final original = const AppSettings().copyWith(
        themeModeStr: 'light',
        languageCode: 'en',
        currencyCode: 'USD',
        priceAlertsEnabled: false,
        defaultPassengerCount: 3,
        defaultStrategy: OptimizationStrategy.cheapest,
      );

      final json = original.toJson();
      final parsed = AppSettings.fromJson(json);

      expect(parsed.themeModeStr, equals('light'));
      expect(parsed.languageCode, equals('en'));
      expect(parsed.currencyCode, equals('USD'));
      expect(parsed.priceAlertsEnabled, isFalse);
      expect(parsed.defaultPassengerCount, equals(3));
      expect(parsed.defaultStrategy, equals(OptimizationStrategy.cheapest));
    });

    test('Settings save and reload from LocalStorageService (App Restart Simulation)', () async {
      final customSettings = const AppSettings().copyWith(
        themeModeStr: 'system',
        languageCode: 'tr',
        currencyCode: 'EUR',
        promotionsEnabled: true,
        defaultPassengerCount: 4,
        defaultStrategy: OptimizationStrategy.bestWeather,
      );

      await storageService.saveAppSettings(customSettings.toJson());

      // Simulate App Restart by opening a new LocalStorageService instance
      final reloadedStorage = LocalStorageService();
      await reloadedStorage.init(isTestEnvironment: true);

      final reloadedMap = reloadedStorage.getAppSettings();
      expect(reloadedMap, isNotNull);

      final loadedSettings = AppSettings.fromJson(reloadedMap!);
      expect(loadedSettings.currencyCode, equals('EUR'));
      expect(loadedSettings.promotionsEnabled, isTrue);
      expect(loadedSettings.defaultPassengerCount, equals(4));
      expect(loadedSettings.defaultStrategy, equals(OptimizationStrategy.bestWeather));
    });
  });
}
