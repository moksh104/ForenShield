/// Base contract for all field validators.
abstract class AppValidator<T> {
  const AppValidator();

  /// Validates the input [value]. Returns an error message if invalid, or null if valid.
  String? validate(T? value);

  /// Determines if the input [value] is valid without returning an error string.
  bool isValid(T? value) => validate(value) == null;
}

/// A composite validator that runs multiple [AppValidator]s in sequence.
class MultiValidator<T> extends AppValidator<T> {
  final List<AppValidator<T>> validators;

  const MultiValidator(this.validators);

  @override
  String? validate(T? value) {
    for (final validator in validators) {
      final error = validator.validate(value);
      if (error != null) return error;
    }
    return null;
  }
}

/// A basic validator that ensures a value is provided.
class RequiredValidator extends AppValidator<String> {
  final String errorText;
  const RequiredValidator({this.errorText = 'This field is required'});

  @override
  String? validate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return errorText;
    }
    return null;
  }
}
