// Copyright 2026 Saible Ltd
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:formz/formz.dart';
import 'package:saible_consulting_core/saible_consulting_core.dart';

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
