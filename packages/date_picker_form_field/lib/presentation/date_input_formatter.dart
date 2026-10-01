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

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

enum _DatePart() { day, month, year }

class const _DatePattern({required this.parts, required this.separator}) {
  final List<_DatePart> parts;
  final String separator;
}

/// Formats user date input dynamically based on the date format of the given [locale].
class DateInputFormatter({this.locale = 'en_GB'}) extends TextInputFormatter {
  /// The locale string (e.g. `'en_GB'`, `'en_US'`) determining the date part ordering and separator.
  final String locale;
  late final _DatePattern _pattern;

  /// Creates a [DateInputFormatter] configured for [locale].
  this {
    _pattern = _parseLocale(locale);
  }

  /// Helper property to generate matching hint text (e.g. "DD/MM/YYYY", "MM/DD/YYYY", or "YYYY-MM-DD")
  String get hintText => _pattern.parts
      .map(
        (part) => switch (part) {
          _DatePart.day => 'DD',
          _DatePart.month => 'MM',
          _DatePart.year => 'YYYY',
        },
      )
      .join(_pattern.separator);

  /// Parses `DateFormat.yMd` pattern for the given locale to detect part order and separator.
  static _DatePattern _parseLocale(String locale) {
    final rawPattern = DateFormat.yMd(locale).pattern ?? 'dd/MM/yyyy';

    // 1. Extract non-alphanumeric separator (e.g. '/', '.', '-')
    final separatorMatch = RegExp('[^a-zA-Z0-9]').firstMatch(rawPattern);
    final separator = separatorMatch?.group(0) ?? '/';

    // 2. Determine order of Day, Month, and Year
    final parts = <_DatePart>[];
    for (int i = 0; i < rawPattern.length; i++) {
      final char = rawPattern[i].toLowerCase();
      if (char == 'y' && !parts.contains(_DatePart.year)) {
        parts.add(_DatePart.year);
      } else if (char == 'm' && !parts.contains(_DatePart.month)) {
        parts.add(_DatePart.month);
      } else if (char == 'd' && !parts.contains(_DatePart.day)) {
        parts.add(_DatePart.day);
      }
    }

    // Fallback if parsing fails
    if (parts.length < 3) {
      return const _DatePattern(parts: [_DatePart.day, _DatePart.month, _DatePart.year], separator: '/');
    }

    return _DatePattern(parts: parts, separator: separator);
  }

  bool _isSeparator(String char) {
    if (char == _pattern.separator) return true;
    return char == '/' || char == '.' || char == '-' || char == ' ' || char == ',';
  }

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Gracefully handle backspacing over separators
    final isDeleting = newValue.text.length < oldValue.text.length &&
        oldValue.text.startsWith(newValue.text);
    if (isDeleting) {
      String text = newValue.text;
      if (text.endsWith(_pattern.separator)) {
        text = text.substring(0, text.length - 1);
      }
      return TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );
    }

    final buffer = StringBuffer();
    int partIdx = 0;
    final currentPartDigits = StringBuffer();

    void commitCurrentPart({required bool addSeparator}) {
      if (currentPartDigits.isEmpty) return;
      final part = _pattern.parts[partIdx];
      String digits = currentPartDigits.toString();
      // If user explicitly typed a separator after a single digit for day or month, pad to 2 digits.
      if (addSeparator && digits.length == 1 && (part == _DatePart.day || part == _DatePart.month)) {
        digits = '0$digits';
      }
      buffer.write(digits);
      if (addSeparator && partIdx < _pattern.parts.length - 1) {
        buffer.write(_pattern.separator);
      }
      currentPartDigits.clear();
      partIdx++;
    }

    for (int i = 0; i < newValue.text.length; i++) {
      if (partIdx >= _pattern.parts.length) {
        break;
      }
      final char = newValue.text[i];
      final isDigit = char.codeUnitAt(0) >= 48 && char.codeUnitAt(0) <= 57;

      if (isDigit) {
        final part = _pattern.parts[partIdx];
        final maxDigits = part == _DatePart.year ? 4 : 2;

        if (currentPartDigits.length == maxDigits) {
          commitCurrentPart(addSeparator: true);
          if (partIdx < _pattern.parts.length) {
            currentPartDigits.write(char);
          }
        } else {
          currentPartDigits.write(char);
        }
      } else if (_isSeparator(char)) {
        if (currentPartDigits.isNotEmpty) {
          commitCurrentPart(addSeparator: true);
        }
      }
    }

    if (currentPartDigits.isNotEmpty && partIdx < _pattern.parts.length) {
      commitCurrentPart(addSeparator: false);
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
