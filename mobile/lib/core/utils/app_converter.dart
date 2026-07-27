/// Conversion utilities for generic transformations.
class AppConverter {
  AppConverter._();

  /// Converts a hex color string (e.g. #FF0000) to an integer for Color().
  static int hexToInt(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    return int.tryParse(hex, radix: 16) ?? 0xFF000000;
  }

  /// Converts degrees to radians.
  static double degreesToRadians(double degrees) {
    return degrees * (3.1415926535897932 / 180.0);
  }
}
