import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/app_preferences_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../routes/route_constants.dart';
import '../providers/onboarding_provider.dart';
import '../presentation/config/onboarding_animation_config.dart';
import '../presentation/config/onboarding_layout_config.dart';
import '../presentation/pages/welcome_page.dart';
import '../presentation/pages/academy_page.dart';
import '../presentation/pages/investigation_page.dart';
import '../presentation/widgets/onboarding_action_bar.dart';

/// Root shell for the onboarding flow.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _animateToPage(int page) {
    if (!_pageController.hasClients) return;
    _pageController.animateToPage(
      page,
      duration: OnboardingAnimationConfig.pageTransitionDuration,
      curve: OnboardingAnimationConfig.pageCurve,
    );
  }

  Future<void> _completeOnboarding() async {
    await ref.read(markOnboardingCompleteProvider)();
  }

  void _handleGetStarted() {
    _completeOnboarding().then((_) {
      if (mounted) context.go(RouteConstants.register);
    });
  }

  void _handleSignIn() {
    _completeOnboarding().then((_) {
      if (mounted) context.go(RouteConstants.login);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);

    ref.listen(onboardingProvider.select((s) => s.currentPage), (_, next) {
      final current = _pageController.hasClients
          ? _pageController.page?.round()
          : null;
      if (current != next) _animateToPage(next);
    });

    final actionBar = OnboardingActionBar(
      currentPage: state.currentPage,
      totalPages: state.totalPages,
      onNext: notifier.nextPage,
      onSkip: notifier.skipToLast,
      onGetStarted: _handleGetStarted,
      onSignIn: _handleSignIn,
      onDotTapped: notifier.setPage,
    );

    return PopScope(
      canPop: state.isFirstPage,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) notifier.previousPage();
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              // Top Bar: Skip Button (Right-aligned)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xxs,
                ),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _handleGetStarted,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                      ),
                    ),
                    child: Text(
                      'Skip',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: isDark
                            ? AppColors.textSecondary
                            : AppColors.lightTextSecondary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),

              // Main Onboarding PageView + Bottom Action Bar
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide =
                        constraints.maxWidth >=
                            OnboardingLayoutConfig.desktopWidthThreshold &&
                        constraints.maxHeight >=
                            OnboardingLayoutConfig.desktopHeightThreshold;
                    if (isWide) {
                      return _buildWideLayout(state, notifier, actionBar);
                    }
                    return _buildNarrowLayout(state, notifier, actionBar);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNarrowLayout(
    OnboardingState state,
    OnboardingNotifier notifier,
    Widget actionBar,
  ) {
    return Column(
      children: [
        Expanded(child: _buildPageView(state, notifier)),
        actionBar,
      ],
    );
  }

  Widget _buildWideLayout(
    OnboardingState state,
    OnboardingNotifier notifier,
    Widget actionBar,
  ) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Column(
          children: [
            Expanded(child: _buildPageView(state, notifier)),
            actionBar,
          ],
        ),
      ),
    );
  }

  Widget _buildPageView(OnboardingState state, OnboardingNotifier notifier) {
    return PageView.builder(
      controller: _pageController,
      itemCount: state.totalPages,
      physics: const BouncingScrollPhysics(),
      onPageChanged: notifier.setPage,
      itemBuilder: (context, index) => _pageContent(index),
    );
  }

  Widget _pageContent(int index) {
    switch (index) {
      case 0:
        return const WelcomePage();
      case 1:
        return const AcademyPage();
      case 2:
        return const InvestigationPage();
      default:
        return _OnboardingPageSlot(pageIndex: index);
    }
  }
}

class _OnboardingPageSlot extends StatelessWidget {
  final int pageIndex;

  const _OnboardingPageSlot({required this.pageIndex});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ColoredBox(
      color: theme.scaffoldBackgroundColor,
      child: Center(
        child: Text(
          'Page ${pageIndex + 1}',
          style: TextStyle(
            color: isDark
                ? AppColors.textSecondary
                : AppColors.lightTextSecondary,
          ),
        ),
      ),
    );
  }
}
