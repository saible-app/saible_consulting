import 'package:material_ui/material_ui.dart';

/// Extension methods on collections of [DateTime].
extension DateCollection on Iterable<DateTime> {
  /// Returns the latest date-time in the iterable.
  DateTime max() => reduce((x, y) => x.isAfter(y) ? x : y);
}

/// Extension methods for common date manipulation on [DateTime].
extension DateOperations on DateTime {
  /// Returns a [DateTime] with only the date components (year, month, day).
  DateTime dateOnly() => DateUtils.dateOnly(this);

  /// Adds the given number of [days] without timezone offset issues.
  /// 
  /// This is safer than using add(Duration(days: days)), because that will add days * 24 hours to the current value,
  // which will break the implementation when you move through a timezone.
  DateTime addDays(int days) => DateTime(year, month, day + days, hour, minute, second, millisecond, microsecond);

  /// Adds the given number of [years] preserving the time and day components.
  DateTime addYears(int years) => DateTime(year + years, month, day, hour, minute, second, millisecond, microsecond);
}
