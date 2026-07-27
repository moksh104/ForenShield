import 'package:flutter/material.dart';

/// Provides a fallback or placeholder localization architecture for future i18n support.
class AppLocalization {
  final Locale locale;

  AppLocalization(this.locale);

  static AppLocalization of(BuildContext context) {
    return Localizations.of<AppLocalization>(context, AppLocalization) ??
        AppLocalization(const Locale('en'));
  }

  // Placeholder for real translated maps in the future.
  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'app_name': 'ForenShield',
      'login': 'Login',
      'error_generic': 'Something went wrong.',
    },
    'es': {
      'app_name': 'ForenShield',
      'login': 'Iniciar sesión',
      'error_generic': 'Algo salió mal.',
    },
  };

  String translate(String key) {
    final values = _localizedValues[locale.languageCode];
    if (values == null) {
      return _localizedValues['en']?[key] ?? key;
    }
    return values[key] ?? _localizedValues['en']?[key] ?? key;
  }
}
