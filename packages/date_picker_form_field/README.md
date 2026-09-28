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
- **Form-Ready Validation**: Typed `validator` and `onSaved` callbacks that receive the parsed `DateTime`, integrating with `Form.validate()` and form-level `AutovalidateMode`.

---

## Getting Started

Add `date_picker_form_field` to your `pubspec.yaml`:

```yaml
dependencies:
  date_picker_form_field: ^0.1.0
```

> **UI library:** this package is built on `material_ui`, the official Flutter
> Material library, and its API accepts `material_ui` types such as
> `InputDecoration`. Import `package:material_ui/material_ui.dart` in code that
> constructs those arguments: it exports distinct types that are not assignable
> to or from the copies exported by `package:flutter/material.dart`.

### Localization setup

Initialize date formatting before the first frame, so that typed input is parsed
and re-formatted with the pattern of the active locale:

```dart
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();
  runApp(const MyApp());
}
```

Then configure your `MaterialApp` with the localization plumbing from
`saible_consulting_core`:

```dart
import 'package:material_ui/material_ui.dart';
import 'package:saible_consulting_core/saible_consulting_core.dart';

MaterialApp(
  supportedLocales: SaibleLocalizations.supportedLocales,
  localizationsDelegates: SaibleLocalizations.localizationsDelegates,
  home: const MyFormPage(),
);
```

### Migrating from `package:flutter/material.dart`

`material_ui` is the Material library that used to ship inside
`package:flutter/material.dart`, so migration is mostly mechanical - the bundled
data-driven fix rewrites the imports for you:

```sh
dart fix --apply --code=migrate_design_widgets
```

Two things then need attention. Import `package:material_ui/material_ui.dart`
wherever you construct `material_ui` types (such as `InputDecoration`), as
described above - and make sure the localization delegates come from
`material_ui` too. `material_ui` widgets never read the legacy
`GlobalMaterialLocalizations`, `GlobalCupertinoLocalizations` or
`GlobalWidgetsLocalizations` classes from `package:flutter_localizations`, which
is why `SaibleLocalizations.localizationsDelegates` (shown above) pairs the
country names with `material_ui`'s own Material, Cupertino and Widgets
delegates. Use the generated `CountryLocalizations.localizationsDelegates` only
while parts of your app still build with `package:flutter/material.dart`.

If a dependency or subtree still imports `package:flutter/material.dart`, use
`MaterialUiCompatibilityBridge` to bridge `ThemeData` and
`MaterialLocalizations` for it - app-wide through `MaterialApp.builder`, or
around the individual subtree:

```dart
MaterialApp(
  builder: (context, child) => MaterialUiCompatibilityBridge(child: child!),
  home: const MyScreen(),
);
```

The bridge is a temporary migration aid (deprecated in `material_ui` 1.5.0 and
scheduled for removal in a future release), so migrate the legacy dependency
rather than shipping it long term.

---

## Usage

### Basic Example

```dart
import 'package:material_ui/material_ui.dart';
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
import 'package:material_ui/material_ui.dart';
import 'package:date_picker_form_field/presentation/date_input_formatter.dart';

final formatter = DateInputFormatter(locale: 'en_GB');

TextFormField(
  inputFormatters: [formatter],
  decoration: InputDecoration(
    hintText: formatter.hintText, // "DD/MM/YYYY"
  ),
);
```

### Form Validation

`validator` and `onSaved` plug the field into a `Form` and receive the parsed
`DateTime` - `null` while the input is empty, incomplete, syntactically invalid
or outside `firstDate`/`lastDate`:

```dart
final formKey = GlobalKey<FormState>();
DateTime? dateOfBirth;

Form(
  key: formKey,
  child: DatePickerFormField(
    firstDate: DateTime(1900),
    lastDate: DateTime.now(),
    decoration: const InputDecoration(labelText: 'Date of Birth'),
    validator: (date) => date == null ? 'Enter a valid date' : null,
    onSaved: (date) => dateOfBirth = date,
  ),
);

if (formKey.currentState!.validate()) {
  formKey.currentState!.save();
  print(dateOfBirth); // e.g. "1995-06-15 00:00:00.000"
}
```

The validator runs whenever the enclosing `Form` validates - through
`FormState.validate()` or a form-level `AutovalidateMode` - and sees the same
parsed value that `onDateChanged` reports, whether it was typed or picked from
the calendar dialog.

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

## How this compares

Alternative pub.dev packages, with their like counts, 30-day downloads and
latest releases as of 28 September 2026:

| Package | Likes | Downloads | Latest | Trade-offs |
| --- | --: | --: | --- | --- |
| [`date_field`](https://pub.dev/packages/date_field) | 139 | 905 | 7.0.0 (Sep 2026) | A well-maintained `DateTimeFormField` wrapping the platform pickers (Material and Cupertino) with date, time or date-and-time modes. Its value always comes from a picker dialog: there is no keyboard-first entry and no locale-driven input mask, and it depends on `cupertino_ui` as well as `material_ui`. |
| Hand-rolled `TextFormField` + `showDatePicker` | - | - | - | Zero extra dependencies, but you implement locale masking, separator and backspace handling, parsing, range clamping and the validation contract yourself. |

Pick `date_picker_form_field` when you want `DD/MM/YYYY`-style typed entry driven
by the active locale *and* the calendar dialog in the same field, with the
parsed `DateTime` (or `null`) handed to your `Form` through `validator` and
`onSaved`.

---

## Additional Information

- Source code: [GitHub Repository](https://github.com/saible-app/saible_consulting)
- Issue tracker: File bugs or feature requests via GitHub Issues.
- License: See [LICENSE](LICENSE) for details.

