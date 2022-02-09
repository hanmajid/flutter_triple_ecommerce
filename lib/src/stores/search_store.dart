import 'package:flutter_triple/flutter_triple.dart';
import 'package:flutter_triple_ecommerce/src/errors/errors.dart';
import 'package:flutter_triple_ecommerce/src/repositories/product_repository.dart';
import 'package:flutter_triple_ecommerce/src/states/search_state.dart';

class SearchStore extends StreamStore<SearchError, SearchState>
    with MementoMixin {
  final SearchState searchState;
  final ProductRepository productRepository = ProductRepository();

  SearchStore({
    required this.searchState,
  }) : super(const SearchState(searchKeyword: ''));

  reset() {
    update(searchState.copyWith(searchKeyword: ''));
  }

  updateSearchKeyword(String newValue) {
    update(searchState.copyWith(searchKeyword: newValue));
  }

  search(String newValue) {
    updateSearchKeyword(newValue);
    execute(
      () async {
        var result = await productRepository.searchProducts(newValue);
        if (state.searchKeyword == newValue && state.searchKeyword.isNotEmpty) {
          undo();
          return result;
        } else {
          return state;
        }
      },
      delay: Duration.zero,
    );
  }

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
    // if (triple.event == TripleEvent.state) {
    //   return triple.copyWith(state + 2);
    // }

    return newTriple;
  }
}
