import '../../../../core/utils/result.dart';
import '../entities/cisa_kev_entity.dart';

/// Contract interface for the CISA KEV repository.
abstract class CisaKevRepository {
  /// Fetches the latest CISA Known Exploited Vulnerabilities feed.
  ///
  /// Returns a [Result] containing the list of [CisaKevEntry] objects on
  /// success, or an [AppException] on failure (network, timeout, parse error).
  Future<Result<List<CisaKevEntry>>> getKevFeed();
}
