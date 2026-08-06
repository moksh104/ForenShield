import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/effects/glass_effect.dart';
import '../../../core/effects/particle_background.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/foren_theme.dart';
import '../../../core/exceptions/app_exceptions.dart';
import '../../../core/validators/form_validators.dart';
import '../presentation/widgets/auth_button.dart';
import '../presentation/widgets/auth_logo.dart';
import '../presentation/widgets/auth_text_field.dart';
import '../providers/auth_state_provider.dart';

/// Production-grade cybersecurity registration screen for ForenShield.
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  double _calculatePasswordStrength(String password) {
    if (password.isEmpty) return 0.0;
    double strength = 0.0;
    if (password.length >= 8) strength += 0.3;
    if (password.contains(RegExp(r'[A-Z]'))) strength += 0.25;
    if (password.contains(RegExp(r'[0-9]'))) strength += 0.25;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength += 0.2;
    return strength.clamp(0.0, 1.0);
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await ref.read(authStateProvider.notifier).register(
      _emailController.text.trim(),
      _passwordController.text,
      _nameController.text.trim(),
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    result.when(
      success: (_) {
        // AuthGuard will automatically redirect to Mission Control
      },
      failure: (exception) {
        setState(() {
          _errorMessage = exception is AppException
              ? exception.userMessage
              : exception.toString();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final primaryColor = theme.colorScheme.primary;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    final pwdStrength = _calculatePasswordStrength(_passwordController.text);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: ParticleBackground(
        numberOfParticles: 25,
        particleColor: primaryColor,
        duration: const Duration(seconds: 16),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.xl,
                AppSpacing.lg,
                AppSpacing.lg + bottomInset,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: GlassEffect(
                  blurX: 18.0,
                  blurY: 18.0,
                  opacity: 0.14,
                  borderRadius: AppRadius.borderRadiusLg,
                  border: Border.all(
                    color: foren.borderSubtle.withValues(alpha: 0.4),
                  ),
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo
                        const AuthLogo(compact: true).animate().fadeIn(duration: 400.ms, delay: 50.ms).slideY(begin: -0.1, end: 0),
                        const SizedBox(height: AppSpacing.xl),

                        // Title
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'CREATE AGENT PROFILE',
                                style: TextStyle(
                                  color: theme.colorScheme.onSurface,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: 'monospace',
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xxs),
                              Text(
                                'Enlist in the enterprise cyber defense network',
                                style: TextStyle(
                                  color: foren.textDisabled,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ).animate().fadeIn(duration: 400.ms, delay: 100.ms).slideY(begin: 0.08, end: 0),
                        const SizedBox(height: AppSpacing.lg),

                        // Error Banner Transition
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: _errorMessage != null
                              ? Container(
                                  key: ValueKey(_errorMessage),
                                  margin: const EdgeInsets.only(bottom: AppSpacing.md),
                                  padding: const EdgeInsets.all(AppSpacing.sm),
                                  decoration: BoxDecoration(
                                    color: foren.critical.t500.withValues(alpha: 0.15),
                                    borderRadius: AppRadius.borderRadiusMd,
                                    border: Border.all(
                                      color: foren.critical.t500.withValues(alpha: 0.5),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.gpp_maybe_outlined,
                                        color: foren.critical.t500,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          _errorMessage!,
                                          style: TextStyle(
                                            color: foren.critical.t500,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ).animate().shake(duration: 400.ms).fadeIn()
                              : const SizedBox.shrink(),
                        ),

                        // Full Name
                        AuthTextField(
                          controller: _nameController,
                          label: 'Full Name / Agent Alias',
                          hintText: 'Agent Alex Mercer',
                          focusNode: _nameFocus,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          validator: FormValidators.username,
                          onFieldSubmitted: (_) =>
                              FocusScope.of(context).requestFocus(_emailFocus),
                          prefixIcon: const Icon(Icons.person_outline),
                        ).animate().fadeIn(duration: 400.ms, delay: 140.ms).slideY(begin: 0.08, end: 0),
                        const SizedBox(height: AppSpacing.md),

                        // Email
                        AuthTextField(
                          controller: _emailController,
                          label: 'Official Email',
                          hintText: 'agent@forenshield.com',
                          focusNode: _emailFocus,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validator: FormValidators.email,
                          onFieldSubmitted: (_) =>
                              FocusScope.of(context).requestFocus(_passwordFocus),
                          prefixIcon: const Icon(Icons.email_outlined),
                        ).animate().fadeIn(duration: 400.ms, delay: 180.ms).slideY(begin: 0.08, end: 0),
                        const SizedBox(height: AppSpacing.md),

                        // Password
                        AuthTextField(
                          controller: _passwordController,
                          label: 'Access Password',
                          hintText: '••••••••',
                          focusNode: _passwordFocus,
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.next,
                          validator: FormValidators.password,
                          onFieldSubmitted: (_) => FocusScope.of(context)
                              .requestFocus(_confirmPasswordFocus),
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                            onPressed: () {
                              setState(
                                  () => _obscurePassword = !_obscurePassword);
                            },
                          ),
                        ).animate().fadeIn(duration: 400.ms, delay: 220.ms).slideY(begin: 0.08, end: 0),
                        const SizedBox(height: 6),

                        // Password Strength Bar
                        if (_passwordController.text.isNotEmpty) ...[
                          Row(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: AppRadius.borderRadiusXs,
                                  child: LinearProgressIndicator(
                                    value: pwdStrength,
                                    minHeight: 4,
                                    backgroundColor: foren.surfaceRaised1,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      pwdStrength > 0.7
                                          ? foren.success.t500
                                          : (pwdStrength > 0.4
                                              ? foren.warning.t500
                                              : foren.critical.t500),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                pwdStrength > 0.7
                                    ? 'STRONG'
                                    : (pwdStrength > 0.4 ? 'MEDIUM' : 'WEAK'),
                                style: TextStyle(
                                  color: pwdStrength > 0.7
                                      ? foren.success.t500
                                      : (pwdStrength > 0.4
                                          ? foren.warning.t500
                                          : foren.critical.t500),
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ],
                          ).animate().fadeIn(duration: 200.ms),
                        ],
                        const SizedBox(height: AppSpacing.md),

                        // Confirm Password
                        AuthTextField(
                          controller: _confirmPasswordController,
                          label: 'Confirm Password',
                          hintText: '••••••••',
                          focusNode: _confirmPasswordFocus,
                          obscureText: _obscureConfirmPassword,
                          textInputAction: TextInputAction.done,
                          validator: (value) => FormValidators.confirmPassword(
                            value,
                            _passwordController.text,
                          ),
                          onFieldSubmitted: (_) => _handleRegister(),
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                            onPressed: () {
                              setState(() => _obscureConfirmPassword =
                                  !_obscureConfirmPassword);
                            },
                          ),
                        ).animate().fadeIn(duration: 400.ms, delay: 260.ms).slideY(begin: 0.08, end: 0),
                        const SizedBox(height: AppSpacing.lg),

                        // Register button
                        AuthButton(
                          label: 'ENLIST & INITIALIZE',
                          isLoading: _isLoading,
                          onPressed: _isLoading ? null : _handleRegister,
                        ).animate().fadeIn(duration: 400.ms, delay: 300.ms).slideY(begin: 0.08, end: 0),
                        const SizedBox(height: AppSpacing.lg),

                        // Already have an account
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already registered?',
                              style: TextStyle(
                                color: foren.textDisabled,
                                fontSize: 13,
                              ),
                            ),
                            TextButton(
                              onPressed: () => context.pop(),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.xs,
                                ),
                              ),
                              child: Text(
                                'Sign In',
                                style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ).animate().fadeIn(duration: 400.ms, delay: 340.ms),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
