import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/effects/glass_effect.dart';
import '../../../core/effects/particle_background.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/foren_theme.dart';
import '../../../core/validators/form_validators.dart';
import '../../../routes/route_constants.dart';
import '../presentation/widgets/auth_button.dart';
import '../presentation/widgets/auth_logo.dart';
import '../presentation/widgets/auth_text_field.dart';
import '../providers/auth_state_provider.dart';

/// Production-grade cybersecurity login screen for ForenShield.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await ref.read(authStateProvider.notifier).login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    result.when(
      success: (_) {
        // AuthGuard will automatically redirect to Mission Control
      },
      failure: (exception) {
        setState(() {
          _errorMessage = exception.toString();
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
                        // 1. Logo Block
                        const AuthLogo().animate().fadeIn(duration: 400.ms, delay: 50.ms).slideY(begin: -0.1, end: 0, curve: Curves.easeOutCubic),
                        const SizedBox(height: AppSpacing.xl),

                        // 2. Welcome Headline & Subtitle
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'WELCOME BACK, AGENT',
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
                                'Authenticate credentials to access Mission Control',
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

                        // 3. Email Field
                        AuthTextField(
                          controller: _emailController,
                          label: 'Email Address',
                          hintText: 'agent@forenshield.com',
                          focusNode: _emailFocus,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validator: FormValidators.email,
                          onFieldSubmitted: (_) =>
                              FocusScope.of(context).requestFocus(_passwordFocus),
                          prefixIcon: const Icon(Icons.email_outlined),
                        ).animate().fadeIn(duration: 400.ms, delay: 150.ms).slideY(begin: 0.08, end: 0),
                        const SizedBox(height: AppSpacing.md),

                        // 4. Password Field
                        AuthTextField(
                          controller: _passwordController,
                          label: 'Security Access Password',
                          hintText: '••••••••',
                          focusNode: _passwordFocus,
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.done,
                          validator: FormValidators.password,
                          onFieldSubmitted: (_) => _handleLogin(),
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
                        ).animate().fadeIn(duration: 400.ms, delay: 200.ms).slideY(begin: 0.08, end: 0),

                        // Forgot password link
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              context.push(RouteConstants.forgotPassword);
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                vertical: AppSpacing.xs,
                              ),
                            ),
                            child: Text(
                              'Reset Access Credentials?',
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ).animate().fadeIn(duration: 400.ms, delay: 230.ms),
                        const SizedBox(height: AppSpacing.xs),

                        // 5. Login Button
                        AuthButton(
                          label: 'AUTHENTICATE & ENTER',
                          isLoading: _isLoading,
                          onPressed: _isLoading ? null : _handleLogin,
                        ).animate().fadeIn(duration: 400.ms, delay: 260.ms).slideY(begin: 0.08, end: 0),
                        const SizedBox(height: AppSpacing.lg),

                        // Divider
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 1,
                                color: foren.borderSubtle.withValues(alpha: 0.5),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.sm),
                              child: Text(
                                'OR',
                                style: TextStyle(
                                  color: foren.textDisabled,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 1,
                                color: foren.borderSubtle.withValues(alpha: 0.5),
                              ),
                            ),
                          ],
                        ).animate().fadeIn(duration: 400.ms, delay: 290.ms),
                        const SizedBox(height: AppSpacing.lg),

                        // 6. Register Button
                        AuthButton(
                          label: 'CREATE AGENT ACCOUNT',
                          isOutlined: true,
                          onPressed: () {
                            context.push(RouteConstants.register);
                          },
                        ).animate().fadeIn(duration: 400.ms, delay: 320.ms).slideY(begin: 0.08, end: 0),
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
