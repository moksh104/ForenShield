import 'app_validator.dart';
import '../constants/validation_constants.dart';

/// Validates phone numbers.
class PhoneValidator extends AppValidator<String> {
  const PhoneValidator();

  @override
  String? validate(String? value) {
    if (value == null || value.isEmpty) return null;

    final cleanPhone = value.replaceAll(RegExp(r'[^\d+]'), '');

    if (cleanPhone.length < ValidationConstants.minPhoneLength ||
        cleanPhone.length > ValidationConstants.maxPhoneLength) {
      return 'Please enter a valid phone number';
    }

    return null;
  }
}
