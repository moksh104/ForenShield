/// ForenShield Widget Catalog — Typography & Buttons sections.
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/foren_theme.dart';
import '../../../core/components/foren_components.dart';
import 'catalog_helpers.dart';

class TypographySection extends StatelessWidget {
  const TypographySection({super.key});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final rows = <(String, TextStyle?, String)>[
      ('Display Large', tt.displayLarge, 'displayLarge — 40/48/700'),
      ('Display Medium', tt.displayMedium, 'displayMedium — 34/40/700'),
      ('Display Small', tt.displaySmall, 'displaySmall — 28/34/700'),
      ('Heading Large', tt.headlineLarge, 'headlineLarge — 24/32/700'),
      ('Heading Medium', tt.headlineMedium, 'headlineMedium — 20/28/600'),
      ('Heading Small', tt.headlineSmall, 'headlineSmall — 18/24/600'),
      ('Title Large', tt.titleLarge, 'titleLarge — 18/24/600'),
      ('Title Medium', tt.titleMedium, 'titleMedium — 16/22/600'),
      ('Title Small', tt.titleSmall, 'titleSmall — 14/20/600'),
      ('Body Large', tt.bodyLarge, 'bodyLarge — 16/24/400'),
      ('Body Medium', tt.bodyMedium, 'bodyMedium — 14/20/400'),
      ('Body Small', tt.bodySmall, 'bodySmall — 12/16/400'),
      ('Caption Large', tt.labelLarge, 'labelLarge — 13/18/600'),
      ('Caption Medium', tt.labelMedium, 'labelMedium — 12/16/600'),
      ('Caption Small', tt.labelSmall, 'labelSmall — 11/14/600'),
    ];

    final foren = Theme.of(context).extension<ForenColors>()!;

    return CatalogSection(
      title: 'Typography',
      description:
          "Inter. One family, one scale — mapped directly onto Material 3's TextTheme.",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final r in rows)
            Padding(
              padding: const EdgeInsets.only(bottom: ForenSpace.md),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Expanded(child: Text(r.$1, style: r.$2)),
                  Text(
                    r.$3,
                    style: Theme.of(
                      context,
                    ).textTheme.labelSmall?.copyWith(color: foren.textDisabled),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class ButtonsSection extends StatelessWidget {
  const ButtonsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return CatalogSection(
      title: 'Buttons',
      description:
          'Primary / Secondary / Ghost / Danger, each able to take a feature accent (except Danger — always Critical).',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CatalogSubsection(
            label: 'Primary — per feature',
            child: CatalogPropRow(
              children: [
                ForenButton.primary(
                  label: 'Mission Control',
                  feature: ForenFeature.missionControl,
                  onPressed: () {},
                ),
                ForenButton.primary(
                  label: 'Academy',
                  feature: ForenFeature.academy,
                  onPressed: () {},
                ),
                ForenButton.primary(
                  label: 'Investigation',
                  feature: ForenFeature.investigation,
                  onPressed: () {},
                ),
                ForenButton.primary(
                  label: 'Simulation',
                  feature: ForenFeature.simulation,
                  onPressed: () {},
                ),
                ForenButton.primary(
                  label: 'Profile',
                  feature: ForenFeature.profile,
                  onPressed: () {},
                ),
              ],
            ),
          ),
          CatalogSubsection(
            label: 'Secondary & Ghost',
            child: CatalogPropRow(
              children: [
                ForenButton.secondary(
                  label: 'Secondary',
                  feature: ForenFeature.investigation,
                  onPressed: () {},
                ),
                ForenButton.ghost(
                  label: 'Ghost',
                  feature: ForenFeature.investigation,
                  onPressed: () {},
                ),
              ],
            ),
          ),
          CatalogSubsection(
            label: 'Danger, disabled, loading, small, full-width',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CatalogPropRow(
                  children: [
                    ForenButton.danger(label: 'Delete Case', onPressed: () {}),
                    const ForenButton.primary(
                      label: 'Disabled',
                      onPressed: null,
                    ),
                    ForenButton.primary(
                      label: 'Loading',
                      loading: true,
                      onPressed: () {},
                    ),
                    ForenButton.primary(
                      label: 'Small',
                      size: ForenButtonSize.small,
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: ForenSpace.sm),
                ForenButton.primary(
                  label: 'Full width',
                  fullWidth: true,
                  onPressed: () {},
                ),
              ],
            ),
          ),
          CatalogSubsection(
            label: 'With icon / Icon Button',
            child: CatalogPropRow(
              children: [
                ForenButton.primary(
                  label: 'Begin',
                  icon: Icons.play_arrow,
                  onPressed: () {},
                ),
                ForenIconButton(
                  icon: Icons.notifications_outlined,
                  onPressed: () {},
                  tooltip: 'Alerts',
                ),
                ForenIconButton(
                  icon: Icons.delete_outline,
                  variant: ForenButtonVariant.danger,
                  onPressed: () {},
                  tooltip: 'Delete',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
