import 'package:material_ui/material_ui.dart';

@immutable
class const DateInputs({required this.current, required this.text, required this.first, required this.last}) {
  final DateTime? current;
  final String text;
  final DateTime first;
  final DateTime last;
  const DateInputs.empty({
    required DateTime first,
    required DateTime last
  }) : this(current: null, text: '', first: first, last: last);

  @override
  int get hashCode => Object.hash(current, text, first, last);

  @override
  bool operator ==(Object other) => identical(this, other)
    || other is DateInputs
    && other.current == current
    && other.text == text
    && other.first == first
    && other.last == last;

  DateInputs copyWith({
    ValueGetter<DateTime?>? current,
    String? text,
    DateTime? first,
    DateTime? last,
  }) => DateInputs(
    current: current == null ? this.current :  current(),
    text: text ?? this.text,
    first: first ?? this.first,
    last: last ?? this.last,
  );
}
