import 'package:flutter/material.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:flutter_triple_ecommerce/my_app.dart';

void main() {
  TripleObserver.addListener((triple) {
    // Can be used for Analytics
    print(triple);
  });

  runApp(const MyApp());
}
