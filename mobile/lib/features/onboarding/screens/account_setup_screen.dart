import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/foren_theme.dart';
import '../../../routes/route_constants.dart';
import '../../authentication/presentation/widgets/auth_logo.dart';

/// 4-step post-registration onboarding wizard matching exact design specification.
class AccountSetupScreen extends ConsumerStatefulWidget {
  const AccountSetupScreen({super.key});

  @override
  ConsumerState<AccountSetupScreen> createState() => _AccountSetupScreenState();
}

class _AccountSetupScreenState extends ConsumerState<AccountSetupScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  // Step 1: Specialization selections
  final Set<int> _selectedSpecs = {0, 2, 4};
  // Step 2: Profile data
  final TextEditingController _nameController = TextEditingController(
    text: 'Samlee',
  );
  String _selectedRole = 'Student';
  int _selectedExpLevel = 1; // 0=Beginner, 1=Intermediate, 2=Advanced
  String _selectedGoal = 'Learn skills for a cyber security career';
  // Step 3: Explore interests
  final Set<int> _selectedExplore = {0, 2, 5};

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _goToStep(int step) {
    if (step < 0 || step > 3) return;
    setState(() => _currentStep = step);
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeInOutCubic,
    );
  }

  void _handleContinue() {
    if (_currentStep < 3) {
      _goToStep(_currentStep + 1);
    } else {
      context.go(RouteConstants.missionControl);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = AppColors.primary;
    final textPrimary = isDark
        ? AppColors.textPrimary
        : AppColors.lightTextPrimary;

    return Scaffold(
      backgroundColor: isDark ? theme.scaffoldBackgroundColor : Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Bar: Back + Logo + Step Indicator ──
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.sm,
                AppSpacing.xs,
                AppSpacing.lg,
                0,
              ),
              child: Column(
                children: [
                  // Back + Logo Row
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                        color: textPrimary,
                        onPressed: () {
                          if (_currentStep > 0) {
                            _goToStep(_currentStep - 1);
                          } else if (Navigator.of(context).canPop()) {
                            context.pop();
                          }
                        },
                      ),
                      const Expanded(child: AuthLogo(compact: true)),
                      const SizedBox(width: 40), // Balance the back button
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  // Step Indicator
                  _StepIndicator(currentStep: _currentStep, totalSteps: 4),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            // ── Main Content PageView ──
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => setState(() => _currentStep = i),
                children: [
                  _Step1Specialization(
                    selectedIndices: _selectedSpecs,
                    onToggle: (i) => setState(() {
                      _selectedSpecs.contains(i)
                          ? _selectedSpecs.remove(i)
                          : _selectedSpecs.add(i);
                    }),
                  ),
                  _Step2Profile(
                    nameController: _nameController,
                    selectedRole: _selectedRole,
                    selectedExpLevel: _selectedExpLevel,
                    selectedGoal: _selectedGoal,
                    onRoleChanged: (v) => setState(() => _selectedRole = v),
                    onExpLevelChanged: (v) =>
                        setState(() => _selectedExpLevel = v),
                    onGoalChanged: (v) => setState(() => _selectedGoal = v),
                  ),
                  _Step3Customize(
                    selectedIndices: _selectedExplore,
                    onToggle: (i) => setState(() {
                      _selectedExplore.contains(i)
                          ? _selectedExplore.remove(i)
                          : _selectedExplore.add(i);
                    }),
                  ),
                  const _Step4Complete(),
                ],
              ),
            ),

            // ── Bottom Action Bar ──
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.xs,
                  AppSpacing.lg,
                  AppSpacing.md,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Primary CTA Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _handleContinue,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: AppRadius.borderRadiusLg,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _currentStep == 3
                                  ? 'Enter ForenShield'
                                  : 'Continue',
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.3,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            const Icon(
                              Icons.arrow_forward,
                              size: 18,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    // Footer Privacy Text
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.lock_outline,
                          size: 13,
                          color: isDark
                              ? AppColors.textSecondary
                              : AppColors.lightTextSecondary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _currentStep == 3
                              ? 'Your privacy is our priority'
                              : 'Your data is secure and private.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isDark
                                ? AppColors.textSecondary
                                : AppColors.lightTextSecondary,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// STEP INDICATOR
// ═══════════════════════════════════════════════════════════════════════════════

class _StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const _StepIndicator({required this.currentStep, required this.totalSteps});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = AppColors.primary;
    final inactiveColor = isDark
        ? AppColors.surfaceRaised1
        : const Color(0xFFE2E8F0);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps * 2 - 1, (index) {
        if (index.isOdd) {
          // Connector line between steps
          final stepBefore = index ~/ 2;
          final isCompleted = stepBefore < currentStep;
          return Container(
            width: 40,
            height: 2,
            color: isCompleted ? primaryColor : inactiveColor,
          );
        }
        // Step circle
        final stepIndex = index ~/ 2;
        final isActive = stepIndex == currentStep;
        final isCompleted = stepIndex < currentStep;

        return Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: (isActive || isCompleted)
                ? primaryColor
                : Colors.transparent,
            border: Border.all(
              color: (isActive || isCompleted) ? primaryColor : inactiveColor,
              width: 1.5,
            ),
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check, size: 14, color: Colors.white)
                : Text(
                    '${stepIndex + 1}',
                    style: TextStyle(
                      color: isActive
                          ? Colors.white
                          : (isDark
                                ? AppColors.textSecondary
                                : AppColors.lightTextSecondary),
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
          ),
        );
      }),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// STEP 1: CHOOSE YOUR SPECIALIZATION
