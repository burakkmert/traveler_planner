/// Represents an item (Flight, Hotel, Destination) recently viewed by the user.
class RecentlyViewedItem {
  final String id;
  final String category; // 'flight', 'hotel', 'destination'
  final String title;
  final String subtitle;
  final String priceText;
  final String? imageUrl;
  final DateTime viewedAt;

  const RecentlyViewedItem({
    required this.id,
    required this.category,
    required this.title,
    required this.subtitle,
    required this.priceText,
    this.imageUrl,
    required this.viewedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'title': title,
      'subtitle': subtitle,
      'priceText': priceText,
      'imageUrl': imageUrl,
      'viewedAt': viewedAt.millisecondsSinceEpoch,
    };
  }

  factory RecentlyViewedItem.fromJson(Map<String, dynamic> json) {
    return RecentlyViewedItem(
      id: json['id'] as String,
      category: json['category'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      priceText: json['priceText'] as String,
      imageUrl: json['imageUrl'] as String?,
      viewedAt: DateTime.fromMillisecondsSinceEpoch(
        json['viewedAt'] as int? ?? DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }
}
