library;

/// Re-export of the shared [UserModel] used by authentication.
///
/// This wrapper preserves an authentication-specific model namespace while
/// reusing the existing application-wide user model implementation.
export '../../../models/user_model.dart';
