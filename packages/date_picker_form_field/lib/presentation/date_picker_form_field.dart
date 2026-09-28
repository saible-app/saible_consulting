import 'package:date_picker_form_field/presentation/date_input_formatter.dart';
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

Future<void> _chooseDate(
  BuildContext context,
  DateTime initialDate,
  DateTime firstDate,
  DateTime lastDate,
  TextEditingController controller,
  DateFormat dateFormat,
  void Function(DateTime)? onPickDate,
  void Function(DateInputValue)? onDateChanged,
  String? pickerHelpText,
) async {
  await showDatePicker(
    context: context,
    helpText: pickerHelpText,
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
    switchToInputEntryModeIcon: const Icon(Icons.edit, key: DatePickerFormField.switchToEntryModeKey),
  ).then((date) {
    if (date == null || !context.mounted) return;
    controller.text = dateFormat.format(date);
    if (onPickDate != null) onPickDate(date);
    if (onDateChanged != null) onDateChanged((rawText: controller.text, parsedDate: date));
    FocusScope.of(context).nextFocus();
  });
}

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
  bool _isInitialised = false;

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
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialised) {
      final dateFormat = _fieldDateFormat(context);
      final currentDate = widget.initialDate;
      controller.text = currentDate == null ? '' : dateFormat.format(currentDate);
      _isInitialised = true;
    }
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
            await _chooseDate(
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
