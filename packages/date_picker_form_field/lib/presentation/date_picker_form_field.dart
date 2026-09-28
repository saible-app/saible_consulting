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

import 'package:date_picker_form_field/presentation/date_input_formatter.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

/// The current state of a date input field, containing the parsed `parsedDate`
/// (or `null` if invalid, incomplete, or out of range) and the `rawText` as typed.
typedef DateInputValue = ({
  DateTime? parsedDate,
  String rawText,
});

/// The default earliest allowable date for [DatePickerFormField], January 1, 1900.
final defaultFirstDate = DateTime(1900);

/// The default latest allowable date for [DatePickerFormField], December 31, 2099.
final defaultLastDate = DateTime(2099, 12, 31);

Future<DateTime?> _chooseDate(
  BuildContext context,
  DateTime initialDate,
  DateTime firstDate,
  DateTime lastDate,
  TextEditingController controller,
  DateFormat dateFormat,
  void Function(DateTime)? onPickDate,
  void Function(DateInputValue)? onDateChanged,
  String? pickerHelpText,
) async => await showDatePicker(
  context: context,
  helpText: pickerHelpText,
  initialDate: initialDate,
  firstDate: firstDate,
  lastDate: lastDate,
  switchToInputEntryModeIcon: const Icon(Icons.edit, key: DatePickerFormField.switchToEntryModeKey),
  keyboardType: TextInputType.datetime,
).then((date) {
  if (date == null || !context.mounted) return null;
  controller.text = dateFormat.format(date);
  if (onPickDate != null) onPickDate(date);
  if (onDateChanged != null) onDateChanged((rawText: controller.text, parsedDate: date));
  FocusScope.of(context).nextFocus();
  return date;
});

/// A form field widget for selecting or typing dates with calendar picker integration.
class const DatePickerFormField({
  super.key,
  this.initialDate,
  this.firstDate,
  this.lastDate,
  this.decoration,
  this.onPickDate,
  this.onDateChanged,
  this.onEditText,
  this.onFieldSubmitted,
  this.onEditingComplete,
  this.focusNode,
  this.pickerHelpText,
}) extends StatefulWidget {
  /// The [Key] for switching to text input entry mode within the date picker dialog.
  static const switchToEntryModeKey = Key('datePickerTextField_switchToEntryMode');

  /// The [Key] for the text input field.
  static const textInputKey = Key('datePickerTextField_textInput');

  /// The [Key] for the suffix icon button that launches the date picker dialog.
  static const launchDatePickerKey = Key('datePickerTextField_launchDatePicker');

  /// Creates a [DatePickerFormField].
  this;

  /// The initial date displayed and selected in the field.
  final DateTime? initialDate;

  /// The earliest selectable date (defaults to [defaultFirstDate]).
  final DateTime? firstDate;

  /// The latest selectable date (defaults to [defaultLastDate]).
  final DateTime? lastDate;

  /// The decoration applied to the underlying [TextFormField].
  final InputDecoration? decoration;

  /// Optional help text displayed in the date picker dialog header.
  final String? pickerHelpText;

  /// An optional [FocusNode] to control the focus of the input field.
  final FocusNode? focusNode;

  /// Callback invoked when a date is selected from the calendar dialog.
  final void Function(DateTime)? onPickDate;

  /// Callback invoked when the date value changes, firing the parsed [DateTime]
  /// if valid or `null` if the input is invalid, incomplete, or out of range.
  final void Function(DateInputValue)? onDateChanged;

  /// Callback invoked when the user edits text directly in the field.
  final void Function(String)? onEditText;

  /// Callback invoked when the user indicates they are done editing (e.g. presses Enter/Submit).
  final void Function(String)? onFieldSubmitted;

  /// Callback invoked when editing is complete on the text field.
  final void Function()? onEditingComplete;

  @override
  State<DatePickerFormField> createState() => _DatePickerFormFieldState();
}

class _DatePickerFormFieldState() extends State<DatePickerFormField> {
  late final TextEditingController controller;
  Locale? _lastLocale;
  DateTime? currentDate;

  /// The date format used to write dates into the field's text controller.
  ///
  /// Native digits are disabled because [DateInputFormatter] only supports
  /// ASCII digits. Some locales (e.g. ar-SA) format dates with native digits
  /// by default (e.g. `٣١‏/١٠‏/١٩٩٩`); those digits would be inconsistent with
  /// typed input and would be stripped entirely by the input formatter on the
  /// next edit.
  DateFormat _fieldDateFormat(BuildContext context) {
    final languageTag = Localizations.localeOf(context).toLanguageTag();
    return DateFormat.yMd(languageTag)..useNativeDigits = false;
  }

  DateInputValue _parseDate(String text, DateFormat dateFormat) {
    final digits = text.replaceAll(RegExp(r'\D'), '');
    if (digits.length != 8) return (rawText: text, parsedDate: null);
    try {
      final parsed = dateFormat.parseStrict(text);
      return (rawText: text, parsedDate: parsed);
    } catch (_) {
      return (rawText: text, parsedDate: null);
    }
  }

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    currentDate = widget.initialDate;
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = Localizations.maybeLocaleOf(context);
    if (locale == _lastLocale) return;
    _lastLocale = locale;
    final dateFormat = _fieldDateFormat(context);
    final currentDate = this.currentDate;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      controller.text = currentDate == null ? '' : dateFormat.format(currentDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    final languageTag = Localizations.localeOf(context).toLanguageTag();
    final dateFormat = _fieldDateFormat(context);
    final inputFormatter = DateInputFormatter(locale: languageTag);
    return TextFormField(
      key: DatePickerFormField.textInputKey,
      focusNode: widget.focusNode,
      keyboardType: TextInputType.datetime,
      inputFormatters: [inputFormatter],
      onChanged: (text) {
        widget.onEditText?.call(text);
        final date = _parseDate(text, dateFormat);
        setState(() {
          currentDate = date.parsedDate;
        });
        widget.onDateChanged?.call(_parseDate(text, dateFormat));
      },
      onFieldSubmitted: widget.onFieldSubmitted,
      onEditingComplete: widget.onEditingComplete,
      controller: controller,
      decoration: (widget.decoration ?? const InputDecoration()).copyWith(
        hintText: inputFormatter.hintText,
        errorMaxLines: widget.decoration?.errorMaxLines ?? 2,
        suffixIcon: IconButton(
          key: DatePickerFormField.launchDatePickerKey,
          icon: const Icon(Icons.calendar_month),
          onPressed: () async {
            final date = await _chooseDate(
              context,
              _pickerInitialDate(),
              widget.firstDate ?? defaultFirstDate,
              widget.lastDate ?? defaultLastDate,
              controller,
              dateFormat,
              widget.onPickDate,
              widget.onDateChanged,
              widget.pickerHelpText,
            );

            if (date != null) {
              setState(() {
                currentDate = date;
              });
            }
          },
        ),
      ),
    );
  }

  /// The date the picker dialog opens on: [DatePickerFormField.initialDate]
  /// when given, otherwise today, clamped into the selectable window so a
  /// last date in the past (e.g. a date-of-birth field) cannot trip the
  /// picker's range assertion.
  DateTime _pickerInitialDate() {
    final first = widget.firstDate ?? defaultFirstDate;
    final last = widget.lastDate ?? defaultLastDate;
    final proposed = widget.initialDate ?? DateTime.now();
    if (proposed.isBefore(first)) return first;
    if (proposed.isAfter(last)) return last;
    return proposed;
  }
}
