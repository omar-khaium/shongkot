import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shongkot_app/features/auth/presentation/login_screen.dart';
import 'package:shongkot_app/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  // Helper to create test widget with providers
  Widget createTestWidget(Widget child) {
    return ProviderScope(
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('bn'),
        ],
        home: child,
      ),
    );
  }

  group('LoginScreen', () {
    testWidgets('should display all form fields', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createTestWidget(const LoginScreen()));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Welcome Back'), findsOneWidget);
      expect(find.text('Sign in to access emergency features'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.text('Email or Phone'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Remember me'), findsOneWidget);
      expect(find.text('Forgot Password?'), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('should toggle password visibility', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(const LoginScreen()));
      await tester.pumpAndSettle();

      // Assert initial state - visibility_outlined icon (password hidden)
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
      expect(find.byIcon(Icons.visibility_off_outlined), findsNothing);

      // Act - tap visibility toggle
      await tester.tap(find.byIcon(Icons.visibility_outlined));
      await tester.pumpAndSettle();

      // Assert - visibility_off_outlined icon (password visible)
      expect(find.byIcon(Icons.visibility_outlined), findsNothing);
      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
    });

    testWidgets('should toggle remember me checkbox', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(const LoginScreen()));
      await tester.pumpAndSettle();

      // Find checkbox
      final checkbox = find.byType(Checkbox);
      final checkboxWidget = tester.widget<Checkbox>(checkbox);
      
      // Assert initial state
      expect(checkboxWidget.value, isFalse);

      // Act
      await tester.tap(checkbox);
      await tester.pumpAndSettle();

      // Assert
      final checkboxAfter = tester.widget<Checkbox>(checkbox);
      expect(checkboxAfter.value, isTrue);
    });

    testWidgets('should show validation errors for empty fields', 
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(const LoginScreen()));
      await tester.pumpAndSettle();

      // Act - tap login without entering credentials
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      // Assert - validation errors shown
      expect(find.text('This field is required'), findsNWidgets(2));
    });

    testWidgets('should validate password length', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(const LoginScreen()));
      await tester.pumpAndSettle();

      // Act - enter short password
      await tester.enterText(
        find.byType(TextFormField).first,
        'test@example.com',
      );
      await tester.enterText(
        find.byType(TextFormField).last,
        '12345',
      );
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      // Assert
      expect(
        find.text('Password must be at least 6 characters'),
        findsOneWidget,
      );
    });

    testWidgets('should not show biometric button without saved credentials',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(const LoginScreen()));
      await tester.pumpAndSettle();

      // Assert - biometric button not shown
      expect(find.text('Login with Biometric'), findsNothing);
    });

    testWidgets('should show forgot password message on tap',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(const LoginScreen()));
      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.text('Forgot Password?'));
      await tester.pumpAndSettle();

      // Assert - snackbar shown
      expect(find.text('Forgot Password?'), findsNWidgets(2)); // Button + Snackbar
    });
  });
}
