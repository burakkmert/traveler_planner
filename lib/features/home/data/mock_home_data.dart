import '../domain/models/destination.dart';
import '../domain/models/recent_search.dart';

/// Static mock data provider for Home screen views.
class MockHomeData {
  MockHomeData._();

  static const List<Destination> popularDestinations = [
    Destination(
      id: '1',
      title: 'Roma',
      country: 'İtalya',
      imageUrl: 'https://images.unsplash.com/photo-1552832230-c0197dd311b5',
      rating: 4.8,
      priceEstimate: '₺12.450',
      category: 'Kültür & Tarih',
    ),
    Destination(
      id: '2',
      title: 'Tokyo',
      country: 'Japonya',
      imageUrl: 'https://images.unsplash.com/photo-1503899036084-c55cdd92da26',
      rating: 4.9,
      priceEstimate: '₺34.800',
      category: 'Modern & Macera',
    ),
    Destination(
      id: '3',
      title: 'Paris',
      country: 'Fransa',
      imageUrl: 'https://images.unsplash.com/photo-1502602898657-3e91760cbb34',
      rating: 4.7,
      priceEstimate: '₺16.200',
      category: 'Romantik',
    ),
    Destination(
      id: '4',
      title: 'Kapadokya',
      country: 'Türkiye',
      imageUrl: 'https://images.unsplash.com/photo-1609825488888-3a766db05542',
      rating: 4.9,
      priceEstimate: '₺6.800',
      category: 'Doğa & Balon',
    ),
  ];

  static const List<RecentSearch> recentSearches = [
    RecentSearch(
      id: 'r1',
      origin: 'İstanbul',
      destination: 'Paris',
      dateRangeText: '12-18 Eylül',
      passengerCount: 2,
    ),
    RecentSearch(
      id: 'r2',
      origin: 'Ankara',
      destination: 'Antalya',
      dateRangeText: '05-10 Ekim',
      passengerCount: 1,
    ),
    RecentSearch(
      id: 'r3',
      origin: 'İzmir',
      destination: 'Atina',
      dateRangeText: '20-25 Kasım',
      passengerCount: 3,
    ),
  ];
}
