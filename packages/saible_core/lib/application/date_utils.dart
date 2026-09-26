import 'package:material_ui/material_ui.dart';

extension DateCollection on Iterable<DateTime> {
  DateTime max() => reduce((x, y) => x.isAfter(y) ? x : y);
}

extension DateOperations on DateTime {
  DateTime dateOnly() => DateUtils.dateOnly(this);

  // Don't use add(Duration(days: days)), because that will add days * 24 hours to the current value,
  // which will break the implementation when you move through a timezone.
  DateTime addDays(int days) => DateTime(year, month, day + days, hour, minute, second, millisecond, microsecond);
  DateTime addYears(int years) => DateTime(year + years, month, day, hour, minute, second, millisecond, microsecond);
}
