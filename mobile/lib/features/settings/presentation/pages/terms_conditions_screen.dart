import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';

/// Terms and Conditions document screen for ForenShield.
class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

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
          'Terms & Conditions',
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
                'ForenShield Terms of Service',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Effective Date: August 5, 2026',
                style: TextStyle(color: foren.textDisabled, fontSize: 12),
              ),
              const SizedBox(height: AppSpacing.lg),
              _buildSection(
                theme,
                foren,
                '1. Ethical Training Code',
                'ForenShield is an educational platform intended solely for authorized cybersecurity learning, defense research, and ethical penetration testing in sandboxed lab environments.',
              ),
              _buildSection(
                theme,
                foren,
                '2. Acceptable Use Policy',
                'Users are strictly prohibited from utilizing tools, techniques, or exploits learned on ForenShield for unauthorized penetration, malicious exploitation, or illegal activities against external systems.',
              ),
              _buildSection(
                theme,
                foren,
                '3. Account Responsibility',
                'You are responsible for safeguarding your authentication credentials and session tokens. Shares of account access or automated lab exploitation are prohibited.',
              ),
              _buildSection(
                theme,
                foren,
                '4. Intellectual Property',
                'All simulation lab scenarios, academy courses, debrief reports, and software assets remain the intellectual property of ForenShield.',
              ),
              _buildSection(
                theme,
                foren,
                '5. Termination',
                'Violation of the Ethical Training Code or Terms of Service may result in immediate suspension or deletion of your agent profile.',
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
