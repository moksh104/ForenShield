import 'package:flutter/material.dart';

/// Supported Locales and Language Identifiers for ForenShield.
class LocaleConstants {
  LocaleConstants._();

  static const Locale english = Locale('en', 'US');
  static const Locale spanish = Locale('es', 'ES');
  static const Locale french = Locale('fr', 'FR');
  static const Locale german = Locale('de', 'DE');

  static const List<Locale> supportedLocales = [
    english,
    spanish,
    french,
    german,
  ];

  static const String fallbackLanguageCode = 'en';
}
