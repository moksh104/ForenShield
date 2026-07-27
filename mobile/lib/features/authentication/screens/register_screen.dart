import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/foren_theme.dart';
import '../../../core/validators/form_validators.dart';
import '../presentation/widgets/auth_button.dart';
import '../presentation/widgets/auth_logo.dart';
import '../presentation/widgets/auth_text_field.dart';
import '../providers/auth_state_provider.dart';

/// Production-grade registration screen for ForenShield.
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

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

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
              AppSpacing.xl,
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
                    const AuthLogo(compact: true),
                    const SizedBox(height: AppSpacing.xl),

                    // Title
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Create Account',
                            style: TextStyle(
                              color: theme.colorScheme.onSurface,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xxs),
                          Text(
                            'Join the cyber defense force',
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

                    // Name
                    AuthTextField(
                      controller: _nameController,
                      label: 'Full Name',
                      hintText: 'Agent Name',
                      focusNode: _nameFocus,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      validator: FormValidators.username,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_emailFocus),
                      prefixIcon: Icon(
                        Icons.person_outline,
                        color: foren.textDisabled,
                        size: 20,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

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
                      textInputAction: TextInputAction.next,
                      validator: FormValidators.password,
                      onFieldSubmitted: (_) => FocusScope.of(context)
                          .requestFocus(_confirmPasswordFocus),
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
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: foren.textDisabled,
                        size: 20,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: foren.textDisabled,
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() => _obscureConfirmPassword =
                              !_obscureConfirmPassword);
                        },
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Register button
                    AuthButton(
                      label: 'Create Account',
                      isLoading: _isLoading,
                      onPressed: _isLoading ? null : _handleRegister,
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Already have an account
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account?',
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
                              color: theme.colorScheme.primary,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
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
