# date_picker_form_field

An accessible, locale-adaptive date input field for Flutter that bridges keyboard data entry with an intuitive graphical calendar picker.

`DatePickerFormField` solves the classic user experience dilemma between typing dates quickly and choosing dates from a calendar. It dynamically formats input as the user types according to the active locale's natural date pattern (e.g. `DD/MM/YYYY`, `MM/DD/YYYY`, or `YYYY-MM-DD`), while offering seamless popup calendar selection.

---

## Key Architectural Strengths

- **Dynamic, Locale-Adaptive Masking (`DateInputFormatter`)**:
  - Unlike rigid fixed-mask formatters, `DateInputFormatter` inspects `DateFormat.yMd` for the active locale at runtime to determine the true localized ordering of Day, Month, and Year as well as the regional separator (`/`, `-`, `.`).
  - Automatically matches and adjusts placeholder hints (e.g. `DD/MM/YYYY` in the UK, `MM/DD/YYYY` in the US, `YYYY-MM-DD` in Canada/Japan).
- **Intelligent Cursor & Separator Navigation**:
  - Purpose-built editing logic handles typing, digit insertions, and backspacing across separators gracefully: backspacing over a separator removes the preceding digit cleanly without breaking cursor placement or trapping user focus.
- **Unified Dual-Mode Workflow**:
  - Users can either type the digits directly or tap the calendar icon to select from a native `DatePickerDialog`.
  - Date choices in either mode keep the text field and validation state perfectly synchronized.
- **Validation-Ready State Contract**:
  - The `onDateChanged` callback provides a structured `DateInputValue(rawText: ..., parsedDate: ...)`.
  - `parsedDate` evaluates to `null` if the date is incomplete, syntactically invalid (e.g. February 30th), or outside the allowable `firstDate` and `lastDate` boundaries, enabling instant integration with `Formz` or Flutter `Form` validation.
- **Enterprise Reliability & Testability**:
  - Provides exported static keys (`textInputKey`, `launchDatePickerKey`, `switchToEntryModeKey`) for deterministic end-to-end testing.
  - Backed by comprehensive test suites with >99% code coverage.

---

## Features

- **Locale-Aware Formatting**: Dynamically formats date components based on the user's regional preferences.
- **Dual Input Modes**: Fluid keyboard entry alongside standard graphical calendar picking.
- **Strict Range Clamping**: Enforces configurable `firstDate` and `lastDate` boundaries.
- **Clean Event Lifecycle**: Dedicated callbacks for `onDateChanged`, `onPickDate`, `onEditText`, `onFieldSubmitted`, and `onEditingComplete`.

---

## Getting Started

Add `date_picker_form_field` to your `pubspec.yaml`:

```yaml
dependencies:
  date_picker_form_field: ^0.0.1
```

Initialize date formatting in your application `main()` if supporting multiple locales:

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
        print('Typed: ${value.rawText}, Valid Date: ${value.parsedDate}');
      },
      onPickDate: (pickedDate) {
        print('Selected from calendar: $pickedDate');
      },
    );
  }
}
```

### Standalone `DateInputFormatter` Usage

You can also use the formatter independently on any standard Flutter `TextFormField`:

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

`DatePickerFormField` exposes stable testing keys for automation:

- `DatePickerFormField.textInputKey`: Key for the date `TextFormField`.
- `DatePickerFormField.launchDatePickerKey`: Key for the calendar picker launcher icon button.
- `DatePickerFormField.switchToEntryModeKey`: Key for entry mode toggling in dialogs.

Example widget test:

```dart
// Type a date
await tester.enterText(find.byKey(DatePickerFormField.textInputKey), '15061995');
await tester.pumpAndSettle();

// Or tap the calendar icon
await tester.tap(find.byKey(DatePickerFormField.launchDatePickerKey));
await tester.pumpAndSettle();
```

---

## Additional Information

- Source code: [GitHub Repository](https://github.com/saible-app/saible_consulting.git)
- Issue tracker: File bugs or feature requests via GitHub Issues.
- License: See [LICENSE](LICENSE) for details.

