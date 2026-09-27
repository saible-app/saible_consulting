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

    // Extract raw numbers
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final buffer = StringBuffer();

    int digitIdx = 0;
    for (int i = 0; i < _pattern.parts.length; i++) {
      final part = _pattern.parts[i];
      final maxDigits = part == _DatePart.year ? 4 : 2;

      for (int j = 0; j < maxDigits; j++) {
        if (digitIdx < digits.length) {
          buffer.write(digits[digitIdx]);
          digitIdx++;
        } else {
          break;
        }
      }

      // Add separator if user keeps typing for the next segment
      if (digitIdx < digits.length && i < _pattern.parts.length - 1) {
        buffer.write(_pattern.separator);
      }
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
