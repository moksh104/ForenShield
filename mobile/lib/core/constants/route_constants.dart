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
  static const String investigationWorkspace = '/investigation/:caseId/workspace';
  
  // Profile
  static const String profileHome = '/profile';
  static const String achievementsWall = '/profile/achievements';
  static const String settings = '/profile/settings';
}
