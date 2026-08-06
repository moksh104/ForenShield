import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../authentication/presentation/widgets/auth_logo.dart';
import '../widgets/welcome_illustration.dart';

/// Screen 1 of Onboarding Flow — Welcome to ForenShield matching design specification.
class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = AppColors.primary; // #2563EB Cobalt Blue
    final textPrimary = isDark
        ? AppColors.textPrimary
        : AppColors.lightTextPrimary;
    final textSecondary = isDark
        ? AppColors.textSecondary
        : AppColors.lightTextSecondary;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: AppSpacing.sm),

          // 1. Top Brand Header (Shield emblem + FORENSHIELD + Tagline)
          const AuthLogo(),

          const SizedBox(height: AppSpacing.xl),

          // 2. Headline: Welcome to ForenShield
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome to ',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      color: textPrimary,
                      fontWeight: FontWeight.w800,
                      fontSize: 28,
                    ),
                  ),
                  Text(
                    'ForenShield',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      color: primaryColor,
                      fontWeight: FontWeight.w800,
                      fontSize: 28,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Your hands-on companion to learn\ncybersecurity the practical way.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: textSecondary,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.08, end: 0),

          const SizedBox(height: AppSpacing.lg),

          // 3. Hero Laptop + Scanner + Shield Illustration
          const WelcomeIllustration(),

          const SizedBox(height: AppSpacing.lg),

          // 4. 3 Feature Pillar Cards (Learn, Investigate, Defend)
          Column(
            children: [
              _buildFeatureTile(
                context: context,
                iconData: Icons.menu_book_rounded,
                title: 'Learn',
                description:
                    'Build strong cybersecurity foundations with interactive lessons.',
                isDark: isDark,
                primaryColor: primaryColor,
                textPrimary: textPrimary,
                textSecondary: textSecondary,
              ),
              const Divider(height: AppSpacing.lg, thickness: 0.5),

              _buildFeatureTile(
                context: context,
                iconData: Icons.search_rounded,
                title: 'Investigate',
                description:
                    'Explore real-world attacks and analyze digital evidence.',
                isDark: isDark,
                primaryColor: primaryColor,
                textPrimary: textPrimary,
                textSecondary: textSecondary,
              ),
              const Divider(height: AppSpacing.lg, thickness: 0.5),

              _buildFeatureTile(
                context: context,
                iconData: Icons.shield_outlined,
                title: 'Defend',
                description:
                    'Strengthen your skills and defend systems like a pro.',
                isDark: isDark,
                primaryColor: primaryColor,
                textPrimary: textPrimary,
                textSecondary: textSecondary,
              ),
            ],
          ).animate(delay: 300.ms).fadeIn(duration: 400.ms),

          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  Widget _buildFeatureTile({
    required BuildContext context,
    required IconData iconData,
    required String title,
    required String description,
    required bool isDark,
    required Color primaryColor,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Rounded Badge Container
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: primaryColor.withValues(alpha: isDark ? 0.15 : 0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(child: Icon(iconData, size: 22, color: primaryColor)),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  fontFamily: 'Outfit',
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: TextStyle(
                  color: textSecondary,
                  fontSize: 12,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
