import 'package:flutter/foundation.dart';

/// Data class representing a travel destination item.
@immutable
class Destination {
  final String id;
  final String title;
  final String country;
  final String imageUrl;
  final double rating;
  final String priceEstimate;
  final String category;

  const Destination({
    required this.id,
    required this.title,
    required this.country,
    required this.imageUrl,
    required this.rating,
    required this.priceEstimate,
    required this.category,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'country': country,
      'imageUrl': imageUrl,
      'rating': rating,
      'priceEstimate': priceEstimate,
      'category': category,
    };
  }

  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      id: json['id'] as String,
      title: json['title'] as String,
      country: json['country'] as String,
      imageUrl: json['imageUrl'] as String,
      rating: (json['rating'] as num).toDouble(),
      priceEstimate: json['priceEstimate'] as String,
      category: json['category'] as String,
    );
  }
}
