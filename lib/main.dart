import 'package:flutter/material.dart';
import 'package:flutter_triple_ecommerce/src/pages/product_detail_page.dart';
import 'package:flutter_triple_ecommerce/src/pages/search_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter eBay App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: SearchPage.ROUTE_NAME,
      onGenerateRoute: (RouteSettings settings) {
        late Widget page;
        switch (settings.name) {
          case SearchPage.ROUTE_NAME:
            page = const SearchPage();
            break;
          case ProductDetailPage.ROUTE_NAME:
            page = ProductDetailPage();
            break;
          default:
            throw Exception('Illegal route: ${settings.name}');
        }
        return MaterialPageRoute(
          builder: ((BuildContext context) => page),
        );
      },
    );
  }
}
