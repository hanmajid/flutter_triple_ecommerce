import 'package:flutter/material.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:flutter_triple_ecommerce/src/errors/errors.dart';
import 'package:flutter_triple_ecommerce/src/states/search_state.dart';
import 'package:flutter_triple_ecommerce/src/stores/search_store.dart';
import 'package:flutter_triple_ecommerce/src/widgets/empty_card.dart';
import 'package:flutter_triple_ecommerce/src/widgets/error_card.dart';

/// Search Page
///
/// Consists of a search bar for products.
class SearchPage extends StatefulWidget {
  /// Route name of this page.
  static const String ROUTE_NAME = '/';

  /// Creates new [SearchPage].
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchBarTextFieldController =
      TextEditingController();

  final SearchStore searchStore = SearchStore(
    searchState: const SearchState(
      searchKeyword: '',
      // isSearchBarFocused: false
    ),
  );

  /// True if search bar is focused.
  bool _isSearchBarFocused = false;

  late FocusNode _searchBarFocusNode;

  @override
  void initState() {
    super.initState();
    _searchBarFocusNode = FocusNode();
    searchStore.observer(
      onError: (error) {},
      // onState: (state) {
      //   _searchBarTextFieldController.text = state.searchKeyword;
      // },
    );
  }

  /// Handles click event on search bar.
  ///
  /// It changes the [_isSearchBarFocused] to true.
  void _handleClickSearchBar() {
    setState(() {
      _isSearchBarFocused = true;
      _searchBarTextFieldController.text = searchStore.state.searchKeyword;
    });
    _searchBarFocusNode.requestFocus();
  }

  /// Handles click event on back button.
  ///
  /// If user is currently searching, it will stop searching. Otherwise,
  /// the app will navigate up.
  Future<bool> _handleClickBack() async {
    if (_isSearchBarFocused) {
      _removeFocusSearchBar();
      if (searchStore.state.searchKeyword.isEmpty) {
        searchStore.undoSkipEmptySearchKeyword();
      }
      return false;
    } else if (searchStore.canUndo()) {
      searchStore.undoSkipEmptySearchKeyword();
      if (searchStore.state.products.isEmpty &&
          searchStore.state.searchKeyword.isNotEmpty) {
        searchStore.research();
      }
      setState(() {});
      return false;
    }
    return true;
  }

  /// Handles click event on clear button.
  ///
  /// Sets the value of [_searchKeyword] to empty string.
  void _handleClickClear() {
    setState(() {
      _searchBarTextFieldController.clear();
      searchStore.reset();
    });
  }

  void _handleSubmitSearch(String searchKeyword) {
    if (searchKeyword.isEmpty) {
      return;
    }
    _removeFocusSearchBar();
    setState(() {
      _searchBarTextFieldController.text = searchKeyword;
      searchStore.search(searchKeyword);
    });
  }

  void _removeFocusSearchBar() {
    setState(() {
      _isSearchBarFocused = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    bool showTitle =
        !_isSearchBarFocused && searchStore.state.searchKeyword.isEmpty;
    bool showSearchBarBorder = !_isSearchBarFocused;
    bool showSearchBarClearButton = _isSearchBarFocused;
    bool isSearchBarOnTop =
        _isSearchBarFocused || searchStore.state.searchKeyword.isNotEmpty;
    bool showResult =
        searchStore.canUndo() && searchStore.state.searchKeyword.isNotEmpty;

    return WillPopScope(
      onWillPop: _handleClickBack,
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: AnimatedOpacity(
                  opacity: showTitle ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      'Flutter eBay App',
                      style: theme.textTheme.headline4,
                    ), // height: 40.0
                  ),
                ),
              ),
              AnimatedPositioned(
                left: 0.0,
                right: 0.0,
                top: isSearchBarOnTop ? 16.0 : 40.0 + 16.0 + 32.0,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: showSearchBarBorder
                                  ? Border.all(
                                      color: Colors.black38,
                                      width: 1.0,
                                    )
                                  : null,
                              borderRadius: BorderRadius.circular(24.0),
                            ),
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: [
                                const Icon(Icons.search),
                                const SizedBox(width: 16.0),
                                if (!_isSearchBarFocused)
                                  Expanded(
                                    child: InkWell(
                                      onTap: _handleClickSearchBar,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16.0),
                                        child: SizedBox(
                                          // height:
                                          //     theme.textTheme.bodyText1?.fontSize,
                                          child: Text(
                                              searchStore.state.searchKeyword),
                                        ),
                                      ),
                                    ),
                                  ),
                                if (_isSearchBarFocused)
                                  Expanded(
                                    child: TextField(
                                      focusNode: _searchBarFocusNode,
                                      textInputAction: TextInputAction.search,
                                      onSubmitted: _handleSubmitSearch,
                                      controller: _searchBarTextFieldController,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                if (showSearchBarClearButton)
                                  IconButton(
                                    onPressed: _handleClickClear,
                                    icon: const Icon(Icons.close),
                                  ),
                              ],
                            ),
                          ),
                          ScopedBuilder(
                            store: searchStore,
                            onState: (_, __) => Container(),
                            onError: (_, __) => Container(),
                            onLoading: (_) {
                              return Positioned(
                                bottom: 0.0,
                                left: 0.0,
                                right: 0.0,
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 1.0),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: const LinearProgressIndicator(
                                    backgroundColor: Colors.transparent,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    if (_isSearchBarFocused) const Divider(),
                  ],
                ),
                duration: const Duration(milliseconds: 200),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 72.0),
                child: SingleChildScrollView(
                  child: ScopedBuilder(
                    store: searchStore,
                    onState: (_, SearchState state) {
                      if (state.searchKeyword.isNotEmpty &&
                          state.products.isEmpty) {
                        return EmptyCard(
                          message:
                              'Cannot find product with keyword: "${state.searchKeyword}"',
                        );
                      } else {
                        return Column(
                          children: state.products
                              .map(
                                (product) => ListTile(
                                  leading: product.imageUrl != null
                                      ? SizedBox(
                                          height: 64,
                                          width: 64,
                                          child:
                                              Image.network(product.imageUrl!),
                                        )
                                      : const SizedBox(
                                          height: 64,
                                          width: 64,
                                        ),
                                  title: Text(product.name),
                                  subtitle: Text(product.price),
                                ),
                              )
                              .toList(),
                        );
                      }
                    },
                    onLoading: (_) => Container(),
                    onError: (_, SearchError? error) {
                      return ErrorCard(
                        message: error?.message ?? 'Unknown error',
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
