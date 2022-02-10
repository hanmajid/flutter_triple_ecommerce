import 'package:equatable/equatable.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:flutter_triple_ecommerce/src/models/product.dart';

class SearchState extends Equatable implements Serializable<SearchState> {
  final String searchKeyword;
  final List<Product> products;
  // final bool isSearchBarFocused;

  const SearchState({
    this.searchKeyword = '',
    this.products = const [],
    // this.isSearchBarFocused = false,
  });

  SearchState copyWith({
    String? searchKeyword,
    List<Product>? products,
    // bool? isSearchBarFocused,
  }) {
    return SearchState(
      searchKeyword: searchKeyword ?? this.searchKeyword,
      products: products ?? this.products,
      // isSearchBarFocused: isSearchBarFocused ?? this.isSearchBarFocused,
    );
  }

  @override
  List<Object?> get props => [
        searchKeyword,
        products,
        // isSearchBarFocused
      ];

  @override
  SearchState fromMap(Map<String, dynamic> map) {
    List productMaps = map['products'] as List;
    return SearchState(
      searchKeyword: map['search_keyword'],
      products: productMaps.isNotEmpty
          ? productMaps
              .map((productMap) => Product.fromMap(productMap))
              .toList()
          : [],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'search_keyword': searchKeyword,
      'products': products.isNotEmpty
          ? products.map((product) => product.toMap()).toList()
          : [],
    };
  }
}
