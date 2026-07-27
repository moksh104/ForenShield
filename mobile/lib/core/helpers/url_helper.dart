/// High-level URL manipulation.
class UrlHelper {
  UrlHelper._();

  /// Extracts the domain from a given URL string.
  static String? extractDomain(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.host;
    } catch (_) {
      return null;
    }
  }

  /// Appends query parameters to a base URL safely.
  static String buildUrl(String baseUrl, Map<String, dynamic> queryParams) {
    try {
      final uri = Uri.parse(baseUrl);
      final newUri = uri.replace(
        queryParameters: {
          ...uri.queryParameters,
          ...queryParams.map((k, v) => MapEntry(k, v.toString())),
        },
      );
      return newUri.toString();
    } catch (_) {
      return baseUrl;
    }
  }
}
