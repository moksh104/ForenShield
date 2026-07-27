/// Represents the application's theme rendering mode.
enum AppThemeMode {
  system,
  light,
  dark;

  /// Returns true if the user explicitly requested a dark theme or
  /// if the system is driving a dark mode (requires context to resolve system).
  bool isDark(bool systemIsDark) {
    if (this == AppThemeMode.dark) return true;
    if (this == AppThemeMode.system && systemIsDark) return true;
    return false;
  }
}
