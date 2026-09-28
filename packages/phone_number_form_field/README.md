# phone_number_form_field

An accessible, international phone number input field for Flutter applications with integrated country calling-code selection and as-you-type formatting.

`PhoneNumberFormField` provides a country dial code prefix selector that opens a searchable anchor view with flags and calling codes, alongside an input field that automatically validates and formats phone numbers according to international E.164 standards.

---

## Features

- **Country Calling-Code Selector**:
  - Displays selected country flag emoji and dialing code (e.g. `🇬🇧 +44`).
  - Tapping the prefix opens a fast, searchable dialog listing all countries with their localized names and dialing codes.
- **As-You-Type Phone Formatting (`AsYouTypePhoneNumberFormatter`)**:
  - Automatically formats the input according to the active country's national format guidelines using `dlibphonenumber`.
  - Removes redundant trunk prefix when national numbers are pasted or entered.
- **E.164 Validation State**:
  - Emits `PhoneNumberState` with `rawText`, `regionCode`, and parsed `e164` (null when invalid or incomplete).
  - Quick checks via `state.isValid`, `state.isEmpty`, and `state.isNotEmpty`.
- **Formz & Form Integration**:
  - Easily coupled with form validation frameworks like `Formz`, Flutter `Form`, or BLoC state managers.

---

## Getting Started

Add `phone_number_form_field` and `saible_core` to your `pubspec.yaml`:

```yaml
dependencies:
  phone_number_form_field: ^0.0.1
  saible_core: ^0.0.1
```

Configure your `MaterialApp` with country localizations delegates:

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saible_core/saible_core.dart';

MaterialApp(
  supportedLocales: CountryLocalizations.supportedLocales,
  localizationsDelegates: CountryLocalizations.localizationsDelegates,
  builder: (context, child) => Provider<CountryLocalizations>.value(
    value: lookupCountryLocalizations(
      Localizations.maybeLocaleOf(context) ?? const Locale('en', 'GB'),
    ),
    child: child,
  ),
  home: const MyPhoneFormPage(),
);
```

---

## Usage

### Basic Example

```dart
import 'package:flutter/material.dart';
import 'package:phone_number_form_field/phone_number_form_field.dart';

class PhoneInputExample extends StatefulWidget {
  const PhoneInputExample({super.key});

  @override
  State<PhoneInputExample> createState() => _PhoneInputExampleState();
}

class _PhoneInputExampleState extends State<PhoneInputExample> {
  PhoneNumberState _phoneState = const PhoneNumberState.empty();

  @override
  Widget build(BuildContext context) {
    return PhoneNumberFormField(
      decoration: InputDecoration(
        labelText: 'Phone Number',
        border: const OutlineInputBorder(),
        errorText: _phoneState.isNotEmpty && !_phoneState.isValid
            ? 'Please enter a valid phone number'
            : null,
      ),
      onPhoneNumberChanged: (state) {
        setState(() {
          _phoneState = state;
        });
        print('E.164 number: ${state.e164}'); // e.g. "+442079460123"
        print('Region: ${state.regionCode}');  // e.g. "+44"
        print('Valid: ${state.isValid}');
      },
    );
  }
}
```

### Prepopulating an Initial Number

You can initialize the field with an existing `PhoneNumberState`:

```dart
PhoneNumberFormField(
  initialValue: const PhoneNumberState(
    rawText: '20 7946 0123',
    e164: '+442079460123',
    regionCode: '+44',
  ),
  onPhoneNumberChanged: (phoneState) {
    // handle state changes
  },
);
```

---

## Testing

`PhoneNumberFormField` exposes stable testing keys:

- `PhoneNumberFormField.countrySearchAnchorKey`: Key for the prefix search anchor.
- `PhoneNumberFormField.countrySearchBarKey`: Key for the phone number text entry field.
- `PhoneNumberFormField.countrySuggestionKey(country)`: Generates a test key for a country's suggestion tile.

Example widget test:

```dart
// Enter phone number
await tester.enterText(
  find.byKey(PhoneNumberFormField.countrySearchBarKey),
  '02079460123',
);
await tester.pumpAndSettle();

// Tap dial code selector
await tester.tap(find.text('+44'));
await tester.pumpAndSettle();
```

---

## Additional Information

- Source code: [GitHub Repository](https://github.com/saible-app/saible_consulting.git)
- Issue tracker: File bugs or feature requests via GitHub Issues.
- License: See [LICENSE](LICENSE) for details.

