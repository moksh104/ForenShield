import '../constants/regex_constants.dart';

/// Provides domain-specific validation for cybersecurity mechanics in ForenShield.
class CyberValidator {
  CyberValidator._();

  static String? validateInvestigationCode(String? value) {
    if (value == null || value.isEmpty) return 'Investigation code is required';

    if (!RegexConstants.investigationCode.hasMatch(value)) {
      return 'Invalid code format. Expected: FS-XXXX';
    }
    return null;
  }

  static String? validateEvidenceId(String? value) {
    if (value == null || value.isEmpty) return 'Evidence ID is required';
    if (value.length < 5) return 'Evidence ID is too short';
    return null;
  }

  static String? validateHash(String? value) {
    if (value == null || value.isEmpty) return 'Hash is required';

    // Simplistic check for MD5/SHA hashes: hex only.
    if (!RegExp(r'^[a-fA-F0-9]{32,128}$').hasMatch(value)) {
      return 'Invalid hash format (must be 32-128 hex chars)';
    }
    return null;
  }
}
