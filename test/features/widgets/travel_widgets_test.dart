import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:travel_app/core/storage/local_storage_service.dart';
import 'package:travel_app/features/home/domain/models/recent_search.dart';
import 'package:travel_app/features/home/presentation/widgets/recent_searches_widget.dart';
import 'package:travel_app/features/planner/domain/models/optimized_date_result.dart';
import 'package:travel_app/features/planner/domain/models/raw_date_candidate.dart';
import 'package:travel_app/features/planner/presentation/widgets/date_candidate_card.dart';
import 'package:travel_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:travel_app/features/saved/presentation/providers/saved_preferences_provider.dart';

void main() {
  late Directory tempDir;
  late LocalStorageService storageService;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('widget_hive_test');
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

  Widget createWidgetForTesting(Widget child, {List<Override> overrides = const []}) {
    return ProviderScope(
      overrides: [
        localStorageServiceProvider.overrideWithValue(storageService),
        ...overrides,
      ],
      child: MaterialApp(
        theme: ThemeData(
          splashFactory: NoSplash.splashFactory,
        ),
        home: Scaffold(body: child),
      ),
    );
  }

  group('Travel App Widget Tests', () {
    testWidgets('DateCandidateCard renders rank, score, dates and responds to tap', (WidgetTester tester) async {
      bool tapped = false;
      final now = DateTime(2026, 9, 1);
      final candidate = RawDateCandidate(
        id: 'c1',
        startDate: now,
        endDate: now.add(const Duration(days: 4)),
        flightPrice: 2500.0,
        hotelPrice: 3000.0,
        weatherScore: 90.0,
        travelDurationHours: 3.0,
        transferCount: 0,
        weatherSummary: 'İdeal Ilık Hava',
      );

      final result = OptimizedDateResult(
        candidate: candidate,
        totalScore: 92.0,
        flightScore: 0.9,
        hotelScore: 0.85,
        weatherScore: 0.95,
        durationScore: 1.0,
        transferScore: 1.0,
        rank: 1,
      );

      await tester.pumpWidget(
        createWidgetForTesting(
          DateCandidateCard(
            result: result,
            isSelected: true,
            onTap: () {
              tapped = true;
            },
          ),
        ),
      );

      expect(find.text('En İdeal Seçenek'), findsOneWidget);
      expect(find.text('Skor: 92/100'), findsOneWidget);
      expect(find.text('4 Gece Konaklama'), findsOneWidget);

      await tester.tap(find.byType(DateCandidateCard));
      expect(tapped, isTrue);
    });

    testWidgets('RecentSearchesWidget displays history items and handles clear button', (WidgetTester tester) async {
      const searchItem = RecentSearch(
        id: 'search-widget-1',
        origin: 'İstanbul (IST)',
        destination: 'Roma (FCO)',
        dateRangeText: '10-15 Eylül',
        passengerCount: 2,
      );

      await storageService.saveSearchHistoryItem(searchItem.toJson());

      await tester.pumpWidget(
        createWidgetForTesting(const RecentSearchesWidget()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Son Aramalarınız'), findsOneWidget);
      expect(find.text('İstanbul (IST) ➔ Roma (FCO)'), findsOneWidget);

      // Tap clear button
      await tester.tap(find.text('Temizle'));
      await tester.pumpAndSettle();

      expect(storageService.getSearchHistory(), isEmpty);
    });

    testWidgets('ProfileScreen renders profile card, theme segments, and settings sections', (WidgetTester tester) async {
      await tester.pumpWidget(
        createWidgetForTesting(const ProfileScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Profil ve Ayarlar'), findsOneWidget);
      expect(find.text('Ahmet Yılmaz'), findsOneWidget);
      expect(find.text('Görünüm & Tema'), findsOneWidget);
      expect(find.text('Dil & Para Birimi'), findsOneWidget);
      expect(find.text('Koyu'), findsOneWidget);
      expect(find.text('Açık'), findsOneWidget);
    });
  });
}
