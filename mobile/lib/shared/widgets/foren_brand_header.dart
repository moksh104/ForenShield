import 'package:flutter/material.dart';

/// Reusable ForenShield brand header widget used across all main screens.
///
/// Renders the compact shield-icon + "FOREN" + "SHIELD" wordmark + tagline
/// consistently. Use this in all main-screen top header bars instead of
/// hand-building the logo widget each time.
class ForenShieldBrandHeader extends StatelessWidget {
  const ForenShieldBrandHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Shield Logo Mark
        Image.asset('assets/logos/app_logo.png', width: 44, height: 44),
        const SizedBox(width: 10),

        // Brand Name + Tagline
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'FOREN',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                    fontFamily: 'Outfit',
                  ),
                ),
                Text(
                  'SHIELD',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                    fontFamily: 'Outfit',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 1),
            Text(
              'LEARN • INVESTIGATE • DEFEND',
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontSize: 7.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
