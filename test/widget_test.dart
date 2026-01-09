import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_in_months/app.dart';

void main() {
  testWidgets('App builds without crashing', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const LifeInMonthsApp());

    // Verify that the app builds without throwing an exception.
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
