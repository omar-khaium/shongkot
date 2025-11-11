import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shongkot_app/main.dart';

void main() {
  testWidgets('App launches and displays home page', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ShongkotApp());

    // Verify that the app bar title is present
    expect(find.text('Shongkot Emergency'), findsOneWidget);
    
    // Verify that the emergency icon is present
    expect(find.byIcon(Icons.emergency), findsOneWidget);
    
    // Verify that the main text is present
    expect(find.text('Emergency Responder'), findsOneWidget);
  });
}
