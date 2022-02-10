import 'package:flutter_triple_ecommerce/src/errors/errors.dart';

/// Repository for analytics.
class AnalyticsRepository {
  /// Dummy function for reporting errors.
  ///
  /// You can change this function to Crashlytics or something similar.
  static Future<void> reportError(SearchError error) {
    return Future.delayed(const Duration(seconds: 1), () {
      print("New error report: ${error.message}");
    });
  }
}
