import 'package:formz/formz.dart';
import 'package:saible_core/domain/date_inputs.dart';

enum DateInputStateErrorType() { required, invalid, tooEarly, tooLate }

sealed class const DateInputStateError(this.type) {
  final DateInputStateErrorType type;
}

final class const DateInputStateErrorRequired() extends DateInputStateError {
  this : super(DateInputStateErrorType.required);
}

final class const DateInputStateErrorInvalid() extends DateInputStateError {
  this : super(DateInputStateErrorType.invalid);
}

final class const DateInputStateErrorTooEarly({required this.first}) extends DateInputStateError {
  final DateTime first;
  this : super(DateInputStateErrorType.tooEarly);
}

final class const DateInputStateErrorTooLate({required this.last}) extends DateInputStateError {
  final DateTime last;
  this : super(DateInputStateErrorType.tooLate);
}

class DateInputState extends FormzInput<DateInputs, DateInputStateError> {
  DateInputState.pure(DateTime first, DateTime last) : super.pure(
    DateInputs.empty(first: first, last: last)
  );
  const DateInputState.dirty({required DateInputs inputs}) : super.dirty(inputs);

  @override
  DateInputStateError? validator(DateInputs inputs) {
    final DateInputs(:current, :text, :first, :last) = inputs;
    if (current == null && text.isEmpty) return const DateInputStateErrorRequired();
    if (current == null) return const DateInputStateErrorInvalid();
    if (current.isBefore(first)) return DateInputStateErrorTooEarly(first: first);
    if (current.isAfter(last)) return DateInputStateErrorTooLate(last: last);
    return null;
  }
}
