import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/storage/local_storage_service.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../planner/domain/models/optimization_strategy.dart';
import '../../../saved/presentation/providers/saved_preferences_provider.dart';
import '../../domain/models/app_settings.dart';

class SettingsNotifier extends StateNotifier<AppSettings> {
  final LocalStorageService _storageService;
  final Ref _ref;

  SettingsNotifier(this._storageService, this._ref) : super(const AppSettings()) {
    _loadSettings();
  }

  void _loadSettings() {
    final jsonMap = _storageService.getAppSettings();
    if (jsonMap != null) {
      state = AppSettings.fromJson(jsonMap);
    }
    _syncThemeWithSystem();
  }

  void _syncThemeWithSystem() {
    ThemeMode mode;
    switch (state.themeModeStr) {
      case 'light':
        mode = ThemeMode.light;
        break;
      case 'system':
        mode = ThemeMode.system;
        break;
      case 'dark':
      default:
        mode = ThemeMode.dark;
        break;
    }
    _ref.read(themeProvider.notifier).setThemeMode(mode);
  }

  Future<void> _updateAndPersist(AppSettings newSettings) async {
    state = newSettings;
    await _storageService.saveAppSettings(newSettings.toJson());
    _syncThemeWithSystem();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    String modeStr = 'dark';
    if (mode == ThemeMode.light) modeStr = 'light';
    if (mode == ThemeMode.system) modeStr = 'system';

    await _updateAndPersist(state.copyWith(themeModeStr: modeStr));
  }

  Future<void> setLanguage(String languageCode) async {
    await _updateAndPersist(state.copyWith(languageCode: languageCode));
  }

  Future<void> setCurrency(String currencyCode) async {
    await _updateAndPersist(state.copyWith(currencyCode: currencyCode));
  }

  Future<void> togglePriceAlerts(bool value) async {
    await _updateAndPersist(state.copyWith(priceAlertsEnabled: value));
  }

  Future<void> toggleFlightReminders(bool value) async {
    await _updateAndPersist(state.copyWith(flightRemindersEnabled: value));
  }

  Future<void> togglePromotions(bool value) async {
    await _updateAndPersist(state.copyWith(promotionsEnabled: value));
  }

  Future<void> setDefaultPassengerCount(int count) async {
    if (count < 1 || count > 9) return;
    await _updateAndPersist(state.copyWith(defaultPassengerCount: count));
  }

  Future<void> setDefaultStrategy(OptimizationStrategy strategy) async {
    await _updateAndPersist(state.copyWith(defaultStrategy: strategy));
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
  final storageService = ref.watch(localStorageServiceProvider);
  return SettingsNotifier(storageService, ref);
});
