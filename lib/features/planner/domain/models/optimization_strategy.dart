/// Represents user priority preference strategies for travel date evaluation.
enum OptimizationStrategy {
  balanced,
  cheapest,
  bestWeather,
  fastest,
}

extension OptimizationStrategyX on OptimizationStrategy {
  String get label {
    switch (this) {
      case OptimizationStrategy.balanced:
        return 'En Dengeli';
      case OptimizationStrategy.cheapest:
        return 'En Ucuz';
      case OptimizationStrategy.bestWeather:
        return 'En İyi Hava';
      case OptimizationStrategy.fastest:
        return 'En Kısa Yolculuk';
    }
  }

  String get description {
    switch (this) {
      case OptimizationStrategy.balanced:
        return 'Fiyat, hava ve konforun en ideal dengesini sunar.';
      case OptimizationStrategy.cheapest:
        return 'Uçuş ve otel bütçesini önceliklendirir.';
      case OptimizationStrategy.bestWeather:
        return 'En uygun hava şartlarına odaklanır.';
      case OptimizationStrategy.fastest:
        return 'Minimum yolculuk süresi ve az aktarma hedefler.';
    }
  }

  /// Weights for [flightPrice, hotelPrice, weather, duration, transfer]
  /// Sum of all weights is strictly 1.0 (100%).
  ({
    double flightWeight,
    double hotelWeight,
    double weatherWeight,
    double durationWeight,
    double transferWeight,
  }) get weights {
    switch (this) {
      case OptimizationStrategy.balanced:
        return (
          flightWeight: 0.30,
          hotelWeight: 0.25,
          weatherWeight: 0.20,
          durationWeight: 0.15,
          transferWeight: 0.10,
        );
      case OptimizationStrategy.cheapest:
        return (
          flightWeight: 0.45,
          hotelWeight: 0.35,
          weatherWeight: 0.10,
          durationWeight: 0.05,
          transferWeight: 0.05,
        );
      case OptimizationStrategy.bestWeather:
        return (
          flightWeight: 0.15,
          hotelWeight: 0.15,
          weatherWeight: 0.50,
          durationWeight: 0.10,
          transferWeight: 0.10,
        );
      case OptimizationStrategy.fastest:
        return (
          flightWeight: 0.15,
          hotelWeight: 0.10,
          weatherWeight: 0.10,
          durationWeight: 0.40,
          transferWeight: 0.25,
        );
    }
  }
}
