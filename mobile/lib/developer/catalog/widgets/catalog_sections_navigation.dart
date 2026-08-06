/// ForenShield Widget Catalog — Navigation section.
/// Bottom Nav and Side Nav need local selected-index state to be
/// interactive in the catalog, so they're wrapped in small stateful
/// preview widgets here.
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/foren_theme.dart';
import '../../../core/components/foren_components.dart';
import 'catalog_helpers.dart';

class NavigationSection extends StatelessWidget {
  const NavigationSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;

    return CatalogSection(
      title: 'Navigation',
      description:
          'Top App Bar, Bottom Nav, Side Nav — the five destinations are locked and never reorder.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CatalogSubsection(
            label: 'Top App Bar — title only',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(ForenRadius.card),
              child: const ForenTopAppBar(
                title: 'Mission Control',
                feature: ForenFeature.missionControl,
              ),
            ),
          ),
          CatalogSubsection(
            label: 'Top App Bar — with subtitle & actions',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(ForenRadius.card),
              child: ForenTopAppBar(
                title: 'Case #0417',
                subtitle: 'Active investigation — 4 of 12 evidence reviewed',
                feature: ForenFeature.investigation,
                actions: [
                  IconButton(
                    icon: Icon(
                      Icons.notifications_outlined,
                      color: foren.textSecondary,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
          const CatalogSubsection(
            label: 'Bottom Navigation (interactive)',
            child: _BottomNavPreview(),
          ),
          const CatalogSubsection(
            label: 'Side Navigation — collapsed (interactive)',
            child: SizedBox(height: 320, child: _SideNavPreview()),
          ),
          const CatalogSubsection(
            label: 'Side Navigation — extended (interactive)',
            child: SizedBox(height: 320, child: _SideNavExtendedPreview()),
          ),
        ],
      ),
    );
  }
}

class _BottomNavPreview extends StatefulWidget {
  const _BottomNavPreview();

  @override
  State<_BottomNavPreview> createState() => _BottomNavPreviewState();
}

class _BottomNavPreviewState extends State<_BottomNavPreview> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return ForenBottomNav(
      currentIndex: _index,
      onTap: (i) => setState(() => _index = i),
    );
  }
}

class _SideNavPreview extends StatefulWidget {
  const _SideNavPreview();

  @override
  State<_SideNavPreview> createState() => _SideNavPreviewState();
}

class _SideNavPreviewState extends State<_SideNavPreview> {
  int _index = 2;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ForenSideNav(
          currentIndex: _index,
          onTap: (i) => setState(() => _index = i),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          child: Center(
            child: Text(
              forenNavDestinations[_index].label,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),
      ],
    );
  }
}

class _SideNavExtendedPreview extends StatefulWidget {
  const _SideNavExtendedPreview();

  @override
  State<_SideNavExtendedPreview> createState() =>
      _SideNavExtendedPreviewState();
}

class _SideNavExtendedPreviewState extends State<_SideNavExtendedPreview> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ForenSideNav(
          extended: true,
          currentIndex: _index,
          onTap: (i) => setState(() => _index = i),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          child: Center(
            child: Text(
              forenNavDestinations[_index].label,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),
      ],
    );
  }
}
