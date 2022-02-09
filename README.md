# flutter_triple_ecommerce

Simple Flutter e-commerce mobile application that uses [Triple](https://triple.flutterando.com.br) (or Segmented State Pattern) for its state management.

## Screenshots

| Search products |
| - |
| <img src="screenshots/search_product.gif" height="300" /> |

## Features

- [x] Searches products by a keyword from [eBay Sandbox API](https://developer.ebay.com/api-docs/buy/browse/static/overview.html) (uses [Executor](https://triple.flutterando.com.br/docs/getting-started/executors)).
- [x] Handles state, loading, and error with [`ScopedBuilder`](https://triple.flutterando.com.br/docs/getting-started/using-flutter-triple#scopedbuilder).
- [x] Undo search via [MementoMixin](https://triple.flutterando.com.br/docs/getting-started/Mixins#mementomixin).
- [ ] Triple Tracking
- [ ] Triple Middleware
- [ ] Triple HydratedMixin
- [ ] Triple Testing
- [ ] Code documentation

## Packages

- [`flutter_triple: ^1.2.6`](https://pub.dev/packages/flutter_triple): For Triple (Segmented State Pattern).
- [`equatable: ^2.0.3`](https://pub.dev/packages/equatable): For overriding `==` operation of models.
- [`http: ^0.13.4`](https://pub.dev/packages/http): For making HTTP requests.

