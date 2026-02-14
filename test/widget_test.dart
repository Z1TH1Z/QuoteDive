import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quotes_app/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const QuotesApp());

    // Verify that the app launches
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
