/// Full route path constants for the ForenShield GoRouter.
///
/// This file defines the COMPLETE route specification including parameterised
/// deep-link paths (e.g. `/academy/:domainId/lesson/:lessonId`).
///
/// The active router ([lib/routes/app_router.dart]) currently imports the
/// simplified [lib/routes/route_constants.dart] which carries only the top-level
/// paths used by implemented screens. This file is the authoritative spec and
/// will replace [lib/routes/route_constants.dart] once all feature routes are
/// implemented.
///
/// Do NOT delete. This file is the single source of truth for route planning.
/// Route path constants for GoRouter
class RouteConstants {
  RouteConstants._();

  // Root & Auth
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/auth/login';
  static const String register = '/auth/register';

  // Main Shell
  static const String missionControl = '/home';

  // Academy
  static const String academyHome = '/academy';
  static const String domainDetail = '/academy/:domainId';
  static const String lessonPlayer = '/academy/:domainId/lesson/:lessonId';
  static const String lessonQuiz = '/academy/:domainId/lesson/:lessonId/quiz';

  // Simulation
  static const String simulationCatalogue = '/simulation';
  static const String simulationDetail = '/simulation/:simId';
  static const String simulationPlayer = '/simulation/:simId/play';

  // Investigation
  static const String casesCatalogue = '/investigation';
  static const String caseDetail = '/investigation/:caseId';
  static const String investigationWorkspace =
      '/investigation/:caseId/workspace';

  // Profile
  static const String profileHome = '/profile';
  static const String achievementsWall = '/profile/achievements';
  static const String settings = '/profile/settings';
}
