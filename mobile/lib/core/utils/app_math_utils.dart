import 'dart:math' as math;

/// Mathematical utilities.
class AppMathUtils {
  AppMathUtils._();

  /// Maps a value from one range to another.
  static double mapRange(
    double value,
    double inMin,
    double inMax,
    double outMin,
    double outMax,
  ) {
    return outMin + ((outMax - outMin) / (inMax - inMin)) * (value - inMin);
  }

  /// Clamps a value strictly between min and max.
  static double clamp(double value, double minValue, double maxValue) {
    return math.max(minValue, math.min(maxValue, value));
  }
}
