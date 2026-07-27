import 'package:flutter/material.dart';

/// A mixin that simplifies Flutter Form state validation.
mixin FormValidationMixin<T extends StatefulWidget> on State<T> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// Returns true if all form fields pass validation.
  bool validateForm() {
    return formKey.currentState?.validate() ?? false;
  }

  /// Saves all form fields.
  void saveForm() {
    formKey.currentState?.save();
  }

  /// Resets all form fields to their initial states.
  void resetForm() {
    formKey.currentState?.reset();
  }
}
