import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/foren_theme.dart';
import '../../../core/validators/form_validators.dart';
import '../../../routes/route_constants.dart';
import '../presentation/widgets/auth_button.dart';
import '../presentation/widgets/auth_logo.dart';
import '../presentation/widgets/auth_text_field.dart';
import '../providers/auth_state_provider.dart';

/// Production-grade login screen for ForenShield.
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

    setState(() => _isLoading = true);

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
        final foren = Theme.of(context).extension<ForenColors>()!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(exception.toString()),
            backgroundColor: foren.critical.t500,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.all(AppSpacing.md),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.xxl,
              AppSpacing.lg,
              AppSpacing.lg + bottomInset,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    const AuthLogo(),
                    const SizedBox(height: AppSpacing.xxl),

                    // Welcome text
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome Back',
                            style: TextStyle(
                              color: theme.colorScheme.onSurface,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xxs),
                          Text(
                            'Sign in to continue your mission',
                            style: TextStyle(
                              color: foren.textDisabled,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Email
                    AuthTextField(
                      controller: _emailController,
                      label: 'Email',
                      hintText: 'agent@forenshield.com',
                      focusNode: _emailFocus,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: FormValidators.email,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_passwordFocus),
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: foren.textDisabled,
                        size: 20,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Password
                    AuthTextField(
                      controller: _passwordController,
                      label: 'Password',
                      hintText: '••••••••',
                      focusNode: _passwordFocus,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.done,
                      validator: FormValidators.password,
                      onFieldSubmitted: (_) => _handleLogin(),
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: foren.textDisabled,
                        size: 20,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: foren.textDisabled,
                          size: 20,
                        ),
                        onPressed: () {
                          setState(
                              () => _obscurePassword = !_obscurePassword);
                        },
                      ),
                    ),

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
                          'Forgot Password?',
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),

                    // Login button
                    AuthButton(
                      label: 'Sign In',
                      isLoading: _isLoading,
                      onPressed: _isLoading ? null : _handleLogin,
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Divider
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 1,
                            color: foren.borderSubtle,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm),
                          child: Text(
                            'or',
                            style: TextStyle(
                              color: foren.textDisabled,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 1,
                            color: foren.borderSubtle,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Create Account
                    AuthButton(
                      label: 'Create Account',
                      isOutlined: true,
                      onPressed: () {
                        context.push(RouteConstants.register);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
