import 'package:equatable/equatable.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:flutter_triple_ecommerce/src/models/product.dart';

/// Searching products state.
///
/// Implements [Serializable] so that it can be used in Hydrated Mixin.
class SearchState extends Equatable implements Serializable<SearchState> {
  /// The current search keyword.
  final String searchKeyword;

  /// The currently displayed products.
  final List<Product> products;

  /// Constructor.
  const SearchState({
    this.searchKeyword = '',
    this.products = const [],
  });

  /// Creates new [SearchState] with the copied properties
  SearchState copyWith({
    String? searchKeyword,
    List<Product>? products,
  }) {
    return SearchState(
      searchKeyword: searchKeyword ?? this.searchKeyword,
      products: products ?? this.products,
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
