/// ForenShield Widget Catalog — main screen.
/// Assembles every section into one scrollable reference page.
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_tokens.dart';
import 'catalog_sections_typography_buttons.dart';
import 'catalog_sections_badges.dart';
import 'catalog_sections_cards.dart';
import 'catalog_sections_progress.dart';
import 'catalog_sections_navigation.dart';
import 'catalog_sections_inputs.dart';
import 'catalog_sections_dialogs.dart';

class CatalogScreen extends StatelessWidget {
  final ThemeMode themeMode;
  final VoidCallback onToggleTheme;

  const CatalogScreen({
    super.key,
    required this.themeMode,
    required this.onToggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ForenShield Component Catalog'),
        actions: [
          IconButton(
            tooltip: themeMode == ThemeMode.dark
                ? 'Switch to Light'
                : 'Switch to Dark',
            icon: Icon(
              themeMode == ThemeMode.dark
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
            ),
            onPressed: onToggleTheme,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: ForenSpace.lg,
          vertical: ForenSpace.lg,
        ),
        children: const [
          TypographySection(),
          ButtonsSection(),
          BadgesSection(),
          CardsSection(),
          ProgressSection(),
          NavigationSection(),
          InputsSection(),
          DialogsSection(),
        ],
      ),
    );
  }
}
