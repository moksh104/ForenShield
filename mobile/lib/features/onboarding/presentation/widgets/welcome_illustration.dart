import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Clean vector illustration matching the official Welcome to ForenShield spec:
/// Laptop displaying fingerprint grid scanner, flanked by magnifying glass and blue shield lock.
class WelcomeIllustration extends StatelessWidget {
  final bool animate;

  const WelcomeIllustration({super.key, this.animate = true});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = AppColors.primary;

    return Center(
      child: SizedBox(
        width: 320,
        height: 180,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // Background Circuit Board Lines Custom Painter
            CustomPaint(
              size: const Size(320, 180),
              painter: _CircuitBackgroundPainter(
                color: primaryColor.withValues(alpha: isDark ? 0.08 : 0.12),
              ),
            ),

            // Laptop Base & Display
            Positioned(
              top: 20,
              child: Column(
                children: [
                  // Laptop Screen Frame
                  Container(
                    width: 170,
                    height: 110,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surface : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isDark
                            ? AppColors.borderDefault
                            : const Color(0xFF1E293B),
                        width: 3.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withValues(alpha: 0.12),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      // Fingerprint scanner display inside laptop screen
                      child: Container(
                        width: 130,
                        height: 80,
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: primaryColor.withValues(alpha: 0.2),
                            width: 1.0,
                          ),
                        ),
                        child: Center(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Scanner Corner Brackets
                              Icon(
                                Icons.crop_free_rounded,
                                size: 54,
                                color: primaryColor.withValues(alpha: 0.35),
                              ),
                              // Fingerprint Icon
                              Icon(
                                Icons.fingerprint_rounded,
                                size: 36,
                                color: primaryColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Laptop Keyboard Base
                  Container(
                    width: 200,
                    height: 10,
                    decoration: BoxDecoration(
                      color: const Color(0xFFCBD5E1),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Left: Magnifying Glass Icon Widget
            Positioned(
              left: 30,
              top: 50,
              child: Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark ? AppColors.surface : Colors.white,
                  border: Border.all(
                    color: primaryColor.withValues(alpha: 0.3),
                    width: 2.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withValues(alpha: 0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.search_rounded,
                    size: 28,
                    color: primaryColor,
                  ),
                ),
              ),
            ),

            // Right: Shield Lock Emblem Widget
            Positioned(
              right: 35,
              top: 55,
              child: Container(
                width: 50,
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    colors: [primaryColor, const Color(0xFF1D4ED8)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.lock_rounded,
                    size: 24,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircuitBackgroundPainter extends CustomPainter {
  final Color color;

  _CircuitBackgroundPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final width = size.width;
    final height = size.height;

    // Subtle background circuit traces
    final path = Path();
    path.moveTo(10, height * 0.3);
    path.lineTo(60, height * 0.3);
    path.lineTo(80, height * 0.5);
    path.lineTo(100, height * 0.5);

    path.moveTo(width - 10, height * 0.3);
    path.lineTo(width - 60, height * 0.3);
    path.lineTo(width - 80, height * 0.5);
    path.lineTo(width - 100, height * 0.5);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _CircuitBackgroundPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
