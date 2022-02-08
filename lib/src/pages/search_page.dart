import 'package:flutter/material.dart';

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
  /// True if search bar is focused.
  bool _isSearchBarFocused = false;

  /// The search keyword for products.
  String _searchKeyword = 'Book';

  late FocusNode _searchBarFocusNode;

  @override
  void initState() {
    super.initState();
    _searchBarFocusNode = FocusNode();
  }

  /// Handles click event on search bar.
  ///
  /// It changes the [_isSearchBarFocused] to true.
  void _handleClickSearchBar() {
    setState(() {
      _isSearchBarFocused = !_isSearchBarFocused;
    });
    if (_isSearchBarFocused) {
      _searchBarFocusNode.requestFocus();
    }
  }

  /// Handles click event on back button.
  ///
  /// If user is currently searching, it will stop searching. Otherwise,
  /// the app will navigate up.
  Future<bool> _handleClickBack() async {
    if (_isSearchBarFocused) {
      setState(() {
        _isSearchBarFocused = false;
      });
      return false;
    }
    return true;
  }

  /// Handles click event on clear button.
  ///
  /// Sets the value of [_searchKeyword] to empty string.
  void _handleClickClear() {
    setState(() {
      _searchKeyword = '';
      _handleClickSearchBar();
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    bool showTitle = !_isSearchBarFocused && _searchKeyword.isEmpty;
    bool showSearchBarBorder = !_isSearchBarFocused;
    bool showSearchBarClearButton = _isSearchBarFocused;
    bool isSearchBarOnTop = _isSearchBarFocused || _searchKeyword.isNotEmpty;

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
                  duration: Duration(milliseconds: 200),
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
                      child: Container(
                        decoration: BoxDecoration(
                          border: showSearchBarBorder
                              ? Border.all(
                                  color: Colors.black38,
                                  width: 1.0,
                                )
                              : null,
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                                      height:
                                          theme.textTheme.bodyText1?.fontSize,
                                      child: Text(_searchKeyword),
                                    ),
                                  ),
                                ),
                              ),
                            if (_isSearchBarFocused)
                              Expanded(
                                child: TextField(
                                  focusNode: _searchBarFocusNode,
                                ),
                              ),
                            if (showSearchBarClearButton)
                              IconButton(
                                onPressed: _handleClickClear,
                                icon: Icon(Icons.close),
                              ),
                          ],
                        ),
                      ),
                    ),
                    if (_isSearchBarFocused) const Divider(),
                  ],
                ),
                duration: Duration(milliseconds: 200),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
