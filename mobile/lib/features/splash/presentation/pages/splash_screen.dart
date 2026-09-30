import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/logger/app_logger.dart';
import '../../../../core/providers/app_preferences_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../routes/route_constants.dart';
import '../../../authentication/providers/auth_state_provider.dart';
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
  bool _hasNavigated = false;

  Future<void> _onLoadingComplete() async {
    if (_hasNavigated || !mounted) return;
    _hasNavigated = true;

    try {
      final authState = ref.read(authStateProvider);
      final user = authState.isLoading
          ? await ref.read(authStateProvider.future)
          : authState.value;

      if (!mounted) return;

      if (user != null) {
        AppLogger.d(
          '[SplashScreen] Active session verified for ${user.email}. Routing to Mission Control.',
        );
        context.go(RouteConstants.missionControl);
        return;
      }

      final hasSeenOnboardingAsync = ref.read(hasSeenOnboardingProvider);
      final hasSeenOnboarding = hasSeenOnboardingAsync.isLoading
          ? await ref.read(hasSeenOnboardingProvider.future)
          : (hasSeenOnboardingAsync.value ?? false);

      if (!mounted) return;

      if (hasSeenOnboarding) {
        AppLogger.d('[SplashScreen] No active session. Routing to Login.');
        context.go(RouteConstants.login);
      } else {
        AppLogger.d('[SplashScreen] First time user. Routing to Onboarding.');
        context.go(RouteConstants.onboarding);
      }
    } catch (e) {
      AppLogger.w('[SplashScreen] Auth initialization check error: $e');
      if (mounted) {
        context.go(RouteConstants.login);
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
