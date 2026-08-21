# Testing & QA Checklist

## 1. Unit Tests
- [x] Run `flutter test` to ensure all logic and provider tests pass.
- [x] Verify API client mocking and error handling.

## 2. Widget Tests
- [x] Run `test/widget_test.dart` for initial navigation state.
- [x] Run `test/features/settings/settings_flow_test.dart` for complex state mutation.

## 3. UI/UX Audit
- [x] Dark Mode validation on all core modules (Mission Control, Labs, Academy).
- [x] Light Mode validation on all core modules.
- [x] Ensure contrast ratios on typography against primary backgrounds.

## 4. Security Audit
- [x] All backend endpoints properly validate the JWT Authorization header.
- [x] All SQL queries use PDO Prepared Statements.
- [x] Database configuration failures return JSON (`config.php`).
- [x] File uploads restrict MIME type, extension, and enforce size limits (`upload_image.php`).

## 5. Performance Check
- [x] `flutter analyze` reports zero critical issues.
- [x] Verify Riverpod `autoDispose` where appropriate.

## 6. Build Validation
- [x] Generate release APK: `flutter build apk --release`.
- [x] Confirm no obfuscation errors or missing assets in the release build.
