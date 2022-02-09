import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_triple_ecommerce/src/errors/errors.dart';
import 'package:flutter_triple_ecommerce/src/models/product.dart';
import 'package:flutter_triple_ecommerce/src/states/search_state.dart';
import 'package:http/http.dart' as http;

class ProductRepository {
  static const timeoutDuration = Duration(seconds: 10);

  Future<SearchState> searchProducts(String searchKeyword) async {
    http.Response oauthResult;
    try {
      oauthResult = await http.Client().post(
        Uri.parse('https://api.sandbox.ebay.com/identity/v1/oauth2/token'),
        headers: {
          'Authorization':
              'Basic TXVoYW1tYWQtZmx1dHRlcnQtU0JYLWFkNjg0NjAxZS1mYWI2MWQ0ZjpTQlgtZDY4NDYwMWVlZGVlLTgyM2MtNDQ3My04ZjFjLTJkNmQ=',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'grant_type': 'client_credentials',
          'scope': 'https://api.ebay.com/oauth/api_scope',
        },
      ).timeout(
        timeoutDuration,
        onTimeout: () => http.Response(
          'Request timeout',
          HttpStatus.requestTimeout,
        ),
      );
    } catch (e) {
      throw SearchError(e.toString());
    }
    if (oauthResult.statusCode == 200) {
      final json = jsonDecode(oauthResult.body);
      String accessToken = json['access_token'];
      http.Response browseResult;
      try {
        browseResult = await http.Client().get(
          Uri.parse(
              'https://api.sandbox.ebay.com/buy/browse/v1/item_summary/search?q=$searchKeyword&limit=10'),
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ).timeout(
          timeoutDuration,
          onTimeout: () => http.Response(
            'Request timeout',
            HttpStatus.requestTimeout,
          ),
        );
      } catch (e) {
        throw SearchError(e.toString());
      }
      if (browseResult.statusCode == 200) {
        final json = jsonDecode(browseResult.body);
        log(json.toString());
        if (json['total'] > 0) {
          return SearchState(
            searchKeyword: searchKeyword,
            products: (json['itemSummaries'] as List)
                .map(
                  (item) => Product.fromJson(
                    item,
                  ),
                )
                .toList(),
          );
        } else {
          return SearchState(
            searchKeyword: searchKeyword,
            products: const [],
          );
        }
      } else {
        throw SearchError('${browseResult.statusCode}: ${browseResult.body}');
      }
    } else {
      throw SearchError('${oauthResult.statusCode}: ${oauthResult.body}');
    }
  }
}
