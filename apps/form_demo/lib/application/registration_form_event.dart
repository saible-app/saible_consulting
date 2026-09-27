import 'package:date_picker_form_field/date_picker_form_field.dart';
import 'package:material_ui/material_ui.dart';
import 'package:phone_number_form_field/domain/phone_number.dart';
import 'package:saible_core/saible_core.dart';

/// Base class for events dispatched to registration form bloc.
sealed class const RegistrationFormEvent() {
  /// Const constructor for registration form events.
  this;
}

/// Event triggered when the user modifies the date of birth input.
final class const DateOfBirthChanged({
  required this.first,
  required this.last,
  required this.value,
}) extends RegistrationFormEvent {
  /// Creates a [DateOfBirthChanged] event.
  this;

  /// Resolves the earliest acceptable [DateTime] boundary.
  final ValueGetter<DateTime> first;

  /// Resolves the latest acceptable [DateTime] boundary.
  final ValueGetter<DateTime> last;

  /// The updated [DateInputValue].
  final DateInputValue value;
}

/// Event triggered when the user picks a nationality.
final class NationalityChanged({required this.value}) extends RegistrationFormEvent {
  /// Creates a [NationalityChanged] event.
  this;

  /// The selected [Iso3166Country].
  final Iso3166Country value;
}

/// Event triggered when the user modifies the phone number input.
final class PhoneNumberChanged({required this.value}) extends RegistrationFormEvent {
  /// Creates a [PhoneNumberChanged] event.
  this;

  /// The updated [PhoneNumberState].
  final PhoneNumberState value;
}
