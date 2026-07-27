import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers/app_preferences_provider.dart';
import '../../../../routes/route_constants.dart';
import '../widgets/background_grid.dart';
import '../widgets/splash_logo.dart';
import '../widgets/radar_sweep.dart';
import '../widgets/loading_modules.dart';
import '../widgets/loading_bar.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  Future<void> _onLoadingComplete() async {
    await Future.delayed(const Duration(milliseconds: 500));
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

    return Scaffold(
      backgroundColor: const Color(0xFF0E1116),
      body: Stack(
        children: [
          // Background grid with subtle parallax
          const Positioned.fill(child: BackgroundGrid()),

          // Main content
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
                      SizedBox(height: size.height * 0.15),

                      // Radar sweep (behind logo)
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: isTablet ? 400 : (isSmallScreen ? 250 : 300),
                            height: isTablet
                                ? 400
                                : (isSmallScreen ? 250 : 300),
                            child: const RadarSweep(),
                          ),
                          const SplashLogo(),
                        ],
                      ),

                      SizedBox(height: size.height * 0.1),

                      // Loading modules
                      const LoadingModules(),

                      const SizedBox(height: 40),

                      // Loading bar with status
                      LoadingBar(onComplete: _onLoadingComplete),

                      SizedBox(height: size.height * 0.15),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
