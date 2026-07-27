import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'locale_constants.dart';

/// A Riverpod provider to track and update the active application Locale.
final localizationServiceProvider =
    NotifierProvider<LocalizationService, Locale>(() {
      return LocalizationService();
    });

class LocalizationService extends Notifier<Locale> {
  @override
  Locale build() {
    // Defaults to English. In the future, this can read from SharedPreferences.
    return LocaleConstants.english;
  }

  void setLocale(Locale newLocale) {
    if (LocaleConstants.supportedLocales.contains(newLocale)) {
      state = newLocale;
      // TODO: Save to shared preferences
    }
  }

  void switchLanguage(String languageCode) {
    final newLocale = LocaleConstants.supportedLocales.firstWhere(
      (l) => l.languageCode == languageCode,
      orElse: () => LocaleConstants.english,
    );
    setLocale(newLocale);
  }
}
