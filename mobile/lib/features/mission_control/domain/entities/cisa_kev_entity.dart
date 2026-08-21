import 'package:equatable/equatable.dart';

/// Entity representing a single entry from the CISA Known Exploited
/// Vulnerabilities (KEV) catalog.
class CisaKevEntry extends Equatable {
  /// CVE identifier, e.g. "CVE-2024-1234".
  final String cveId;

  /// Name of the vendor / project affected.
  final String vendor;

  /// Name of the specific product affected.
  final String product;

  /// Human-readable name of the vulnerability.
  final String vulnerabilityName;

  /// Severity string as reported by CISA (e.g. "CRITICAL", "HIGH", "N/A").
  final String severity;

  /// ISO-8601 date string when the CVE was added to the KEV catalog.
  final String dateAdded;

  /// Required remediation action text from CISA.
  final String requiredAction;

  /// CISA-mandated remediation due date (ISO-8601).
  final String dueDate;

  /// Whether this CVE is associated with known ransomware campaigns.
  final String knownRansomware;

  const CisaKevEntry({
    required this.cveId,
    required this.vendor,
    required this.product,
    required this.vulnerabilityName,
    required this.severity,
    required this.dateAdded,
    required this.requiredAction,
    required this.dueDate,
    required this.knownRansomware,
  });

  @override
  List<Object?> get props => [
    cveId,
    vendor,
    product,
    vulnerabilityName,
    severity,
    dateAdded,
    requiredAction,
    dueDate,
    knownRansomware,
  ];
}
