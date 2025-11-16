import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shongkot_app/features/auth/presentation/register_screen.dart';
import 'package:shongkot_app/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  group('RegisterScreen Widget Tests', () {
    testWidgets('displays all form fields and elements', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
              Locale('en'),
              Locale('bn'),
            ],
            home: RegisterScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Check for title and subtitle
      expect(find.text('Create Account'), findsOneWidget);
      expect(find.text('Sign up to access emergency response features'), findsOneWidget);

      // Check for input fields
      expect(find.byType(TextFormField), findsNWidgets(3)); // Email, Password, Confirm Password

      // Check for checkbox
      expect(find.byType(Checkbox), findsOneWidget);

      // Check for register button
      expect(find.text('Register'), findsAtLeastNWidgets(1));

      // Check for "Already have account" text
      expect(find.text('Already have an account?'), findsOneWidget);
    });

    testWidgets('shows validation errors for empty fields', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
              Locale('en'),
              Locale('bn'),
            ],
            home: RegisterScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap register button without filling fields
      final registerButton = find.widgetWithText(ElevatedButton, 'Register');
      await tester.tap(registerButton);
      await tester.pumpAndSettle();

      // Should show validation errors
      expect(find.text('Email is required'), findsOneWidget);
      expect(find.text('Password is required'), findsNWidgets(2)); // Both password fields
    });

    testWidgets('validates email format', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
              Locale('en'),
              Locale('bn'),
            ],
            home: RegisterScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Enter invalid email
      await tester.enterText(
        find.byType(TextFormField).first,
        'invalid-email@domain',
      );
      
      // Tap register button
      final registerButton = find.widgetWithText(ElevatedButton, 'Register');
      await tester.tap(registerButton);
      await tester.pumpAndSettle();

      // Should show email validation error
      expect(find.text('Please enter a valid email'), findsOneWidget);
    });

    testWidgets('validates phone format', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
              Locale('en'),
              Locale('bn'),
            ],
            home: RegisterScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Enter invalid phone
      await tester.enterText(find.byType(TextFormField).first, '123456');
      
      // Tap register button
      final registerButton = find.widgetWithText(ElevatedButton, 'Register');
      await tester.tap(registerButton);
      await tester.pumpAndSettle();

      // Should show phone validation error
      expect(find.text('Please enter a valid phone number'), findsOneWidget);
    });

    testWidgets('validates password strength', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
              Locale('en'),
              Locale('bn'),
            ],
            home: RegisterScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Enter valid email
      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      
      // Enter weak password (too short)
      final passwordFields = find.byType(TextFormField);
      await tester.enterText(passwordFields.at(1), 'weak');
      
      // Tap register button
      final registerButton = find.widgetWithText(ElevatedButton, 'Register');
      await tester.tap(registerButton);
      await tester.pumpAndSettle();

      // Should show password validation error
      expect(find.text('Password must be at least 8 characters'), findsOneWidget);
    });

    testWidgets('validates password confirmation match', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
              Locale('en'),
              Locale('bn'),
            ],
            home: RegisterScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Enter valid email
      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      
      // Enter password
      final passwordFields = find.byType(TextFormField);
      await tester.enterText(passwordFields.at(1), 'Test1234');
      
      // Enter non-matching confirmation password
      await tester.enterText(passwordFields.at(2), 'Test5678');
      
      // Tap register button
      final registerButton = find.widgetWithText(ElevatedButton, 'Register');
      await tester.tap(registerButton);
      await tester.pumpAndSettle();

      // Should show password mismatch error
      expect(find.text('Passwords do not match'), findsOneWidget);
    });

    testWidgets('toggles password visibility', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
              Locale('en'),
              Locale('bn'),
            ],
            home: RegisterScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Find password field
      final passwordFields = find.byType(TextFormField);
      final passwordField = passwordFields.at(1);
      
      // Enter password
      await tester.enterText(passwordField, 'Test1234');
      await tester.pump();

      // Check password visibility icon shows "visibility_outlined" initially (password is obscured)
      expect(find.byIcon(Icons.visibility_outlined), findsAtLeastNWidgets(1));

      // Tap visibility toggle button
      final visibilityButtons = find.byIcon(Icons.visibility_outlined);
      await tester.tap(visibilityButtons.first);
      await tester.pump();

      // Check password visibility icon changed to "visibility_off_outlined" (password is visible)
      expect(find.byIcon(Icons.visibility_off_outlined), findsAtLeastNWidgets(1));
    });

    testWidgets('toggles terms acceptance checkbox', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
              Locale('en'),
              Locale('bn'),
            ],
            home: RegisterScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Find checkbox
      final checkbox = find.byType(Checkbox);
      
      // Check initial state (unchecked)
      Checkbox checkboxWidget = tester.widget<Checkbox>(checkbox);
      expect(checkboxWidget.value, isFalse);

      // Tap checkbox
      await tester.tap(checkbox);
      await tester.pump();

      // Check state is now checked
      checkboxWidget = tester.widget<Checkbox>(checkbox);
      expect(checkboxWidget.value, isTrue);

      // Tap again
      await tester.tap(checkbox);
      await tester.pump();

      // Check state is unchecked again
      checkboxWidget = tester.widget<Checkbox>(checkbox);
      expect(checkboxWidget.value, isFalse);
    });
  });
}
