import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../routes/route_constants.dart';
import '../widgets/background_grid.dart';
import '../widgets/splash_logo.dart';
import '../widgets/radar_sweep.dart';
import '../widgets/loading_modules.dart';
import '../widgets/loading_bar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Temporary constant for first launch check
  // TODO: Replace with SharedPreferences in future sprint
  static const bool isFirstLaunch = true;

  void _onLoadingComplete() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        // Navigate based on onboarding status
        if (isFirstLaunch) {
          context.go(RouteConstants.onboarding);
        } else {
          context.go(RouteConstants.login);
        }
      }
    });
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
          const Positioned.fill(
            child: BackgroundGrid(),
          ),

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
                            height: isTablet ? 400 : (isSmallScreen ? 250 : 300),
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
                      LoadingBar(
                        onComplete: _onLoadingComplete,
                      ),

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
