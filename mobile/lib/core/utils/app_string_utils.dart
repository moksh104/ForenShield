/// Low-level string utilities.
class AppStringUtils {
  AppStringUtils._();

  /// Checks if a string contains another string, case-insensitive.
  static bool containsIgnoreCase(String source, String query) {
    return source.toLowerCase().contains(query.toLowerCase());
  }

  /// Removes all whitespace from a string.
  static String removeWhitespace(String input) {
    return input.replaceAll(RegExp(r'\s+'), '');
  }
}
