import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers/app_preferences_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../routes/route_constants.dart';
import '../widgets/background_grid.dart';
import '../widgets/loading_bar.dart';
import '../widgets/splash_logo.dart';

/// Clean enterprise splash screen matching official design specification.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  Future<void> _onLoadingComplete() async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;

    final hasSeenOnboarding = await ref.read(hasSeenOnboardingProvider.future);
    if (mounted) {
      if (hasSeenOnboarding) {
        context.go(RouteConstants.login);
      } else {
        context.go(RouteConstants.onboarding);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = AppColors.primary;
    final backgroundColor = isDark
        ? AppColors.bgBase
        : AppColors.lightBackground;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),

            // Top & Center Section (3D Shield Emblem, Title, Tagline & World Map Matrix)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: SplashLogo(),
            ),

            const Spacer(flex: 1),

            // City Skyline & Suspension Bridge Vector Outline Artwork
            CitySkylineWidget(
              color: primaryColor.withValues(alpha: isDark ? 0.08 : 0.12),
            ),

            const SizedBox(height: AppSpacing.sm),

            // Bottom Section: Status text + Progress bar + % counter + Encryption Notice
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.lg),
              child: LoadingBar(onComplete: _onLoadingComplete),
            ),
          ],
        ),
      ),
    );
  }
}
