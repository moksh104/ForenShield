/// Static utilities for data formatting.
class AppFormatter {
  AppFormatter._();

  /// Masks a string, keeping only the last [visibleChars] visible.
  static String maskString(
    String input, {
    int visibleChars = 4,
    String mask = '*',
  }) {
    if (input.length <= visibleChars) return input;
    final maskedPart = List.filled(input.length - visibleChars, mask).join();
    return '$maskedPart${input.substring(input.length - visibleChars)}';
  }
}
