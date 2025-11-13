import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Locale state notifier that persists locale preference
class LocaleNotifier extends StateNotifier<Locale> {
  static const String _localeKey = 'locale';

  LocaleNotifier() : super(const Locale('en')) {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final localeString = prefs.getString(_localeKey);
    if (localeString != null) {
      state = Locale(localeString);
    }
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
  }
}

/// Provider for locale management
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>(
  (ref) => LocaleNotifier(),
);

/// Supported locales
const List<Locale> supportedLocales = [
  Locale('en'), // English
  Locale('bn'), // Bengali
];
