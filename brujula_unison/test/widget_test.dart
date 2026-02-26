// import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:brujula_unison/main.dart';

void main() {
  testWidgets('Brújula app test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const BrujulaApp());

    // Verify that the home view exists
    expect(find.text('Brújula Unison'), findsOneWidget);
  });
}