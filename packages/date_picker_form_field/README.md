# date_picker_form_field

An accessible, locale-aware date input field for Flutter that supports both direct keyboard entry and graphical calendar picking.

`DatePickerFormField` formats input dynamically as the user types according to the active locale's standard date structure (e.g. `DD/MM/YYYY`, `MM/DD/YYYY`, or `YYYY-MM-DD`), while allowing seamless date selection via a built-in calendar picker icon.

---

## Features

- **Locale-Aware Formatting (`DateInputFormatter`)**:
  - Automatically determines day, month, and year ordering and separator character (`/`, `.`, `-`) based on the active or specified locale.
  - Generates matching hint placeholders (e.g. `DD/MM/YYYY`).
  - Gracefully handles typing, digit insertions, and backspacing across separators without breaking cursor position.
- **Dual Input Modes**:
  - Direct keyboard entry formatted in real time.
  - Graphical calendar picker modal via `showDatePicker` triggered from an end-affordance button.
- **Validation-Ready State**:
  - `onDateChanged` emits `DateInputValue(rawText: ..., parsedDate: ...)` where `parsedDate` is non-null only if the text is complete, valid, and falls between `firstDate` and `lastDate`.
- **Customizable Boundaries**:
  - Configurable `firstDate` (defaults to 1900-01-01) and `lastDate` (defaults to 2099-12-31).
  - Configurable initial value, focus nodes, InputDecoration, and callbacks.

---

## Getting Started

Add `date_picker_form_field` to your `pubspec.yaml`:

```yaml
dependencies:
  date_picker_form_field: ^0.0.1
```

Ensure date symbol formatting is initialized in your app's `main()` if you format dates across multiple locales:

```dart
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();
  runApp(const MyApp());
}
```

---

## Usage

### Basic Example

```dart
import 'package:flutter/material.dart';
import 'package:date_picker_form_field/date_picker_form_field.dart';

class DateOfBirthExample extends StatefulWidget {
  const DateOfBirthExample({super.key});

  @override
  State<DateOfBirthExample> createState() => _DateOfBirthExampleState();
}

class _DateOfBirthExampleState extends State<DateOfBirthExample> {
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return DatePickerFormField(
      initialDate: DateTime(1995, 6, 15),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      decoration: const InputDecoration(
        labelText: 'Date of Birth',
        border: OutlineInputBorder(),
      ),
      onDateChanged: (value) {
        setState(() {
          _selectedDate = value.parsedDate;
        });
        print('Typed text: ${value.rawText}, parsed: ${value.parsedDate}');
      },
      onPickDate: (pickedDate) {
        print('Selected from calendar: $pickedDate');
      },
    );
  }
}
```

### Standalone `DateInputFormatter` Usage

You can also use the formatting logic independently with any standard Flutter `TextFormField`:

```dart
import 'package:flutter/material.dart';
import 'package:date_picker_form_field/presentation/date_input_formatter.dart';

final formatter = DateInputFormatter(locale: 'en_GB');

TextFormField(
  inputFormatters: [formatter],
  decoration: InputDecoration(
    hintText: formatter.hintText, // "DD/MM/YYYY"
  ),
);
```

---

## Testing

`DatePickerFormField` exposes stable testing keys:

- `DatePickerFormField.textInputKey`: Key for the underlying `TextFormField`.
- `DatePickerFormField.launchDatePickerKey`: Key for the calendar picker launcher icon button.
- `DatePickerFormField.switchToEntryModeKey`: Key for switching entry modes in the dialog.

Example widget test:

```dart
// Type a date
await tester.enterText(find.byKey(DatePickerFormField.textInputKey), '15061995');
await tester.pumpAndSettle();

// Or launch the picker
await tester.tap(find.byKey(DatePickerFormField.launchDatePickerKey));
await tester.pumpAndSettle();
```

---

## Additional Information

- Source code: [GitHub Repository](https://github.com/saible-app/saible_consulting.git)
- Issue tracker: File bugs or feature requests via GitHub Issues.
- License: See [LICENSE](LICENSE) for details.

