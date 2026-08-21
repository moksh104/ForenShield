import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../widgets/settings_card.dart';
import '../widgets/settings_tile.dart';

/// About Page displaying ForenShield application metadata, certifications, & licenses.
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>() ?? ForenColors.dark;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('About ForenShield'),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          // App Logo & Header Banner
          Center(
            child: Column(
              children: [
                Image.asset('assets/logos/app_logo.png', width: 90, height: 90),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'ForenShield Mobile',
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Enterprise Digital Forensics & Incident Response',
                  style: TextStyle(color: foren.textSecondary, fontSize: 13),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: foren.success.t500.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: foren.success.t500, width: 1),
                  ),
                  child: Text(
                    'Version 2.4.0 (Build 2026.08)',
                    style: TextStyle(
                      color: foren.success.t300,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // Security & Compliance Card
          SettingsCard(
            children: const [
              SettingsTile(
                icon: Icons.verified_user_rounded,
                title: 'Security Certification',
                subtitle: 'ISO/IEC 27001 & SOC2 Type II Compliant',
                showDivider: true,
              ),
              SettingsTile(
                icon: Icons.lock_outline_rounded,
                title: 'Encryption Standards',
                subtitle: 'AES-256 GCM at Rest / TLS 1.3 in Transit',
                showDivider: true,
              ),
              SettingsTile(
                icon: Icons.security_rounded,
                title: 'Threat Engine',
                subtitle: 'ForenShield Engine v4.12.0',
                showDivider: false,
              ),
            ],
          ),

          // Legal & Licensing Card
          SettingsCard(
            children: [
              SettingsTile(
                icon: Icons.gavel_rounded,
                title: 'Terms of Service',
                subtitle: 'Review enterprise usage agreement',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Opening Terms of Service...'),
                    ),
                  );
                },
                showDivider: true,
              ),
              SettingsTile(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy Policy',
                subtitle: 'Learn how your telemetry is protected',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Opening Privacy Policy...')),
                  );
                },
                showDivider: true,
              ),
              SettingsTile(
                icon: Icons.article_outlined,
                title: 'Open Source Licenses',
                subtitle: 'Third-party package attributions',
                onTap: () => showLicensePage(context: context),
                showDivider: false,
              ),
            ],
          ),

          // Copyright Footer
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              child: Text(
                '© 2026 ForenShield Cyber Defense Labs.\nAll Rights Reserved.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: foren.textDisabled,
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
