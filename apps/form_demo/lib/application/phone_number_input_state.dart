import 'package:formz/formz.dart';
import 'package:phone_number_form_field/phone_number_form_field.dart';

/// Validation errors that can occur on a phone number input.
enum PhoneNumberInputStateError() {
  /// The phone number is required but was not provided.
  required,

  /// The phone number was provided but is invalid or incomplete.
  invalid,
}

/// Formz input representing the state and validation of an international phone number.
class PhoneNumberInputState extends FormzInput<PhoneNumberState, PhoneNumberInputStateError> {
  /// Creates an untouched [PhoneNumberInputState] with an empty phone number state.
  const PhoneNumberInputState.pure() : super.pure(const PhoneNumberState.empty());

  /// Creates a dirty [PhoneNumberInputState] with the given [value].
  const PhoneNumberInputState.dirty([super.value = const PhoneNumberState.empty()]) : super.dirty();

  @override
  PhoneNumberInputStateError? validator(PhoneNumberState value) {
    if (value.isEmpty) return PhoneNumberInputStateError.required;
    if (!value.isValid) return PhoneNumberInputStateError.invalid;
    return null;
  }
}
