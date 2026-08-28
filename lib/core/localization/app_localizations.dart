import 'package:intl/intl.dart';

/// Lightweight internationalization dictionary for English & Turkish languages.
class AppLocalizations {
  final String languageCode;

  const AppLocalizations(this.languageCode);

  bool get isTurkish => languageCode == 'tr';

  // Navigation & Tab Labels
  String get appTitle => isTurkish ? 'Seyahat Planlayıcı' : 'Travel Planner';
  String get homeTab => isTurkish ? 'Ana Sayfa' : 'Home';
  String get exploreTab => isTurkish ? 'Keşfet' : 'Explore';
  String get savedTab => isTurkish ? 'Kaydedilenler' : 'Saved';
  String get profileTab => isTurkish ? 'Profil & Ayarlar' : 'Profile & Settings';

  // Home Screen Header & Weather
  String get welcomeGreeting => isTurkish ? 'Nereye Seyahat Etmek İstersin?' : 'Where Would You Like To Go?';
  String precipitationText(int percent) => isTurkish ? 'Yağış %$percent' : 'Rain $percent%';

  // Search Card Labels
  String get searchTitle => isTurkish ? 'Hayalindeki Seyahati Planla' : 'Plan Your Dream Trip';
  String get originLabel => isTurkish ? 'Nereden (Kalkış)' : 'From (Departure)';
  String get destinationLabel => isTurkish ? 'Nereye (Varış / Otel Şehri)' : 'To (Destination)';
  String get datesLabel => isTurkish ? 'Tarihler' : 'Dates';
  String get passengerLabel => isTurkish ? 'Kişi' : 'Passengers';
  String passengerCountText(int count) => isTurkish ? '$count Yolcu' : '$count Passenger${count > 1 ? 's' : ''}';
  String get selectStart => isTurkish ? 'Başlangıç Seç' : 'Select Start';
  String get selectEnd => isTurkish ? 'Dönüş Seç' : 'Select End';
  String get searchFlights => isTurkish ? 'Uçuş Ara' : 'Search Flights';
  String get findHotels => isTurkish ? 'Otel Bul' : 'Find Hotels';
  String get dateOptimizerTitle => isTurkish ? 'Akıllı Tarih Optimizer\'ı' : 'Smart Date Optimizer';
  String get dateOptimizerSubtitle => isTurkish
      ? 'En ucuz, en iyi hava ve hızlı rotaları skorla'
      : 'Score cheapest dates, best weather & fast routes';

  // Recent Searches & Popular Destinations
  String get recentSearches => isTurkish ? 'Son Aramalarınız' : 'Recent Searches';
  String get popularDestinations => isTurkish ? 'Popüler Destinasyonlar' : 'Popular Destinations';
  String get clearText => isTurkish ? 'Temizle' : 'Clear All';
  String get seeAll => isTurkish ? 'Tümünü Gör' : 'See All';
  String get startingFrom => isTurkish ? 'başlayan' : 'starting from';

  // Flight Modal & Card Labels
  String get flightResultsTitle => isTurkish ? 'Uçuş Sonuçları' : 'Flight Results';
  String get totalPrice => isTurkish ? 'Toplam Fiyat' : 'Total Price';
  String get directFlight => isTurkish ? 'Direkt Uçuş' : 'Direct Flight';
  String stopoverFlight(int count) => isTurkish ? '$count Aktarma' : '$count Layover${count > 1 ? 's' : ''}';
  String get selectButton => isTurkish ? 'Seç' : 'Select';
  String durationText(String text) {
    if (isTurkish) return text;
    return text.replaceAll('sa', 'h').replaceAll('dk', 'm');
  }

  // Hotel Modal & Card Labels
  String get hotelResultsTitle => isTurkish ? 'Otel Sonuçları' : 'Hotel Results';
  String get perNight => isTurkish ? 'gecelik' : 'per night';
  String get selectHotel => isTurkish ? 'Oda Seç' : 'Select Room';

  // Date Optimizer Screen
  String get dateOptimizerHeader => isTurkish ? 'En Uygun Tarih Bulucu' : 'Best Travel Date Finder';
  String get priorityChoice => isTurkish ? 'Öncelikli Tercihiniz:' : 'Your Preference Priority:';
  String nightStay(int count) => isTurkish ? '$count Gece' : '$count Nights';
  String get selectThisDate => isTurkish ? 'Bu Tarihi Seç' : 'Select These Dates';
  String get idealChoiceBadge => isTurkish ? 'En İdeal Seçenek' : 'Top Recommendation';
  String scoreText(int score) => isTurkish ? 'Skor: $score/100' : 'Score: $score/100';

  // Profile & Settings Screen
  String get profileSettingsHeader => isTurkish ? 'Profil ve Ayarlar' : 'Profile & Settings';
  String get appearanceHeader => isTurkish ? 'Görünüm & Tema' : 'Appearance & Theme';
  String get languageCurrencyHeader => isTurkish ? 'Dil & Para Birimi' : 'Language & Currency';
  String get notificationHeader => isTurkish ? 'Bildirim Tercihleri' : 'Notification Preferences';
  String get defaultPreferencesHeader => isTurkish ? 'Varsayılan Seyahat Tercihleri' : 'Default Travel Preferences';
  String get appLanguage => isTurkish ? 'Uygulama Dili' : 'App Language';
  String get currency => isTurkish ? 'Para Birimi' : 'Currency';
  String get systemThemeExplanation => isTurkish
      ? 'Sistem teması seçildiğinde uygulama, cihazınızın (Windows/iOS/Android) gece veya gündüz modunu takip eder.'
      : 'When System theme is active, the app automatically syncs with your device\'s system theme (Dark/Light).';

  // Date Formatting Helper
  String formatDate(DateTime date) {
    final localeStr = isTurkish ? 'tr_TR' : 'en_US';
    try {
      return DateFormat('dd MMM yyyy', localeStr).format(date);
    } catch (_) {
      return '${date.day}.${date.month}.${date.year}';
    }
  }
}
