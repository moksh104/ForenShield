import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/splash/presentation/pages/splash_screen.dart';
import '../features/onboarding/screens/onboarding_screen.dart';
import '../features/authentication/screens/login_screen.dart';
import '../features/authentication/screens/register_screen.dart';
import '../features/authentication/screens/otp_screen.dart';
import '../features/authentication/screens/forgot_password_screen.dart';
import '../features/authentication/screens/forgot_password_success_screen.dart';
import '../features/mission_control/screens/mission_control_screen.dart';
import '../features/academy/screens/cyber_academy_screen.dart';
import '../features/academy/presentation/pages/course_detail_screen.dart';
import '../features/academy/presentation/pages/lesson_player_screen.dart';
import '../features/academy/presentation/pages/quiz_screen.dart';
import '../features/academy/presentation/pages/learning_progress_screen.dart';
import '../features/simulation/screens/simulation_lab_screen.dart';
import '../features/simulation/presentation/pages/scenario_runner_screen.dart';
import '../features/simulation/presentation/pages/scenario_debrief_screen.dart';
import '../features/reports/presentation/pages/report_detail_screen.dart';
import '../features/reports/presentation/pages/reports_list_screen.dart';
import '../features/investigation/screens/investigation_lab_screen.dart';
import '../features/home/presentation/pages/home_screen.dart';
import '../features/investigation/presentation/pages/case_detail_screen.dart';
import '../features/investigation/presentation/pages/evidence_viewer_screen.dart';
import '../features/investigation/presentation/pages/investigation_timeline_screen.dart';
import '../features/investigation/presentation/pages/verdict_screen.dart';
import '../features/profile/screens/achievements_screen.dart';
import '../features/profile/screens/profile_screen.dart';
import '../features/profile/presentation/pages/profile_statistics_screen.dart';
import '../features/profile/presentation/pages/account_edit_screen.dart';
import '../features/settings/screens/settings_screen.dart';
import '../features/settings/presentation/pages/privacy_policy_screen.dart';
import '../features/settings/presentation/pages/terms_conditions_screen.dart';
import '../features/notifications/presentation/pages/notification_screen.dart';
import '../features/leaderboard/presentation/pages/leaderboard_screen.dart';
import '../features/achievements/presentation/pages/achievement_screen.dart';
import '../developer/catalog/pages/catalog_main_page.dart';
import 'route_constants.dart';
import 'auth_guard.dart';
import 'router_notifier.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final notifier = ref.watch(routerNotifierProvider);

  return GoRouter(
    initialLocation: RouteConstants.splash,
    refreshListenable: notifier,
    redirect: (context, state) => AuthGuard.redirect(context, state, notifier),
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('Page not found: ${state.uri.toString()}')),
    ),
    routes: [
      // Developer Tool (Internal)
      GoRoute(
        name: 'catalog',
        path: '/catalog',
        builder: (context, state) => const CatalogMainPage(),
      ),

      // Public Routes
      GoRoute(
        name: 'splash',
        path: RouteConstants.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        name: 'onboarding',
        path: RouteConstants.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        name: 'login',
        path: RouteConstants.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        name: 'register',
        path: RouteConstants.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        name: 'otp',
        path: RouteConstants.otp,
        builder: (context, state) => OtpScreen(email: state.extra as String?),
      ),
      GoRoute(
        name: 'forgotPassword',
        path: RouteConstants.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        name: 'forgotPasswordSuccess',
        path: RouteConstants.forgotPasswordSuccess,
        builder: (context, state) => const ForgotPasswordSuccessScreen(),
      ),

      // Protected Routes
      GoRoute(
        name: 'dashboard',
        path: RouteConstants.dashboard,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        name: 'missionControl',
        path: RouteConstants.missionControl,
        builder: (context, state) => const MissionControlScreen(),
      ),
      GoRoute(
        name: 'academy',
        path: RouteConstants.academy,
        builder: (context, state) => const CyberAcademyScreen(),
      ),
      GoRoute(
        name: 'courseDetail',
        path: '${RouteConstants.courseDetail}/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return CourseDetailScreen(courseId: id);
        },
      ),
      GoRoute(
        name: 'lessonPlayer',
        path: '${RouteConstants.lessonPlayer}/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return LessonPlayerScreen(lessonId: id);
        },
      ),
      GoRoute(
        name: 'quizScreen',
        path: '${RouteConstants.quizScreen}/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return QuizScreen(quizId: id);
        },
      ),
      GoRoute(
        name: 'academyProgress',
        path: RouteConstants.academyProgress,
        builder: (context, state) => const LearningProgressScreen(),
      ),
      GoRoute(
        name: 'simulation',
        path: RouteConstants.simulation,
        builder: (context, state) => const SimulationLabScreen(),
      ),
      GoRoute(
        name: 'simulationRun',
        path: '${RouteConstants.simulationRun}/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return ScenarioRunnerScreen(scenarioId: id);
        },
      ),
      GoRoute(
        name: 'legacyScenarioRunner',
        path: '${RouteConstants.legacyScenarioRunner}/:id',
        redirect: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return '${RouteConstants.simulationRun}/$id';
        },
      ),
      GoRoute(
        name: 'simulationDebrief',
        path: '${RouteConstants.simulationDebrief}/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return ScenarioDebriefScreen(scenarioId: id);
        },
      ),
      GoRoute(
        name: 'reports',
        path: RouteConstants.reports,
        builder: (context, state) => const ReportsListScreen(),
      ),
      GoRoute(
        name: 'reportDetail',
        path: '${RouteConstants.reportDetail}/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return ReportDetailScreen(reportId: id);
        },
      ),
      GoRoute(
        name: 'investigation',
        path: RouteConstants.investigation,
        builder: (context, state) => const InvestigationLabScreen(),
      ),
      GoRoute(
        name: 'caseDetail',
        path: '${RouteConstants.caseDetail}/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return CaseDetailScreen(caseId: id);
        },
      ),
      GoRoute(
        name: 'evidenceViewer',
        path: '${RouteConstants.evidenceViewer}/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return EvidenceViewerScreen(evidenceId: id);
        },
      ),
      GoRoute(
        name: 'caseTimeline',
        path: '${RouteConstants.caseTimeline}/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return InvestigationTimelineScreen(caseId: id);
        },
      ),
      GoRoute(
        name: 'caseVerdict',
        path: '${RouteConstants.caseVerdict}/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return VerdictScreen(caseId: id);
        },
      ),
      GoRoute(
        name: 'profile',
        path: RouteConstants.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        name: 'leaderboard',
        path: RouteConstants.leaderboard,
        builder: (context, state) => const LeaderboardScreen(),
      ),
      GoRoute(
        name: 'achievementsFeature',
        path: RouteConstants.achievements,
        builder: (context, state) => const AchievementScreen(),
      ),
      GoRoute(
        name: 'achievements',
        path: RouteConstants.achievementsWall,
        builder: (context, state) => const AchievementsScreen(),
      ),
      GoRoute(
        name: 'profileStats',
        path: RouteConstants.profileStats,
        builder: (context, state) => const ProfileStatisticsScreen(),
      ),
      GoRoute(
        name: 'profileAccount',
        path: RouteConstants.profileAccount,
        builder: (context, state) => const AccountEditScreen(),
      ),
      GoRoute(
        name: 'settings',
        path: RouteConstants.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        name: 'notifications',
        path: RouteConstants.notifications,
        builder: (context, state) => const NotificationScreen(),
      ),
      GoRoute(
        name: 'privacyPolicy',
        path: RouteConstants.privacyPolicy,
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),
      GoRoute(
        name: 'termsConditions',
        path: RouteConstants.termsConditions,
        builder: (context, state) => const TermsConditionsScreen(),
      ),
    ],
  );
});
