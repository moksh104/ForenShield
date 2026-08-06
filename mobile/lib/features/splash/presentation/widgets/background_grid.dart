import 'package:flutter/material.dart';

/// Dot-matrix World Map background representation for the ForenShield splash screen.
class WorldMapWidget extends StatelessWidget {
  final Color color;

  const WorldMapWidget({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 120),
      painter: _WorldMapPainter(color: color),
    );
  }
}

class _WorldMapPainter extends CustomPainter {
  final Color color;

  _WorldMapPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final width = size.width;
    final height = size.height;

    const points = [
      // North America
      Offset(0.18, 0.25),
      Offset(0.22, 0.20),
      Offset(0.25, 0.22),
      Offset(0.20, 0.30),
      Offset(0.15, 0.35),
      Offset(0.24, 0.32),
      Offset(0.28, 0.35),
      Offset(0.22, 0.40),
      Offset(0.26, 0.42),
      Offset(0.30, 0.38),
      Offset(0.18, 0.45),
      Offset(0.25, 0.50),

      // South America
      Offset(0.30, 0.60),
      Offset(0.32, 0.65),
      Offset(0.35, 0.70),
      Offset(0.33, 0.75),
      Offset(0.31, 0.80), Offset(0.29, 0.85), Offset(0.34, 0.78),

      // Europe
      Offset(0.48, 0.22),
      Offset(0.52, 0.20),
      Offset(0.55, 0.25),
      Offset(0.50, 0.28),
      Offset(0.53, 0.30), Offset(0.56, 0.32), Offset(0.49, 0.35),

      // Africa
      Offset(0.50, 0.45),
      Offset(0.53, 0.48),
      Offset(0.56, 0.52),
      Offset(0.52, 0.58),
      Offset(0.55, 0.62),
      Offset(0.58, 0.68),
      Offset(0.54, 0.72),
      Offset(0.51, 0.65),

      // Asia
      Offset(0.62, 0.22),
      Offset(0.66, 0.20),
      Offset(0.70, 0.18),
      Offset(0.74, 0.22),
      Offset(0.65, 0.28),
      Offset(0.69, 0.30),
      Offset(0.73, 0.28),
      Offset(0.78, 0.25),
      Offset(0.63, 0.35),
      Offset(0.68, 0.38),
      Offset(0.72, 0.35),
      Offset(0.76, 0.38),
      Offset(0.80, 0.32),
      Offset(0.84, 0.30),
      Offset(0.75, 0.45),
      Offset(0.78, 0.48),
      Offset(0.82, 0.42),
      Offset(0.85, 0.46),
      Offset(0.71, 0.50),
      Offset(0.74, 0.54),

      // Australia / Oceania
      Offset(0.82, 0.72),
      Offset(0.85, 0.70),
      Offset(0.88, 0.74),
      Offset(0.84, 0.78),
      Offset(0.87, 0.80),
    ];

    for (final p in points) {
      final dx = p.dx * width;
      final dy = p.dy * height;
      canvas.drawCircle(Offset(dx, dy), 1.8, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _WorldMapPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

/// Vector City Skyline & Suspension Bridge outline artwork matching splash spec.
class CitySkylineWidget extends StatelessWidget {
  final Color color;

  const CitySkylineWidget({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 140),
      painter: _CitySkylinePainter(color: color),
    );
  }
}

class _CitySkylinePainter extends CustomPainter {
  final Color color;

  _CitySkylinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final width = size.width;
    final height = size.height;

    final path = Path();

    // Baseline across the bottom
    path.moveTo(0, height);

    // Suspension Bridge (left side 0.0 .. 0.3)
    path.lineTo(0, height - 15);
    path.lineTo(width * 0.04, height - 15);
    path.lineTo(width * 0.08, height - 55); // Tower 1
    path.lineTo(width * 0.08, height - 15);
    path.moveTo(width * 0.08, height - 55);
    path.lineTo(width * 0.18, height - 55); // Tower 2
    path.lineTo(width * 0.18, height - 15);
    path.lineTo(width * 0.28, height - 15);

    // Bridge Cable arcs
    final cablePath = Path();
    cablePath.moveTo(0, height - 35);
    cablePath.quadraticBezierTo(
      width * 0.04,
      height - 15,
      width * 0.08,
      height - 55,
    );
    cablePath.quadraticBezierTo(
      width * 0.13,
      height - 25,
      width * 0.18,
      height - 55,
    );
    cablePath.quadraticBezierTo(
      width * 0.23,
      height - 15,
      width * 0.28,
      height - 35,
    );
    canvas.drawPath(cablePath, paint);

    // City Skyline Buildings (center and right 0.3 .. 1.0)
    final bPath = Path();
    bPath.moveTo(width * 0.30, height - 15);
    bPath.lineTo(width * 0.30, height - 70);
    bPath.lineTo(width * 0.35, height - 70);
    bPath.lineTo(width * 0.35, height - 110); // Tall Spire 1
    bPath.lineTo(width * 0.36, height - 110);
    bPath.lineTo(width * 0.36, height - 60);
    bPath.lineTo(width * 0.40, height - 60);
    bPath.lineTo(width * 0.40, height - 85);
    bPath.lineTo(width * 0.45, height - 85);
    bPath.lineTo(width * 0.45, height - 45);

    // Center skyscraper group
    bPath.lineTo(width * 0.48, height - 45);
    bPath.lineTo(width * 0.48, height - 100);
    bPath.lineTo(width * 0.52, height - 100);
    bPath.lineTo(width * 0.52, height - 125); // Main Tower Spire
    bPath.lineTo(width * 0.53, height - 125);
    bPath.lineTo(width * 0.53, height - 80);
    bPath.lineTo(width * 0.58, height - 80);
    bPath.lineTo(width * 0.58, height - 115);
    bPath.lineTo(width * 0.63, height - 115);
    bPath.lineTo(width * 0.63, height - 55);

    // Right buildings group
    bPath.lineTo(width * 0.68, height - 55);
    bPath.lineTo(width * 0.68, height - 90);
    bPath.lineTo(width * 0.74, height - 90);
    bPath.lineTo(width * 0.74, height - 130); // Spire Right
    bPath.lineTo(width * 0.75, height - 130);
    bPath.lineTo(width * 0.75, height - 75);
    bPath.lineTo(width * 0.82, height - 75);
    bPath.lineTo(width * 0.82, height - 105);
    bPath.lineTo(width * 0.88, height - 105);
    bPath.lineTo(width * 0.88, height - 40);
    bPath.lineTo(width * 0.95, height - 40);
    bPath.lineTo(width * 0.95, height - 70);
    bPath.lineTo(width, height - 70);
    bPath.lineTo(width, height);

    canvas.drawPath(path, paint);
    canvas.drawPath(bPath, paint);
  }

  @override
  bool shouldRepaint(covariant _CitySkylinePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
