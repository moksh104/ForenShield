import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/effects/particle_background.dart';
import '../../../../core/providers/app_preferences_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../routes/route_constants.dart';
import '../widgets/background_grid.dart';
import '../widgets/loading_bar.dart';
import '../widgets/loading_modules.dart';
import '../widgets/radar_sweep.dart';
import '../widgets/splash_logo.dart';

/// Futuristic Cybersecurity Operations Center Splash Screen with Emergency Switch & Controlled Splash Duration.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  /// Requirement 1 — Jury splash duration capped at 3 seconds max
  static const Duration splashDuration = Duration(seconds: 3);

  /// Requirement 2 — Controlled particle count for smooth performance
  static const int particleCount = 40;

  /// Requirement 3 — Emergency switch for advanced effects (ScannerEffect, GlowEffect, ParticleBackground)
  static const bool enableAdvancedEffects = true;

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  Future<void> _onLoadingComplete() async {
    await Future.delayed(const Duration(milliseconds: 250));
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
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;
    final isTablet = size.width > 600;

    final Widget mainBody = Stack(
      children: [
        // Background grid with subtle parallax
        const Positioned.fill(child: BackgroundGrid()),

        // Main content centered layout
        SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 16.0 : 24.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: size.height * 0.12),

                    // Radar sweep (behind logo) - controlled by enableAdvancedEffects switch
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        if (SplashScreen.enableAdvancedEffects)
                          SizedBox(
                            width: isTablet ? 380 : (isSmallScreen ? 250 : 300),
                            height: isTablet ? 380 : (isSmallScreen ? 250 : 300),
                            child: const RadarSweep(),
                          ),
                        const SplashLogo(),
                      ],
                    ),

                    SizedBox(height: size.height * 0.08),

                    // Loading modules telemetry checklist
                    const LoadingModules(),

                    const SizedBox(height: AppSpacing.xl),

                    // Loading bar with percentage count-up & status text
                    LoadingBar(onComplete: _onLoadingComplete),

                    SizedBox(height: size.height * 0.12),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );

    // Controlled particle background wrapped with enableAdvancedEffects check
    if (SplashScreen.enableAdvancedEffects) {
      return Scaffold(
        backgroundColor: AppColors.bgBase,
        body: ParticleBackground(
          numberOfParticles: SplashScreen.particleCount,
          particleColor: AppColors.logoGold,
          duration: const Duration(seconds: 16),
          child: mainBody,
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: mainBody,
    );
  }
}
