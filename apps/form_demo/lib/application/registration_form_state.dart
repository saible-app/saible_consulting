import 'package:form_demo/application/country_input_state.dart';
import 'package:form_demo/application/date_input_state.dart';
import 'package:form_demo/application/phone_number_input_state.dart';
import 'package:saible_core/saible_core.dart';

final _first = DateTime(1900);

DateTime _getFirst() => _first;
DateTime _getLast() => DateTime.now().dateOnly().addYears(-18);

/// Represents the composite state of the registration form.
final class const RegistrationFormState._({
  this.dateOfBirth = const DateInputState.pure(first: _getFirst, last: _getLast),
  this.nationality = const CountryInputState.pure(),
  this.phoneNumber = const PhoneNumberInputState.pure(),
}) {
  /// The validation and value state for date of birth.
  final DateInputState dateOfBirth;

  /// The validation and value state for nationality.
  final CountryInputState nationality;

  /// The validation and value state for phone number.
  final PhoneNumberInputState phoneNumber;

  /// Creates an initial [RegistrationFormState] with default pure inputs.
  const RegistrationFormState.initial() : this._();

  /// Whether the date of birth input is valid.
  bool get isDateOfBirthValid => dateOfBirth.isValid;

  /// Whether the nationality input is valid.
  bool get isNationalityValid => nationality.isValid;

  /// Whether the phone number input is valid.
  bool get isPhoneNumberValid => phoneNumber.isValid;

  /// Whether all registration form inputs are valid.
  bool get isValid => isDateOfBirthValid && isNationalityValid && isPhoneNumberValid;

  /// Returns a copy of this state with the given fields replaced.
  RegistrationFormState copyWith({
    DateInputState? dateOfBirth,
    CountryInputState? nationality,
    PhoneNumberInputState? phoneNumber,
  }) => RegistrationFormState._(
    dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    nationality: nationality ?? this.nationality,
    phoneNumber: phoneNumber ?? this.phoneNumber,
  );
}
