import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shongkot_app/core/providers/theme_provider.dart';
import 'package:shongkot_app/main.dart';

void main() {
  testWidgets('Theme changes are reflected immediately', (WidgetTester tester) async {
    // Create a ProviderContainer to manage state
    final container = ProviderContainer();
    
    // Build the app
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const ShongkotApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Get the initial theme mode
    final initialThemeMode = container.read(themeProvider);
    expect(initialThemeMode, AppThemeMode.system);

    // Change theme to dark
    container.read(themeProvider.notifier).setTheme(AppThemeMode.dark);
    
    // Pump the widget tree to rebuild
    await tester.pump();

    // Verify the theme provider state changed
    final newThemeMode = container.read(themeProvider);
    expect(newThemeMode, AppThemeMode.dark);

    // Verify the MaterialApp received the theme change
    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.themeMode, ThemeMode.dark);

    // Clean up
    container.dispose();
  });

  testWidgets('Theme changes work independently of locale changes', (WidgetTester tester) async {
    // Create a ProviderContainer to manage state
    final container = ProviderContainer();
    
    // Build the app
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const ShongkotApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Change theme to light
    container.read(themeProvider.notifier).setTheme(AppThemeMode.light);
    await tester.pump();

    // Verify the theme changed
    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.themeMode, ThemeMode.light);

    // Change theme to dark without changing locale
    container.read(themeProvider.notifier).setTheme(AppThemeMode.dark);
    await tester.pump();

    // Verify the theme changed again
    final materialApp2 = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp2.themeMode, ThemeMode.dark);

    // Clean up
    container.dispose();
  });

  test('ThemeNotifier themeMode getter returns correct values', () {
    final notifier = ThemeNotifier();

    notifier.setTheme(AppThemeMode.light);
    expect(notifier.themeMode, ThemeMode.light);

    notifier.setTheme(AppThemeMode.dark);
    expect(notifier.themeMode, ThemeMode.dark);

    notifier.setTheme(AppThemeMode.system);
    expect(notifier.themeMode, ThemeMode.system);
  });
}
