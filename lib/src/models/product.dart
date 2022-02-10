import 'package:equatable/equatable.dart';

/// The searched products from eBay API.
class Product extends Equatable {
  /// The product name;
  final String name;

  /// The product price.
  final double price;

  /// The product currency.
  final String currency;

  /// The product image URL.
  final String? imageUrl;

  /// Constructor.
  const Product({
    required this.name,
    required this.price,
    required this.currency,
    required this.imageUrl,
  });

  /// Creates [Product] object from JSON map.
  static Product fromJson(Map<String, dynamic> json) {
    String? imageUrl;
    if (json['thumbnailImages'] != null) {
      imageUrl = json['thumbnailImages'][0]['imageUrl'];
    } else {
      if (json['image'] != null) {
        imageUrl = json['image']['imageUrl'];
      } else if (json['additionalImages'] != null) {
        imageUrl = json['additionalImages'][0]['imageUrl'];
      }
    }
    return Product(
      name: json['title'],
      price: double.tryParse(json['price']['value']) ?? 0.0,
      currency: json['price']['currency'],
      imageUrl: imageUrl,
    );
  }

  @override
  List<Object?> get props => [name, price, currency, imageUrl];

  /// Compares product ascending by its price.
  ///
  /// This function is used as a parameter for [List.sort] function.
  int compareTo(Product product) {
    if (price < product.price) {
      return -1;
    } else if (price > product.price) {
      return 1;
    }
    return 0;
  }
}
