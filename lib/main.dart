import 'package:flutter/material.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:flutter_triple_ecommerce/my_app.dart';
import 'package:flutter_triple_ecommerce/src/errors/errors.dart';
import 'package:flutter_triple_ecommerce/src/repositories/analytics_repository.dart';

void main() {
  /// Tracks error happening in the application.
  TripleObserver.addListener((triple) {
    if (triple.event == TripleEvent.error) {
      AnalyticsRepository.reportError(triple.error as SearchError);
    }
    // print(triple);
  });

  runApp(const MyApp());
}
