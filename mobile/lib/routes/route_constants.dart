/// Route name constants for ForenShield
class RouteConstants {
  RouteConstants._();

  // Internal Routes
  static const String catalog = '/catalog';

  // Auth Routes
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String forgotPasswordSuccess = '/forgot-password-success';

  // Main Routes
  static const String missionControl = '/mission-control';
  static const String academy = '/academy';
  static const String courseDetail = '/academy/course';
  static const String lessonPlayer = '/academy/lesson';
  static const String quizScreen = '/academy/quiz';
  static const String academyProgress = '/academy/progress';
  static const String simulation = '/simulation';
  static const String simulationRun = '/simulation/run';
  static const String simulationDebrief = '/simulation/debrief';
  static const String reports = '/reports';
  static const String reportDetail = '/reports/report';
  static const String investigation = '/investigation';
  static const String caseDetail = '/investigation/case';
  static const String evidenceViewer = '/investigation/evidence';
  static const String caseTimeline = '/investigation/timeline';
  static const String caseVerdict = '/investigation/verdict';
  static const String profile = '/profile';
  static const String achievementsWall = '/profile/achievements';
  static const String profileStats = '/profile/stats';
  static const String profileAccount = '/profile/account';
  static const String settings = '/settings';
}
