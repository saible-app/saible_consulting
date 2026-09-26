import 'package:date_picker_form_field/application/date_input_state.dart';
import 'package:date_picker_form_field/presentation/date_input_formatter.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

Future<void> _chooseDate(
  BuildContext context,
  DateInputState inputs,
  TextEditingController controller,
  DateFormat dateFormat,
  void Function(DateTime)? onPickDate,
  String? pickerHelpText,
) async {
  await showDatePicker(
    context: context,
    helpText: pickerHelpText,
    initialDate: inputs.value.current,
    firstDate: inputs.value.first,
    lastDate: inputs.value.last,
    switchToInputEntryModeIcon: const Icon(Icons.edit, key: DatePickerFormField.switchToEntryModeKey),
  ).then((date) {
    if (date == null) return;
    controller.text = dateFormat.format(date);
    if (onPickDate != null) onPickDate(date);
    if (context.mounted) FocusScope.of(context).nextFocus();
  });
}

class const DatePickerFormField({
  super.key,
  required this.initial,
  this.decoration,
  this.onPickDate,
  this.onEditText,
  this.onFieldSubmitted,
  this.onEditingComplete,
  this.focusNode,
  this.pickerHelpText,
}) extends StatefulWidget {
  static const switchToEntryModeKey = Key('datePickerTextField_switchToEntryMode');
  static const textInputKey = Key('datePickerTextField_textInput');
  static const launchDatePickerKey = Key('datePickerTextField_launchDatePicker');
  final DateInputState initial;
  final InputDecoration? decoration;
  final String? pickerHelpText;
  final FocusNode? focusNode;
  final void Function(DateTime)? onPickDate;
  final void Function(String)? onEditText;
  final void Function(String)? onFieldSubmitted;
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
      final currentDate = widget.initial.value.current;
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
      onChanged: widget.onEditText,
      onFieldSubmitted: widget.onFieldSubmitted,
      onEditingComplete: widget.onEditingComplete,
      controller: controller,
      decoration: InputDecoration(
        labelText: widget.decoration?.labelText,
        hintText: inputFormatter.hintText,
        errorText: widget.decoration?.errorText,
        errorMaxLines: widget.decoration?.errorMaxLines,
        suffixIcon: IconButton(
          key: DatePickerFormField.launchDatePickerKey,
          icon: const Icon(Icons.calendar_month),
          onPressed: () async {
            await _chooseDate(
              context,
              widget.initial,
              controller,
              dateFormat,
              widget.onPickDate,
              widget.pickerHelpText,
            );
          },
        ),
      ),
    );
  }
}
