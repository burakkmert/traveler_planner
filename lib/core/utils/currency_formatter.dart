import 'package:intl/intl.dart';

/// Central currency converter and formatter utility.
/// Converts base TRY prices to USD ($) or EUR (€) based on active user settings.
class CurrencyFormatter {
  // Approximate exchange rates relative to TRY base pricing
  static const double usdRate = 35.0; // 1 USD = 35 TRY
  static const double eurRate = 38.0; // 1 EUR = 38 TRY

  /// Formats a price (given in TRY or double amount) into the target [currencyCode].
  static String format(double priceInTry, String currencyCode) {
    switch (currencyCode.toUpperCase()) {
      case 'USD':
        final usdAmount = priceInTry / usdRate;
        return '\$${NumberFormat('#,##0', 'en_US').format(usdAmount.round())}';
      case 'EUR':
        final eurAmount = priceInTry / eurRate;
        return '€${NumberFormat('#,##0', 'de_DE').format(eurAmount.round())}';
      case 'TRY':
      default:
        return '₺${NumberFormat('#,##0', 'tr_TR').format(priceInTry.round())}';
    }
  }

  /// Parses price strings like "₺12.450" or numbers and formats to active currency.
  static String formatString(String priceString, String currencyCode) {
    if (priceString.isEmpty) return priceString;
    // Extract numeric digits
    final numericOnly = priceString.replaceAll(RegExp(r'[^\d]'), '');
    if (numericOnly.isEmpty) return priceString;

    final double amountInTry = double.tryParse(numericOnly) ?? 0.0;
    return format(amountInTry, currencyCode);
  }
}
