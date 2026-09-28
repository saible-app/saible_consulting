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

import 'package:date_picker_form_field/presentation/date_picker_form_field.dart';
import 'package:formz/formz.dart';
import 'package:material_ui/material_ui.dart';

/// The kinds of validation failures a [DateInputState] can report.
///
/// Implemented as an enum so that consumers can map each failure to their
/// own localized, user-facing error message (e.g. via a `switch` in an
/// `InputDecoration.errorText` builder).
enum DateInputStateErrorType() {
  /// The user has omitted a required date value.
  required,
  /// The user has typed in a date value that isn't a valid date.
  invalid,
  /// The entered date is before the minimum date.
  tooEarly,
  /// The entered date is after the maximum date.
  tooLate,
}

/// A validation failure for a [DateInputState], implemented as a sealed
/// class so that context (such as the boundary that was violated) can be
/// carried alongside the [type].
///
/// Exhaustive handling is enforced by the compiler: consumers should
/// `switch` over the concrete subclasses rather than testing [type]
/// manually.
sealed class const DateInputStateError(this.type) {
  /// The category of this failure, for consumers that prefer a single
  /// value to switch or compare against.
  final DateInputStateErrorType type;

  /// Creates an error of the given [type].
  this;
}

/// The date field was left empty even though a value is required.
final class const DateInputStateErrorRequired() extends DateInputStateError {
  /// Creates the omitted-value error.
  this : super(DateInputStateErrorType.required);
}

/// The user entered text that could not be parsed into a date at all
/// (e.g. `31/02/2020`).
final class const DateInputStateErrorInvalid() extends DateInputStateError {
  /// Creates the unparsable-text error.
  this : super(DateInputStateErrorType.invalid);
}

/// The user entered a well-formed date that lies before the earliest
/// selectable date, which is exposed as [first].
final class const DateInputStateErrorTooEarly({required this.first}) extends DateInputStateError {
  /// The earliest date the input accepts.
  final DateTime first;

  /// Creates the error, carrying the violated [first] boundary.
  this : super(DateInputStateErrorType.tooEarly);
}

/// The user entered a well-formed date that lies after the latest
/// selectable date, which is exposed as [last].
final class const DateInputStateErrorTooLate({required this.last}) extends DateInputStateError {
  /// The latest date the input accepts.
  final DateTime last;

  /// Creates the error, carrying the violated [last] boundary.
  this : super(DateInputStateErrorType.tooLate);
}

/// The formz state of a date-of-birth style input, validating that the
/// entered date exists and falls within a configurable window.
///
/// A [DateInputState.pure] state models an untouched field (typically
/// rendered without error styling), while a [DateInputState.dirty] state
/// models one the user has edited and should therefore be validated
/// visibly. Validation only succeeds when the `parsedDate`
/// is present and lies between [first] and [last]:
///
/// ```dart
/// final state = DateInputState.dirty(
///   first: () => DateTime(1900),
///   last: () => DateTime(2100, 12, 31),
///   input: (
///     parsedDate: DateTime(1999, 10, 31),
///     rawText: '31/10/1999',
///   ),
/// );
/// print(state.isValid); // true
/// ```
///
/// The error type is the sealed [DateInputStateError] hierarchy, so the
/// reason for a failure (and the boundary that was violated) can be
/// surfaced to the user:
///
/// ```dart
/// switch (state.error) {
///   case DateInputStateErrorTooEarly(:final first):
///     showError('Pick a date on or after ${first.year}.');
///   case null:
///     // Valid input.
///   // DateInputStateErrorRequired, DateInputStateErrorInvalid and
///   // DateInputStateErrorTooLate are enforced by the compiler too.
/// }
/// ```
class DateInputState extends FormzInput<DateInputValue, DateInputStateError> {
  /// Resolves the earliest acceptable [DateTime] boundary for validation.
  final ValueGetter<DateTime> first;

  /// Resolves the latest acceptable [DateTime] boundary for validation.
  final ValueGetter<DateTime> last;

  /// Creates a pristine state for a field the user has not yet interacted
  /// with, accepting initial [first] and [last] states that define the boundaries
  /// of the date input.
  const DateInputState.pure({required this.first, required this.last}) : super.pure(
    const (rawText: '', parsedDate: null)
  );

  /// Creates a state for a field the user has edited, carrying the full
  /// [input] snapshot to validate against.
  const DateInputState.dirty({
    required this.first,
    required this.last,
    required DateInputValue input,
  }) : super.dirty(input);

  /// Validates [inputs], returning the first violation found:
  ///
  /// * [DateInputStateErrorRequired] when no date is present and no text
  ///   has been typed,
  /// * [DateInputStateErrorInvalid] when text is present but no parsed
  ///   date is available,
  /// * [DateInputStateErrorTooEarly] when the date precedes
  ///   [first],
  /// * [DateInputStateErrorTooLate] when the date follows
  ///   [last],
  /// * or `null` when the input is valid.
  @override
  DateInputStateError? validator(DateInputValue inputs) {
    final DateInputValue(:parsedDate, :rawText) = inputs;
    if (parsedDate == null && rawText.isEmpty) return const DateInputStateErrorRequired();
    if (parsedDate == null) return const DateInputStateErrorInvalid();
    if (parsedDate.isBefore(first())) return DateInputStateErrorTooEarly(first: first());
    if (parsedDate.isAfter(last())) return DateInputStateErrorTooLate(last: last());
    return null;
  }
}
