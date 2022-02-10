import 'package:flutter_triple/flutter_triple.dart';
import 'package:flutter_triple_ecommerce/src/errors/errors.dart';
import 'package:flutter_triple_ecommerce/src/models/product.dart';
import 'package:flutter_triple_ecommerce/src/states/search_state.dart';
import 'package:flutter_triple_ecommerce/src/stores/search_store.dart';
import 'package:triple_test/triple_test.dart';

class MockSearchStore extends MockStore<SearchError, SearchState>
    implements SearchStore {}

void main() {
  MockSearchStore _mock() {
    final mock = MockSearchStore();
    whenObserve(
      mock,
      input: () => mock.search('Book'),
      initialState: const SearchState(),
      triples: [
        Triple(state: const SearchState()),
        Triple(
          state: const SearchState(searchKeyword: 'Book'),
          isLoading: true,
          event: TripleEvent.loading,
        ),
        Triple(
          state: const SearchState(
            searchKeyword: 'Book',
            products: [
              Product(
                name: 'name',
                price: 0.0,
                currency: 'USD',
                imageUrl: 'imageUrl',
              ),
            ],
          ),
        ),
      ],
    );
    return mock;
  }

  storeTest<MockSearchStore>(
    'Testing triple',
    build: () => _mock(),
    act: (store) => store.search('Book'),
    expect: () => [
      SearchState(),
      tripleLoading,
      SearchState(searchKeyword: 'Book'),
    ],
  );
}
