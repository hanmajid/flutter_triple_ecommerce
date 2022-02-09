import 'package:equatable/equatable.dart';
import 'package:flutter_triple_ecommerce/src/models/product.dart';

class SearchState extends Equatable {
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
}
