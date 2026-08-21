import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/effects/glass_effect.dart';
import '../../../core/effects/particle_background.dart';
import '../../../core/exceptions/app_exceptions.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/foren_theme.dart';
import '../../../routes/route_constants.dart';
import '../presentation/widgets/auth_button.dart';
import '../presentation/widgets/auth_logo.dart';
import '../presentation/widgets/auth_otp_field.dart';
import '../providers/auth_state_provider.dart';

/// One-time password verification screen for ForenShield.
///
/// Fully connected to `POST /verify_otp.php` backend endpoint.
class OtpScreen extends ConsumerStatefulWidget {
  final String? email;

  const OtpScreen({super.key, this.email});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  bool _isLoading = false;
  String? _otpCode;
  String? _errorMessage;

  late Timer _resendTimer;
  int _secondsRemaining = 47;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    _resendTimer.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    setState(() {
      _secondsRemaining = 47;
      _canResend = false;
    });
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        _resendTimer.cancel();
        setState(() => _canResend = true);
      }
    });
  }

  String get _formattedTimer {
    final minutes = (_secondsRemaining ~/ 60).toString().padLeft(2, '0');
    final seconds = (_secondsRemaining % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  String get _targetEmail {
    if (widget.email != null && widget.email!.isNotEmpty) {
      return widget.email!;
    }
    return 'samlee.mobbin@gmail.com';
  }

  Future<void> _verifyOtpCode(String code) async {
    if (code.length < 6) {
      setState(() {
        _errorMessage = 'Enter the complete 6-digit verification code.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _otpCode = code;
    });

    final result = await ref
        .read(authStateProvider.notifier)
        .verifyOtp(email: _targetEmail, otpCode: code);

    if (!mounted) return;
    setState(() => _isLoading = false);

    result.when(
      success: (_) {
        context.go(RouteConstants.missionControl);
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

  void _handleResend() {
    if (!_canResend) return;
    _startResendTimer();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('A new 6-digit verification code has been sent.'),
      ),
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          color: theme.colorScheme.onSurface,
          onPressed: () => context.pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.md),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.1),
                  borderRadius: AppRadius.borderRadiusCircular,
                  border: Border.all(
                    color: primaryColor.withValues(alpha: 0.25),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.verified_user_outlined,
                      size: 14,
                      color: primaryColor,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Secure Verification',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
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
                AppSpacing.xs,
                AppSpacing.lg,
                AppSpacing.lg + bottomInset,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  children: [
                    // Brand Logo
                    const AuthLogo(compact: true)
                        .animate()
                        .fadeIn(duration: 400.ms)
                        .slideY(begin: -0.1, end: 0),
                    const SizedBox(height: AppSpacing.lg),

                    // Header Text
                    Text(
                      'Verify your email',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: theme.colorScheme.onSurface,
                        letterSpacing: -0.5,
                      ),
                    ).animate().fadeIn(duration: 400.ms, delay: 50.ms),
                    const SizedBox(height: AppSpacing.xs),

                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          color: foren.textDisabled,
                          fontSize: 13,
                          height: 1.4,
                        ),
                        children: [
                          const TextSpan(
                            text: "We've sent a 6-digit code to\n",
                          ),
                          TextSpan(
                            text: _targetEmail,
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const TextSpan(
                            text: '\nEnter the code below to continue.',
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
                    const SizedBox(height: AppSpacing.lg),

                    // Center Security Graphic Illustration
                    _buildSecurityIllustration(
                      primaryColor,
                      foren,
                    ).animate().fadeIn(duration: 400.ms, delay: 150.ms).scale(),
                    const SizedBox(height: AppSpacing.xl),

                    // Error Banner if present
                    if (_errorMessage != null) ...[
                      Container(
                        margin: const EdgeInsets.only(bottom: AppSpacing.md),
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: foren.critical.t500.withValues(alpha: 0.15),
                          borderRadius: AppRadius.borderRadiusMd,
                          border: Border.all(
                            color: foren.critical.t500.withValues(alpha: 0.4),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.gpp_maybe_outlined,
                              color: foren.critical.t500,
                              size: 20,
                            ),
                            const SizedBox(width: AppSpacing.sm),
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
                      ).animate().shake(duration: 400.ms).fadeIn(),
                    ],

                    // 6-Digit OTP Field
                    AuthOtpField(
                      length: 6,
                      onCompleted: (code) => _verifyOtpCode(code),
                    ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
                    const SizedBox(height: AppSpacing.md),

                    // Helper Spam Text
                    Text(
                      "Didn't receive the code? Check your spam folder\nor resend the code.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: foren.textDisabled,
                        fontSize: 12,
                        height: 1.3,
                      ),
                    ).animate().fadeIn(duration: 400.ms, delay: 230.ms),
                    const SizedBox(height: AppSpacing.xl),

                    // Verification Button / Loading Indicator
                    if (_isLoading) ...[
                      const Padding(
                        padding: EdgeInsets.all(AppSpacing.md),
                        child: CircularProgressIndicator(),
                      ),
                    ] else ...[
                      AuthButton(
                        label: 'VERIFY CODE',
                        isLoading: _isLoading,
                        onPressed: () {
                          if (_otpCode != null) {
                            _verifyOtpCode(_otpCode!);
                          } else {
                            setState(() {
                              _errorMessage =
                                  'Enter the 6-digit verification code.';
                            });
                          }
                        },
                      ).animate().fadeIn(duration: 400.ms, delay: 250.ms),
                    ],
                    const SizedBox(height: AppSpacing.xl),

                    // Security Highlights Info Card
                    _buildSecurityInfoCard(
                      theme,
                      foren,
                      primaryColor,
                    ).animate().fadeIn(duration: 400.ms, delay: 280.ms),
                    const SizedBox(height: AppSpacing.xl),

                    // Resend Timer Row
                    InkWell(
                      onTap: _canResend ? _handleResend : null,
                      borderRadius: AppRadius.borderRadiusSm,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xs,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Transform.rotate(
                              angle: -0.4,
                              child: Icon(
                                Icons.near_me_outlined,
                                size: 18,
                                color: _canResend
                                    ? primaryColor
                                    : foren.textDisabled,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              _canResend
                                  ? 'Resend code now'
                                  : 'Resend code in $_formattedTimer',
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ).animate().fadeIn(duration: 400.ms, delay: 310.ms),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSecurityIllustration(Color primaryColor, ForenColors foren) {
    return Container(
      height: 140,
      width: double.infinity,
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.04),
        borderRadius: AppRadius.borderRadiusLg,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background grid accent lines
          Positioned(
            left: 20,
            top: 20,
            child: Text(
              '0 1 1 1 1 1 1 1\n1 1 1 1 0 1 1 1',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 10,
                color: primaryColor.withValues(alpha: 0.15),
              ),
            ),
          ),
          Positioned(
            right: 20,
            bottom: 20,
            child: Text(
              '1 1 0 0 0 1 1\n1 1 0 0 1 1 0',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 10,
                color: primaryColor.withValues(alpha: 0.15),
              ),
            ),
          ),

          // Envelope graphic
          Container(
            width: 170,
            height: 100,
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.12),
              borderRadius: AppRadius.borderRadiusMd,
              border: Border.all(color: primaryColor.withValues(alpha: 0.3)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: AppRadius.borderRadiusSm,
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.shield, size: 14, color: Colors.white),
                      SizedBox(width: AppSpacing.xs),
                      Text(
                        '*****',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Magnifying Glass (Left)
          Positioned(
            left: 36,
            bottom: 12,
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.3),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: const Icon(
                Icons.search_rounded,
                size: 24,
                color: Colors.white,
              ),
            ),
          ),

          // Lock (Right)
          Positioned(
            right: 36,
            bottom: 16,
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: AppRadius.borderRadiusSm,
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.3),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: const Icon(
                Icons.lock_outline_rounded,
                size: 22,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityInfoCard(
    ThemeData theme,
    ForenColors foren,
    Color primaryColor,
  ) {
    return GlassEffect(
      borderRadius: AppRadius.borderRadiusLg,
      border: Border.all(color: foren.borderSubtle.withValues(alpha: 0.3)),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        children: [
          _buildInfoRow(
            icon: Icons.verified_user_outlined,
            title: 'Your data is protected',
            subtitle:
                'We use industry-standard encryption to keep your data safe.',
            primaryColor: primaryColor,
            foren: foren,
            theme: theme,
          ),
          Divider(height: 24, color: foren.borderSubtle.withValues(alpha: 0.3)),
          _buildInfoRow(
            icon: Icons.desktop_windows_outlined,
            title: 'Built for cybersecurity learners',
            subtitle:
                'Practice real-world skills in a safe and guided environment.',
            primaryColor: primaryColor,
            foren: foren,
            theme: theme,
          ),
          Divider(height: 24, color: foren.borderSubtle.withValues(alpha: 0.3)),
          _buildInfoRow(
            icon: Icons.track_changes_outlined,
            title: 'Trusted by future defenders',
            subtitle:
                'Join thousands of learners building their cyber defense skills.',
            primaryColor: primaryColor,
            foren: foren,
            theme: theme,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color primaryColor,
    required ForenColors foren,
    required ThemeData theme,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: primaryColor.withValues(alpha: 0.1),
            borderRadius: AppRadius.borderRadiusMd,
          ),
          child: Icon(icon, size: 20, color: primaryColor),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  color: foren.textDisabled,
                  fontSize: 12,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
