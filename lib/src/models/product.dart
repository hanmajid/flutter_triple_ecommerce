import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String name;
  final String price;
  final String? imageUrl;

  const Product({
    required this.name,
    required this.price,
    required this.imageUrl,
  });

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
      price: "${json['price']['value']} ${json['price']['currency']}",
      imageUrl: imageUrl,
    );
  }

  @override
  List<Object?> get props => [name, price, imageUrl];
}
