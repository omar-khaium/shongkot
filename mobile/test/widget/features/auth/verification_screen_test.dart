import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shongkot_app/features/auth/presentation/verification_screen.dart';
import 'package:shongkot_app/features/auth/domain/verification_request.dart';

void main() {
  group('VerificationScreen Widget Tests', () {
    testWidgets('displays verification screen with OTP input fields', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: VerificationScreen(
              identifier: 'test@example.com',
              type: VerificationType.email,
            ),
          ),
        ),
      );

      // Wait for the screen to build
      await tester.pumpAndSettle();

      // Verify that the screen displays correct title
      expect(find.text('Verify Account'), findsOneWidget);
      expect(find.text('Verification Code'), findsOneWidget);

      // Verify that OTP input fields are present (6 fields)
      expect(find.byType(TextField), findsNWidgets(6));

      // Verify buttons are present
      expect(find.text('Verify'), findsOneWidget);
      expect(find.text('Resend Code'), findsOneWidget);
    });

    testWidgets('OTP fields accept only digits', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: VerificationScreen(
              identifier: 'test@example.com',
              type: VerificationType.email,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find the first TextField
      final firstTextField = find.byType(TextField).first;
      
      // Try to enter a letter (should not work due to digit-only filter)
      await tester.enterText(firstTextField, 'a');
      await tester.pump();

      // Verify that no text was entered
      final firstTextFieldWidget = tester.widget<TextField>(firstTextField);
      expect(firstTextFieldWidget.controller?.text, isEmpty);

      // Try to enter a digit (should work)
      await tester.enterText(firstTextField, '1');
      await tester.pump();
      
      expect(firstTextFieldWidget.controller?.text, '1');
    });

    testWidgets('verify button is initially enabled', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: VerificationScreen(
              identifier: 'test@example.com',
              type: VerificationType.email,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find the verify button
      final verifyButton = find.text('Verify');
      expect(verifyButton, findsOneWidget);

      // Verify button should be present and tappable
      final button = tester.widget<TextButton>(
        find.ancestor(
          of: verifyButton,
          matching: find.byType(TextButton),
        ).first,
      );
      
      expect(button.onPressed, isNotNull);
    });

    testWidgets('displays identifier in message', (WidgetTester tester) async {
      const testEmail = 'test@example.com';
      
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: VerificationScreen(
              identifier: testEmail,
              type: VerificationType.email,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify that the identifier is shown in the message
      expect(find.textContaining(testEmail), findsOneWidget);
    });
  });
}
