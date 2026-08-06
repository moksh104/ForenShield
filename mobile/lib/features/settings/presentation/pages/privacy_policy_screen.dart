import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';

/// Privacy Policy document screen for ForenShield.
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          color: theme.colorScheme.onSurface,
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Privacy Policy',
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ForenShield Privacy Policy',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Last Updated: August 5, 2026',
                style: TextStyle(color: foren.textDisabled, fontSize: 12),
              ),
              const SizedBox(height: AppSpacing.lg),
              _buildSection(
                theme,
                foren,
                '1. Information We Collect',
                'ForenShield collects minimal information required to deliver cybersecurity training and lab simulation exercises. This includes account profile credentials (name, email) and progress telemetry for laboratory debriefs.',
              ),
              _buildSection(
                theme,
                foren,
                '2. Use of Data & Telemetry',
                'Your data is processed strictly for authenticating session access, personalizing lab simulations, calculating skill achievements, and maintaining enterprise audit logs.',
              ),
              _buildSection(
                theme,
                foren,
                '3. Security & Encryption',
                'All user credentials, JWT access tokens, and simulation activity data are encrypted using industry-standard TLS in transit and AES-256 / Secure Storage at rest.',
              ),
              _buildSection(
                theme,
                foren,
                '4. Analytics & Preferences',
                'You may toggle telemetry & analytics preferences at any time in Settings. Telemetry data is anonymized and never sold to third parties.',
              ),
              _buildSection(
                theme,
                foren,
                '5. Contact Us',
                'If you have questions regarding this Privacy Policy or data subject requests, please contact our security team at privacy@forenshield.com.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(ThemeData theme, ForenColors foren, String title, String body) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            body,
            style: TextStyle(
              color: foren.textSecondary,
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
