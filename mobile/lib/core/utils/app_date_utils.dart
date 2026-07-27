/// Low-level date utilities.
class AppDateUtils {
  AppDateUtils._();

  /// Safely parses an ISO8601 string to DateTime, returning null if invalid.
  static DateTime? tryParseIso(String? isoString) {
    if (isoString == null) return null;
    return DateTime.tryParse(isoString);
  }

  /// Checks if [target] is between [start] and [end].
  static bool isBetween(DateTime target, DateTime start, DateTime end) {
    return target.isAfter(start) && target.isBefore(end);
  }
}
