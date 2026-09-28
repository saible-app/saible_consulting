# phone_number_form_field

An accessible, international phone number input field for Flutter applications featuring intelligent country dial-code selection, as-you-type formatting, and rigorous international E.164 compliance validation.

`PhoneNumberFormField` delivers an enterprise-grade phone input experience by uniting an interactive calling-code prefix selector with continuous formatting and parsing powered by Google's authoritative `libphonenumber` metadata.

---

## Key Architectural Strengths

- **Powered by Google's `libphonenumber` Standard (`dlibphonenumber`)**:
  - Employs the industry gold standard for international phone number plans, area codes, number lengths, and formatting rules across every global region.
  - Avoids brittle regexes or crude length assumptions that fail on complex national numbering systems.
- **Continuous As-You-Type Formatting with Trunk Stripping**:
  - Formats numbers naturally in real time as user digits are typed.
  - Automatically detects and removes redundant domestic trunk prefixes (such as the leading `0` in UK or Australian mobile numbers) when typed or pasted, guaranteeing proper international formatting.
- **Strict International E.164 State Contract**:
  - Emits an immutable `PhoneNumberState` containing `rawText`, `regionCode`, and parsed `e164` (e.g. `+442079460123`).
  - `e164` is non-null only when the number is genuinely valid and deliverable, making backend integrations (Twilio, AWS SNS, Firebase Auth, Stripe) immediate and reliable.
- **Modern Material 3 Prefix Selector with Typo-Tolerant Search**:
  - The dial code selector uses a Material 3 `SearchAnchor` overlay that opens a fast, in-memory fuzzy search over country names, ISO codes, and dialing prefixes.
- **Lightweight, Zero-Asset Design**:
  - Renders native Unicode flag emojis without bundling hundreds of heavy vector or raster flag image files.
  - Fully offline, self-contained, and tested with >99% code coverage.

---

## Features

- **Country Calling-Code Selector**: Tap prefix to search all 249 ISO countries by name, code, or dial prefix.
- **As-You-Type Phone Formatting**: Automatic national phone structure formatting.
- **Trunk Code Normalization**: Automatically strips redundant domestic trunk zeros.
- **E.164 Compliance Validation**: Instant access to formatted E.164 string and boolean validity checks (`state.isValid`).
- **Flexible Form Integration**: Compatible with standard Flutter forms, `Formz`, and BLoC/Riverpod state managers.

---

## Getting Started

Add `phone_number_form_field` and `saible_consulting_core` to your `pubspec.yaml`:

```yaml
dependencies:
  phone_number_form_field: ^0.0.1
  saible_consulting_core: ^0.0.1
```

Configure your `MaterialApp` with country localizations delegates:

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saible_consulting_core/saible_consulting_core.dart';

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

`PhoneNumberFormField` exposes stable testing keys for automation:

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

