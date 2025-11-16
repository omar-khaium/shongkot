import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shongkot_app/features/emergency/data/fake_emergency_repository.dart';
import 'package:shongkot_app/features/emergency/data/emergency_repository_provider.dart';
import 'package:shongkot_app/features/emergency/presentation/emergency_history_screen.dart';
import 'package:shongkot_app/l10n/app_localizations.dart';

void main() {
  group('EmergencyHistoryScreen', () {
    late FakeEmergencyRepository repository;

    setUp(() {
      repository = FakeEmergencyRepository();
    });

    Widget createTestWidget() {
      return ProviderScope(
        overrides: [
          emergencyRepositoryProvider.overrideWithValue(repository),
        ],
        child: const MaterialApp(
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
          home: EmergencyHistoryScreen(),
        ),
      );
    }

    testWidgets('should display app bar with title', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Emergency History'), findsOneWidget);
      expect(find.byIcon(Icons.filter_list), findsOneWidget);
    });

    testWidgets('should display search field', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('should display emergency list', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert - sample data should be loaded
      expect(find.byType(ListView), findsOneWidget);
      // Check for at least one emergency item
      expect(find.text('Violent Crime'), findsAtLeastNWidgets(1));
    });

    testWidgets('should display empty state when no emergencies', (WidgetTester tester) async {
      // Arrange - clear sample data
      repository.clearHistory();

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byIcon(Icons.history), findsOneWidget);
      expect(find.text('No emergencies found'), findsOneWidget);
      expect(
        find.text('Your emergency history will appear here'),
        findsOneWidget,
      );
    });

    testWidgets('should open filter sheet when filter button tapped', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap filter button
      await tester.tap(find.byIcon(Icons.filter_list));
      await tester.pumpAndSettle();

      // Assert - filter sheet should be visible
      expect(find.text('Filter by Status'), findsOneWidget);
      expect(find.text('All Statuses'), findsOneWidget);
      expect(find.text('Pending'), findsOneWidget);
      expect(find.text('Active'), findsOneWidget);
      expect(find.text('Resolved'), findsOneWidget);
      expect(find.text('Cancelled'), findsOneWidget);
    });

    testWidgets('should filter by status', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Open filter sheet
      await tester.tap(find.byIcon(Icons.filter_list));
      await tester.pumpAndSettle();

      // Tap on "Resolved" filter
      await tester.tap(find.text('Resolved'));
      await tester.pumpAndSettle();

      // Close filter sheet
      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();

      // Assert - only resolved emergencies should be shown
      // The sample data has 2 resolved emergencies
      expect(find.text('RESOLVED'), findsAtLeastNWidgets(2));
    });

    testWidgets('should search emergencies', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Enter search query
      await tester.enterText(find.byType(TextField), 'sexual');
      await tester.pumpAndSettle();

      // Wait for debounce/filter
      await tester.pump(const Duration(milliseconds: 500));

      // Assert - only matching emergencies should be shown
      expect(find.text('Sexual Assault / Rape'), findsOneWidget);
    });

    testWidgets('should clear search', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Enter search query
      await tester.enterText(find.byType(TextField), 'test');
      await tester.pumpAndSettle();

      // Tap clear button
      await tester.tap(find.byIcon(Icons.clear));
      await tester.pumpAndSettle();

      // Assert - search field should be empty
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller?.text, isEmpty);
    });

    testWidgets('should display status indicators', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert - status badges should be visible
      expect(find.text('RESOLVED'), findsWidgets);
      expect(find.text('ACTIVE'), findsWidgets);
      expect(find.text('PENDING'), findsWidgets);
    });

    testWidgets('should display high priority indicator', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert - priority icon should be visible for high priority emergencies
      expect(find.byIcon(Icons.priority_high), findsWidgets);
    });

    testWidgets('should display emergency details', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert - emergency details should be visible
      expect(find.byIcon(Icons.access_time), findsWidgets); // timestamp icon
      expect(find.byIcon(Icons.location_on), findsWidgets); // location icon
    });

    testWidgets('should support pull to refresh', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Pull to refresh
      await tester.drag(find.byType(ListView), const Offset(0, 300));
      await tester.pumpAndSettle();

      // Assert - RefreshIndicator should be present
      expect(find.byType(RefreshIndicator), findsOneWidget);
    });

    testWidgets('should display clear filters button when filters active', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Open filter sheet
      await tester.tap(find.byIcon(Icons.filter_list));
      await tester.pumpAndSettle();

      // Apply a filter
      await tester.tap(find.text('Resolved'));
      await tester.pumpAndSettle();

      // Close filter sheet
      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();

      // Assert - clear filters button should be visible
      expect(find.text('Clear Filters'), findsOneWidget);
    });
  });
}
