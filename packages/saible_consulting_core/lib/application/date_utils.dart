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
