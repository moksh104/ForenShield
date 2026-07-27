import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/foren_theme.dart';
import '../../../routes/route_constants.dart';
import '../presentation/widgets/auth_button.dart';

/// Dedicated success confirmation screen for Password Reset.
class ForgotPasswordSuccessScreen extends StatelessWidget {
  const ForgotPasswordSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final successColor = foren.success.t500;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Success Icon Container
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: successColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: successColor.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Icon(
                      Icons.mark_email_read_outlined,
                      color: successColor,
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // Title
                  Text(
                    'Password Reset Email Sent',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Description
                  Text(
                    'If an account exists for this email, a password reset link has been sent.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: foren.textDisabled,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),

                  // Primary Button
                  AuthButton(
                    label: 'Back to Login',
                    onPressed: () {
                      context.go(RouteConstants.login);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
