import 'package:formz/formz.dart';
import 'package:saible_core/domain/iso3166_countries.dart';

/// Validation errors that can occur on a country selection input.
enum CountryValidationError() {
  /// The user has not selected a country.
  empty,
}

/// Formz input representing the state of a country selection field.
class CountryInputState extends FormzInput<Iso3166Country?, CountryValidationError> {
  /// Creates an untouched [CountryInputState] with no country selected.
  const CountryInputState.pure() : super.pure(null);

  /// Creates a dirty [CountryInputState] with an optional selected [value].
  const CountryInputState.dirty([super.value]) : super.dirty();

  @override
  CountryValidationError? validator(Iso3166Country? value) {
    if (value == null) return CountryValidationError.empty;
    return null;
  }
}
