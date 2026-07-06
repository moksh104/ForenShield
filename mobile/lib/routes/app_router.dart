import 'package:go_router/go_router.dart';
import '../features/splash/presentation/pages/splash_screen.dart';
import '../features/onboarding/screens/onboarding_screen.dart';
import '../features/authentication/screens/login_screen.dart';
import '../features/authentication/screens/register_screen.dart';
import '../features/mission_control/screens/mission_control_screen.dart';
import '../features/academy/screens/cyber_academy_screen.dart';
import '../features/simulation/screens/simulation_lab_screen.dart';
import '../features/investigation/screens/investigation_lab_screen.dart';
import '../features/profile/screens/profile_screen.dart';
import '../features/settings/screens/settings_screen.dart';
import '../developer/catalog/pages/catalog_main_page.dart';
import 'route_constants.dart';

/// GoRouter configuration for ForenShield
final appRouter = GoRouter(
  initialLocation: RouteConstants.splash,
  routes: [
    // Developer Route (Internal)
    GoRoute(
      path: '/catalog',
      builder: (context, state) => const CatalogMainPage(),
    ),

    // Splash Route
    GoRoute(
      path: RouteConstants.splash,
      builder: (context, state) => const SplashScreen(),
    ),

    // Onboarding Route
    GoRoute(
      path: RouteConstants.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),

    // Auth Routes
    GoRoute(
      path: RouteConstants.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: RouteConstants.register,
      builder: (context, state) => const RegisterScreen(),
    ),

    // Main Routes
    GoRoute(
      path: RouteConstants.missionControl,
      builder: (context, state) => const MissionControlScreen(),
    ),
    GoRoute(
      path: RouteConstants.academy,
      builder: (context, state) => const CyberAcademyScreen(),
    ),
    GoRoute(
      path: RouteConstants.simulation,
      builder: (context, state) => const SimulationLabScreen(),
    ),
    GoRoute(
      path: RouteConstants.investigation,
      builder: (context, state) => const InvestigationLabScreen(),
    ),
    GoRoute(
      path: RouteConstants.profile,
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: RouteConstants.settings,
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);
