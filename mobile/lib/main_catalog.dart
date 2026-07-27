/// ForenShield Component Catalog — runnable entry point.
///
/// This is a standalone app whose only purpose is to preview every
/// locked design-system component in both themes. It is NOT a
/// feature screen and should NOT be shipped as part of the product —
/// it's a living reference for the design system.
///
/// Run with:
///   flutter run -t lib/main_catalog.dart
library;

import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'developer/catalog/widgets/catalog_screen.dart';

void main() => runApp(const ForenShieldCatalogApp());

class ForenShieldCatalogApp extends StatefulWidget {
  const ForenShieldCatalogApp({super.key});

  @override
  State<ForenShieldCatalogApp> createState() => _ForenShieldCatalogAppState();
}

class _ForenShieldCatalogAppState extends State<ForenShieldCatalogApp> {
  ThemeMode _mode = ThemeMode.dark; // dark is the primary experience

  void _toggleTheme() {
    setState(() {
      _mode = _mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ForenShield Catalog',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _mode,
      home: CatalogScreen(themeMode: _mode, onToggleTheme: _toggleTheme),
    );
  }
}