// ═══════════════════════════════════════════════════════════════════════════════

class _Step1Specialization extends StatelessWidget {
  final Set<int> selectedIndices;
  final void Function(int) onToggle;

  const _Step1Specialization({
    required this.selectedIndices,
    required this.onToggle,
  });

  static const _specs = [
    (
      'Digital Forensics',
      'Investigate digital evidence and uncover the truth.',
      Icons.fingerprint,
    ),
    (
      'Malware Analysis',
      'Analyze malicious software and understand attacker techniques.',
      Icons.bug_report_outlined,
    ),
    (
      'Phishing Detection',
      'Identify phishing attacks and protect users.',
      Icons.mark_email_unread_outlined,
    ),
    (
      'Network Security',
      'Monitor, analyze, and secure networks from threats.',
      Icons.hub_outlined,
    ),
    (
      'Incident Response',
      'Learn to respond to security incidents effectively.',
      Icons.shield_outlined,
    ),
    (
      'Threat Intelligence',
      'Collect and analyze threat data to stay ahead.',
      Icons.search_rounded,
    ),
    (
      'OSINT',
      'Gather open-source intelligence and piece together the story.',
      Icons.person_search_outlined,
    ),
    (
      'Mobile Security',
      'Explore mobile threats and secure mobile environments.',
      Icons.smartphone_outlined,
    ),
    (
      'Cloud Security',
      'Understand cloud risks and security best practices.',
      Icons.cloud_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = AppColors.primary;
    final textPrimary = isDark
        ? AppColors.textPrimary
        : AppColors.lightTextPrimary;
    final textSecondary = isDark
        ? AppColors.textSecondary
        : AppColors.lightTextSecondary;
    final foren = theme.extension<ForenColors>()!;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Center(
            child: Text(
              'Choose your specialization',
              style: theme.textTheme.headlineMedium?.copyWith(
                color: textPrimary,
                fontWeight: FontWeight.w800,
                fontSize: 24,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Center(
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: textSecondary,
                ),
                children: [
                  const TextSpan(text: 'Select '),
                  TextSpan(
                    text: 'at least 3',
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const TextSpan(
                    text:
                        ' areas you\'re interested in.\nWe\'ll personalize your learning path.',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // 3x3 Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _specs.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: AppSpacing.md,
              crossAxisSpacing: AppSpacing.md,
              childAspectRatio: 0.72,
            ),
            itemBuilder: (context, index) {
              final spec = _specs[index];
              final isSelected = selectedIndices.contains(index);
              return GestureDetector(
                onTap: () => onToggle(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? primaryColor.withValues(alpha: isDark ? 0.12 : 0.04)
                        : (isDark ? AppColors.surface : Colors.white),
                    borderRadius: AppRadius.borderRadiusLg,
                    border: Border.all(
                      color: isSelected
                          ? primaryColor
                          : (isDark
                                ? foren.borderSubtle
                                : const Color(0xFFE2E8F0)),
                      width: isSelected ? 1.5 : 1.0,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Check badge
                      Positioned(
                        top: 0,
                        right: 0,
                        child: _SelectionBadge(isSelected: isSelected),
                      ),
                      // Content
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: primaryColor.withValues(alpha: 0.08),
                            ),
                            child: Center(
                              child: Icon(
                                spec.$3,
                                size: 22,
                                color: primaryColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            spec.$1,
                            style: TextStyle(
                              color: textPrimary,
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                              fontFamily: 'Outfit',
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            spec.$2,
                            style: TextStyle(color: textSecondary, fontSize: 9),
                            textAlign: TextAlign.center,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: AppSpacing.lg),

          // Info Notice
          _InfoNotice(
            text:
                'You can always update your interests later from your profile settings.',
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// STEP 2: SET UP YOUR PROFILE
// ═══════════════════════════════════════════════════════════════════════════════

class _Step2Profile extends StatelessWidget {
  final TextEditingController nameController;
  final String selectedRole;
  final int selectedExpLevel;
  final String selectedGoal;
  final void Function(String) onRoleChanged;
  final void Function(int) onExpLevelChanged;
  final void Function(String) onGoalChanged;

  const _Step2Profile({
    required this.nameController,
    required this.selectedRole,
    required this.selectedExpLevel,
    required this.selectedGoal,
    required this.onRoleChanged,
    required this.onExpLevelChanged,
    required this.onGoalChanged,
  });

  static const _roles = ['Student', 'Professional', 'Hobbyist', 'Researcher'];
  static const _goals = [
    'Learn skills for a cyber security career',
    'Enhance my current security skills',
    'Prepare for certifications',
    'Personal interest and curiosity',
  ];
  static const _expLevels = [
    ('Beginner', 'I\'m new to cybersecurity.', Icons.signal_cellular_alt_1_bar),
    (
      'Intermediate',
      'I have some basic knowledge.',
      Icons.signal_cellular_alt_2_bar,
    ),
    (
      'Advanced',
      'I have advanced knowledge and experience.',
      Icons.signal_cellular_alt,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = AppColors.primary;
    final textPrimary = isDark
        ? AppColors.textPrimary
        : AppColors.lightTextPrimary;
    final textSecondary = isDark
        ? AppColors.textSecondary
        : AppColors.lightTextSecondary;
    final foren = theme.extension<ForenColors>()!;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + Avatar Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Let\'s set up your profile',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: textPrimary,
                        fontWeight: FontWeight.w800,
                        fontSize: 22,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Tell us a bit about yourself\nso we can personalize your experience.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              // Profile Avatar
              Stack(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primaryColor.withValues(alpha: 0.08),
                      border: Border.all(
                        color: primaryColor.withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Icon(Icons.person, size: 32, color: primaryColor),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: primaryColor,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // Display Name
          Text(
            'Display Name',
            style: TextStyle(
              color: textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          _buildInputField(
            context: context,
            child: TextField(
              controller: nameController,
              style: TextStyle(color: textPrimary, fontSize: 15),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Your name',
                hintStyle: TextStyle(
                  color: textSecondary.withValues(alpha: 0.6),
                ),
                prefixIcon: Icon(
                  Icons.person_outline,
                  color: textSecondary,
                  size: 20,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // What do you do?
          Text(
            'What do you do?',
            style: TextStyle(
              color: textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          _buildInputField(
            context: context,
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedRole,
                isExpanded: true,
                icon: Icon(Icons.keyboard_arrow_down, color: textSecondary),
                style: TextStyle(color: textPrimary, fontSize: 15),
                dropdownColor: isDark ? AppColors.surface : Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                items: _roles
                    .map(
                      (r) => DropdownMenuItem(
                        value: r,
                        child: Row(
                          children: [
                            Icon(
                              Icons.work_outline,
                              size: 20,
                              color: textSecondary,
                            ),
                            const SizedBox(width: 10),
                            Text(r),
                          ],
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (v) {
                  if (v != null) onRoleChanged(v);
                },
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // Experience Level
          Text(
            'Your experience level',
            style: TextStyle(
              color: textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: List.generate(3, (index) {
              final exp = _expLevels[index];
              final isSelected = selectedExpLevel == index;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: index == 0 ? 0 : 4,
                    right: index == 2 ? 0 : 4,
                  ),
                  child: GestureDetector(
                    onTap: () => onExpLevelChanged(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? primaryColor.withValues(
                                alpha: isDark ? 0.12 : 0.04,
                              )
                            : (isDark ? AppColors.surface : Colors.white),
                        borderRadius: AppRadius.borderRadiusLg,
                        border: Border.all(
                          color: isSelected
                              ? primaryColor
                              : (isDark
                                    ? foren.borderSubtle
                                    : const Color(0xFFE2E8F0)),
                          width: isSelected ? 1.5 : 1.0,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            right: 0,
                            child: _SelectionBadge(isSelected: isSelected),
                          ),
                          Column(
                            children: [
                              Icon(exp.$3, size: 24, color: primaryColor),
                              const SizedBox(height: 6),
                              Text(
                                exp.$1,
                                style: TextStyle(
                                  color: textPrimary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                exp.$2,
                                style: TextStyle(
                                  color: textSecondary,
                                  fontSize: 10,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: AppSpacing.lg),

          // Your goal
          Text(
            'Your goal',
            style: TextStyle(
              color: textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          _buildInputField(
            context: context,
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedGoal,
                isExpanded: true,
                icon: Icon(Icons.keyboard_arrow_down, color: textSecondary),
                style: TextStyle(color: textPrimary, fontSize: 14),
                dropdownColor: isDark ? AppColors.surface : Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                items: _goals
                    .map(
                      (g) => DropdownMenuItem(
                        value: g,
                        child: Row(
                          children: [
                            Icon(
                              Icons.flag_outlined,
                              size: 20,
                              color: textSecondary,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(g, overflow: TextOverflow.ellipsis),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (v) {
                  if (v != null) onGoalChanged(v);
                },
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // Info Banner
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.04),
              borderRadius: AppRadius.borderRadiusLg,
              border: Border.all(color: primaryColor.withValues(alpha: 0.15)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your learning, your way.',
                        style: TextStyle(
                          color: textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'We\'ll recommend the best path, labs,\nand challenges based on your goals.',
                        style: TextStyle(color: textSecondary, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.track_changes,
                  size: 32,
                  color: primaryColor.withValues(alpha: 0.2),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required BuildContext context,
    required Widget child,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final foren = Theme.of(context).extension<ForenColors>()!;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surface : Colors.white,
        borderRadius: AppRadius.borderRadiusMd,
        border: Border.all(
          color: isDark ? foren.borderSubtle : const Color(0xFFE2E8F0),
        ),
      ),
      child: child,
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// STEP 3: CUSTOMIZE YOUR EXPERIENCE
// ═══════════════════════════════════════════════════════════════════════════════

class _Step3Customize extends StatelessWidget {
  final Set<int> selectedIndices;
  final void Function(int) onToggle;

  const _Step3Customize({
    required this.selectedIndices,
    required this.onToggle,
  });

  static const _items = [
    (
      'Hands-on Labs',
      'Practice with real tools in safe environments.',
      Icons.computer_outlined,
    ),
    (
      'Learning Paths',
      'Follow structured courses and paths.',
      Icons.route_outlined,
    ),
    (
      'Investigations',
      'Solve real-world cases and challenges.',
      Icons.manage_search,
    ),
    (
      'Challenges',
      'Test your skills and earn achievements.',
      Icons.emoji_events_outlined,
    ),
    (
      'Cyber News',
      'Stay updated with the latest in cybersecurity.',
      Icons.newspaper_outlined,
    ),
    (
      'Community',
      'Connect, discuss and learn together.',
      Icons.groups_outlined,
    ),
    (
      'Career Resources',
      'Guides, roadmaps and job opportunities.',
      Icons.work_outline,
    ),
    (
      'Developer Security',
      'Secure code, apps and development workflows.',
      Icons.code_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = AppColors.primary;
    final textPrimary = isDark
        ? AppColors.textPrimary
        : AppColors.lightTextPrimary;
    final textSecondary = isDark
        ? AppColors.textSecondary
        : AppColors.lightTextSecondary;
    final foren = theme.extension<ForenColors>()!;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + Illustration
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Customize your\nexperience',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: textPrimary,
                        fontWeight: FontWeight.w800,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Choose what you want to focus on.\nWe\'ll show relevant content and labs.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              // Mini illustration
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Icons.dashboard_outlined,
                      size: 28,
                      color: primaryColor.withValues(alpha: 0.4),
                    ),
                    Positioned(
                      bottom: 6,
                      right: 6,
                      child: Icon(
                        Icons.settings,
                        size: 18,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // Section Label
          Text(
            'What would you like to explore?',
            style: TextStyle(
              color: textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Select all that interest you',
            style: TextStyle(color: textSecondary, fontSize: 12),
          ),

          const SizedBox(height: AppSpacing.md),

          // 2-column Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _items.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: AppSpacing.md,
              crossAxisSpacing: AppSpacing.md,
              childAspectRatio: 1.55,
            ),
            itemBuilder: (context, index) {
              final item = _items[index];
              final isSelected = selectedIndices.contains(index);
              return GestureDetector(
                onTap: () => onToggle(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? primaryColor.withValues(alpha: isDark ? 0.12 : 0.04)
                        : (isDark ? AppColors.surface : Colors.white),
                    borderRadius: AppRadius.borderRadiusLg,
                    border: Border.all(
                      color: isSelected
                          ? primaryColor
                          : (isDark
                                ? foren.borderSubtle
                                : const Color(0xFFE2E8F0)),
                      width: isSelected ? 1.5 : 1.0,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: primaryColor.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Icon(
                                item.$3,
                                size: 20,
                                color: primaryColor,
                              ),
                            ),
                          ),
                          const Spacer(),
                          _SelectionBadge(isSelected: isSelected),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        item.$1,
                        style: TextStyle(
                          color: textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.$2,
                        style: TextStyle(color: textSecondary, fontSize: 10),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: AppSpacing.lg),

          // Info Notice with Got it
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.04),
              borderRadius: AppRadius.borderRadiusLg,
              border: Border.all(color: primaryColor.withValues(alpha: 0.15)),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle_outline, size: 18, color: primaryColor),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'You can update these preferences anytime from your profile settings.',
                    style: TextStyle(color: textSecondary, fontSize: 11),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Got it! You can change these later in Settings.',
                        ),
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(40, 30),
                  ),
                  child: Text(
                    'Got it',
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// STEP 4: ALL SET!
// ═══════════════════════════════════════════════════════════════════════════════

class _Step4Complete extends StatelessWidget {
  const _Step4Complete();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = AppColors.primary;
    final textPrimary = isDark
        ? AppColors.textPrimary
        : AppColors.lightTextPrimary;
    final textSecondary = isDark
        ? AppColors.textSecondary
        : AppColors.lightTextSecondary;
    final foren = theme.extension<ForenColors>()!;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          // All set! heading
          Text(
            'All set!',
            style: theme.textTheme.headlineLarge?.copyWith(
              color: textPrimary,
              fontWeight: FontWeight.w800,
              fontSize: 32,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Your profile is ready and your learning\nenvironment has been personalized.',
            style: theme.textTheme.bodyMedium?.copyWith(color: textSecondary),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppSpacing.lg),

          // Hero Illustration (Laptop + surrounding items)
          SizedBox(
            width: 300,
            height: 180,
            child: CustomPaint(
              painter: _AllSetIllustrationPainter(
                primaryColor: primaryColor,
                isDark: isDark,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Laptop
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 140,
                        height: 90,
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.surface : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isDark
                                ? AppColors.borderDefault
                                : const Color(0xFF1E293B),
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withValues(alpha: 0.1),
                              blurRadius: 14,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Image.asset(
                            'assets/logos/app_logo.png',
                            width: 48,
                            height: 48,
                          ),
                        ),
                      ),
                      Container(
                        width: 160,
                        height: 8,
                        decoration: BoxDecoration(
                          color: const Color(0xFFCBD5E1),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(6),
                            bottomRight: Radius.circular(6),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Magnifying glass (left)
                  Positioned(
                    left: 15,
                    bottom: 30,
                    child: Icon(
                      Icons.search,
                      size: 36,
                      color: primaryColor.withValues(alpha: 0.25),
                    ),
                  ),
                  // Evidence clipboard (right)
                  Positioned(
                    right: 20,
                    top: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surface : Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Text(
                        'EVIDENCE',
                        style: TextStyle(
                          color: textSecondary,
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // "Here's what you can do now" Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surface : const Color(0xFFF8FAFC),
              borderRadius: AppRadius.borderRadiusLg,
              border: Border.all(
                color: isDark ? foren.borderSubtle : const Color(0xFFE2E8F0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Here\'s what you can do now',
                  style: TextStyle(
                    color: textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                _buildActionRow(
                  Icons.menu_book_rounded,
                  'Start Learning',
                  'Explore tailored learning paths based on your interests.',
                  primaryColor,
                  textPrimary,
                  textSecondary,
                ),
                Divider(
                  height: AppSpacing.lg,
                  color: isDark ? foren.borderSubtle : const Color(0xFFE2E8F0),
                ),
                _buildActionRow(
                  Icons.science_outlined,
                  'Practice in Labs',
                  'Hands-on labs with real cybersecurity tools.',
                  primaryColor,
                  textPrimary,
                  textSecondary,
                ),
                Divider(
                  height: AppSpacing.lg,
                  color: isDark ? foren.borderSubtle : const Color(0xFFE2E8F0),
                ),
                _buildActionRow(
                  Icons.manage_search,
                  'Solve Investigations',
                  'Work on real-world scenarios and build your skills.',
                  primaryColor,
                  textPrimary,
                  textSecondary,
                ),
                Divider(
                  height: AppSpacing.lg,
                  color: isDark ? foren.borderSubtle : const Color(0xFFE2E8F0),
                ),
                _buildActionRow(
                  Icons.groups_outlined,
                  'Join the Community',
                  'Connect, discuss and learn with other defenders.',
                  primaryColor,
                  textPrimary,
                  textSecondary,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }

  Widget _buildActionRow(
    IconData icon,
    String title,
    String subtitle,
    Color primaryColor,
    Color textPrimary,
    Color textSecondary,
  ) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: primaryColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(child: Icon(icon, size: 20, color: primaryColor)),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(color: textSecondary, fontSize: 11),
                maxLines: 2,
              ),
            ],
          ),
        ),
        Icon(Icons.chevron_right, size: 20, color: textSecondary),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SHARED WIDGETS
// ═══════════════════════════════════════════════════════════════════════════════

class _SelectionBadge extends StatelessWidget {
  final bool isSelected;
  const _SelectionBadge({required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final foren = Theme.of(context).extension<ForenColors>()!;
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? AppColors.primary : Colors.transparent,
        border: Border.all(
          color: isSelected
              ? AppColors.primary
              : (isDark ? foren.borderSubtle : const Color(0xFFE2E8F0)),
          width: 1.2,
        ),
      ),
      child: isSelected
          ? const Icon(Icons.check, size: 12, color: Colors.white)
          : null,
    );
  }
}

class _InfoNotice extends StatelessWidget {
  final String text;
  const _InfoNotice({required this.text});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = AppColors.primary;
    final textSecondary = isDark
        ? AppColors.textSecondary
        : AppColors.lightTextSecondary;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.04),
        borderRadius: AppRadius.borderRadiusLg,
        border: Border.all(color: primaryColor.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline, size: 18, color: primaryColor),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: textSecondary, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// STEP 4 ILLUSTRATION PAINTER
// ═══════════════════════════════════════════════════════════════════════════════

class _AllSetIllustrationPainter extends CustomPainter {
  final Color primaryColor;
  final bool isDark;

  _AllSetIllustrationPainter({
    required this.primaryColor,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = primaryColor.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Background decorative lines
    final w = size.width;
    final h = size.height;

    canvas.drawLine(Offset(20, h * 0.3), Offset(60, h * 0.3), paint);
    canvas.drawLine(Offset(w - 20, h * 0.35), Offset(w - 60, h * 0.35), paint);
    canvas.drawLine(Offset(40, h * 0.7), Offset(80, h * 0.7), paint);
    canvas.drawLine(Offset(w - 30, h * 0.65), Offset(w - 70, h * 0.65), paint);
  }

  @override
  bool shouldRepaint(covariant _AllSetIllustrationPainter old) =>
      old.primaryColor != primaryColor || old.isDark != isDark;
}
