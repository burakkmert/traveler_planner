import '../../../planner/domain/models/optimization_strategy.dart';

/// Data class representing user application settings and preferences.
class AppSettings {
  final String themeModeStr; // 'dark', 'light', 'system'
  final String languageCode; // 'tr', 'en'
  final String currencyCode; // 'TRY', 'USD', 'EUR'
  final bool priceAlertsEnabled;
  final bool flightRemindersEnabled;
  final bool promotionsEnabled;
  final int defaultPassengerCount;
  final OptimizationStrategy defaultStrategy;

  const AppSettings({
    this.themeModeStr = 'dark',
    this.languageCode = 'tr',
    this.currencyCode = 'TRY',
    this.priceAlertsEnabled = true,
    this.flightRemindersEnabled = true,
    this.promotionsEnabled = false,
    this.defaultPassengerCount = 1,
    this.defaultStrategy = OptimizationStrategy.balanced,
  });

  AppSettings copyWith({
    String? themeModeStr,
    String? languageCode,
    String? currencyCode,
    bool? priceAlertsEnabled,
    bool? flightRemindersEnabled,
    bool? promotionsEnabled,
    int? defaultPassengerCount,
    OptimizationStrategy? defaultStrategy,
  }) {
    return AppSettings(
      themeModeStr: themeModeStr ?? this.themeModeStr,
      languageCode: languageCode ?? this.languageCode,
      currencyCode: currencyCode ?? this.currencyCode,
      priceAlertsEnabled: priceAlertsEnabled ?? this.priceAlertsEnabled,
      flightRemindersEnabled: flightRemindersEnabled ?? this.flightRemindersEnabled,
      promotionsEnabled: promotionsEnabled ?? this.promotionsEnabled,
      defaultPassengerCount: defaultPassengerCount ?? this.defaultPassengerCount,
      defaultStrategy: defaultStrategy ?? this.defaultStrategy,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'themeModeStr': themeModeStr,
      'languageCode': languageCode,
      'currencyCode': currencyCode,
      'priceAlertsEnabled': priceAlertsEnabled,
      'flightRemindersEnabled': flightRemindersEnabled,
      'promotionsEnabled': promotionsEnabled,
      'defaultPassengerCount': defaultPassengerCount,
      'defaultStrategy': defaultStrategy.name,
    };
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      themeModeStr: json['themeModeStr'] as String? ?? 'dark',
      languageCode: json['languageCode'] as String? ?? 'tr',
      currencyCode: json['currencyCode'] as String? ?? 'TRY',
      priceAlertsEnabled: json['priceAlertsEnabled'] as bool? ?? true,
      flightRemindersEnabled: json['flightRemindersEnabled'] as bool? ?? true,
      promotionsEnabled: json['promotionsEnabled'] as bool? ?? false,
      defaultPassengerCount: json['defaultPassengerCount'] as int? ?? 1,
      defaultStrategy: OptimizationStrategy.values.firstWhere(
        (s) => s.name == json['defaultStrategy'],
        orElse: () => OptimizationStrategy.balanced,
      ),
    );
  }
}
