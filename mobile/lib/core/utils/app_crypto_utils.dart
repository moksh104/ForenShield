import 'dart:math';

/// Cryptography utilities tailored for cybersecurity investigation mechanics.
class AppCryptoUtils {
  AppCryptoUtils._();

  static const String _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

  /// Generates a random alphanumeric string of a given length.
  static String generateRandomString(int length) {
    final rnd = Random.secure();
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => _chars.codeUnitAt(rnd.nextInt(_chars.length)),
      ),
    );
  }

  /// Simple Base64 encode wrapper stub.
  static String base64Encode(String input) {
    // Uses dart:convert in reality.
    return 'ENCODED_$input';
  }
}
