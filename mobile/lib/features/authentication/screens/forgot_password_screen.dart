import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/foren_theme.dart';
import '../../../core/validators/form_validators.dart';
import '../presentation/widgets/auth_button.dart';
import '../presentation/widgets/auth_logo.dart';
import '../presentation/widgets/auth_text_field.dart';

import '../../../routes/route_constants.dart';

/// Forgot password screen for ForenShield.
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;
    setState(() => _isLoading = false);
    context.go(RouteConstants.forgotPasswordSuccess);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          color: foren.textSecondary,
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.lg,
              AppSpacing.lg + bottomInset,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: _FormState(
                formKey: _formKey,
                emailController: _emailController,
                isLoading: _isLoading,
                onSubmit: _handleSubmit,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FormState extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final bool isLoading;
  final VoidCallback onSubmit;

  const _FormState({
    required this.formKey,
    required this.emailController,
    required this.isLoading,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;

    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const AuthLogo(compact: true),
          const SizedBox(height: AppSpacing.xl),
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reset Password',
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  'Enter your email and we\'ll send you a reset link',
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
          AuthTextField(
            controller: emailController,
            label: 'Email',
            hintText: 'agent@forenshield.com',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            validator: FormValidators.email,
            onFieldSubmitted: (_) => onSubmit(),
            prefixIcon: Icon(
              Icons.email_outlined,
              color: foren.textDisabled,
              size: 20,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AuthButton(
            label: 'Send Reset Link',
            isLoading: isLoading,
            onPressed: isLoading ? null : onSubmit,
          ),
        ],
      ),
    );
  }
}
