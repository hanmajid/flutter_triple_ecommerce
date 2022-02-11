import 'package:flutter_triple/flutter_triple.dart';
import 'package:flutter_triple_ecommerce/src/errors/errors.dart';
import 'package:flutter_triple_ecommerce/src/models/product.dart';
import 'package:flutter_triple_ecommerce/src/repositories/product_repository.dart';
import 'package:flutter_triple_ecommerce/src/states/search_state.dart';

/// Searching products store.
///
/// It uses [SearchState] as a state and [SearchError] as its error class.
class SearchStore extends StreamStore<SearchError, SearchState>
    with MementoMixin, HydratedMixin {
  /// Search state.
  final SearchState searchState;

  /// The product repository.
  final ProductRepository productRepository = ProductRepository();

  /// Constructor.
  SearchStore({
    required this.searchState,
  }) : super(const SearchState());

  /// Resets the search keyword.
  reset() {
    update(searchState.copyWith(searchKeyword: ''));
  }

  /// Changes the search keyword to [newValue].
  updateSearchKeyword(String newValue) {
    update(searchState.copyWith(searchKeyword: newValue));
  }

  /// Searches products with the given [searchKeyword].
  search(String searchKeyword) {
    updateSearchKeyword(searchKeyword);
    execute(
      () async {
        var result = await productRepository.searchProducts(searchKeyword);
        if (state.searchKeyword == searchKeyword &&
            state.searchKeyword.isNotEmpty) {
          undo();
          return result;
        } else {
          return state;
        }
      },
      delay: Duration.zero,
    );
  }

  /// Searches products from the current search keyword.
  research() {
    execute(
      () async {
        var result =
            await productRepository.searchProducts(state.searchKeyword);
        if (state.searchKeyword.isNotEmpty) {
          undo();
          return result;
        } else {
          return state;
        }
      },
    );
  }

  /// Undo states while skipping states with empty search keyword.
  undoSkipEmptySearchKeyword() {
    bool isFoundNotEmpty = false;
    while (canUndo() && !isFoundNotEmpty) {
      undo();
      if (state.searchKeyword.isNotEmpty) {
        isFoundNotEmpty = true;
      }
    }
  }

  @override
  Triple<SearchError, SearchState> middleware(newTriple) {
    /// Sorts the products by its price.
    if (newTriple.event == TripleEvent.state &&
        newTriple.state.products.isNotEmpty) {
      var sortedProducts = List<Product>.from(newTriple.state.products);
      sortedProducts.sort(((a, b) => a.compareTo(b)));
      return newTriple.copyWith(
        state: newTriple.state.copyWith(
          products: sortedProducts,
        ),
      );
    }

    return newTriple;
  }
}
