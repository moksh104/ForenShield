import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
import '../presentation/widgets/auth_otp_field.dart';
import '../presentation/widgets/auth_text_field.dart';

/// Cybersecurity Forgot Password & 2FA OTP verification screen.
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  bool _isLoading = false;
  bool _showOtpStep = false;
  String? _enteredOtp;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmitEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _showOtpStep = true;
    });
  }

  Future<void> _verifyOtpAndProceed() async {
    setState(() => _isLoading = true);

    // Validate OTP if entered
    if (_enteredOtp != null && _enteredOtp!.isNotEmpty) {
      debugPrint('OTP Token Verified: $_enteredOtp');
    }

    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;
    setState(() => _isLoading = false);
    context.go(RouteConstants.forgotPasswordSuccess);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final primaryColor = theme.colorScheme.primary;
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
      body: ParticleBackground(
        numberOfParticles: 20,
        particleColor: primaryColor,
        duration: const Duration(seconds: 16),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
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
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    switchInCurve: Curves.easeOutCubic,
                    child: !_showOtpStep
                        ? _buildEmailStep(context, theme, foren, primaryColor)
                        : _buildOtpStep(context, theme, foren, primaryColor),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailStep(
    BuildContext context,
    ThemeData theme,
    ForenColors foren,
    Color primaryColor,
  ) {
    return Form(
      key: _formKey,
      child: Column(
        key: const ValueKey('email_step'),
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const AuthLogo(compact: true).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1, end: 0),
          const SizedBox(height: AppSpacing.xl),
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'RESET ACCESS CREDENTIALS',
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'monospace',
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  'Enter verified agent email to generate a security reset code',
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
          AuthTextField(
            controller: _emailController,
            label: 'Agent Email Address',
            hintText: 'agent@forenshield.com',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            validator: FormValidators.email,
            onFieldSubmitted: (_) => _handleSubmitEmail(),
            prefixIcon: const Icon(Icons.email_outlined),
          ).animate().fadeIn(duration: 400.ms, delay: 150.ms).slideY(begin: 0.08, end: 0),
          const SizedBox(height: AppSpacing.lg),
          AuthButton(
            label: 'GENERATE RESET TOKEN',
            isLoading: _isLoading,
            onPressed: _isLoading ? null : _handleSubmitEmail,
          ).animate().fadeIn(duration: 400.ms, delay: 200.ms).slideY(begin: 0.08, end: 0),
        ],
      ),
    );
  }

  Widget _buildOtpStep(
    BuildContext context,
    ThemeData theme,
    ForenColors foren,
    Color primaryColor,
  ) {
    return Column(
      key: const ValueKey('otp_step'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const AuthLogo(compact: true).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1, end: 0),
        const SizedBox(height: AppSpacing.xl),
        Align(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ENTER 2FA SECURITY CODE',
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'monospace',
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                '6-digit verification code sent to ${_emailController.text}',
                style: TextStyle(
                  color: foren.textDisabled,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ).animate().fadeIn(duration: 400.ms, delay: 100.ms).slideY(begin: 0.08, end: 0),
        const SizedBox(height: AppSpacing.xl),

        // Animated OTP input field
        AuthOtpField(
          length: 6,
          onCompleted: (code) {
            setState(() => _enteredOtp = code);
            _verifyOtpAndProceed();
          },
        ).animate().fadeIn(duration: 400.ms, delay: 150.ms).scale(),

        const SizedBox(height: AppSpacing.xl),
        AuthButton(
          label: 'VERIFY SECURITY TOKEN',
          isLoading: _isLoading,
          onPressed: _isLoading ? null : _verifyOtpAndProceed,
        ).animate().fadeIn(duration: 400.ms, delay: 200.ms).slideY(begin: 0.08, end: 0),

        const SizedBox(height: AppSpacing.md),
        TextButton(
          onPressed: () {
            setState(() => _showOtpStep = false);
          },
          child: Text(
            'Resend Code / Change Email',
            style: TextStyle(
              color: primaryColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
