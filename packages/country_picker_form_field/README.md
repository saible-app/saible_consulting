# country_picker_form_field

An interactive, accessible, and searchable country picker form field for Flutter applications.

`CountryPickerFormField` embeds seamlessly into Flutter forms and provides an intuitive search bar that opens an anchor dialog/sheet showing real-time, fuzzy-matched country suggestions complete with localized names and country flag emojis.

---

## Features

- **Full ISO 3166-1 Country Support**: Powered by `saible_core`, supporting all 249 recognized countries and territories.
- **Dynamic Fuzzy Search**: Instant in-memory search using the Jaro-Winkler distance algorithm that matches country names, alpha-2 codes, alpha-3 codes, and common alternative names.
- **Multi-Lingual Localization**: Displays localized country names across 15+ supported languages (English, French, German, Spanish, Welsh, Japanese, etc.).
- **Form Integration**: Integrates directly with standard Flutter forms, `Formz`, `TextFormField` decorations, and validation flows.
- **Prefix / Suffix Flag Icons**: Shows a clean language prefix or emoji flag badge for the selected country.

---

## Getting Started

Add `country_picker_form_field` and `saible_core` to your `pubspec.yaml`:

```yaml
dependencies:
  country_picker_form_field: ^0.0.1
  saible_core: ^0.0.1
```

Ensure your `MaterialApp` is configured with localization delegates so country names can be translated:

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
  home: const MyFormPage(),
);
```

---

## Usage

### Basic Example

```dart
import 'package:flutter/material.dart';
import 'package:country_picker_form_field/country_picker_form_field.dart';
import 'package:saible_core/domain/iso3166_countries.dart';

class NationalityFieldExample extends StatefulWidget {
  const NationalityFieldExample({super.key});

  @override
  State<NationalityFieldExample> createState() => _NationalityFieldExampleState();
}

class _NationalityFieldExampleState extends State<NationalityFieldExample> {
  Iso3166Country? _selectedCountry;

  @override
  Widget build(BuildContext context) {
    return CountryPickerFormField(
      initial: Iso3166Country.unitedKingdom,
      decoration: const InputDecoration(
        labelText: 'Nationality',
        hintText: 'Select your country',
        border: OutlineInputBorder(),
      ),
      onCountryPicked: (country) {
        setState(() {
          _selectedCountry = country;
        });
        print('Selected country: ${country.name} (${country.alpha2})');
      },
    );
  }
}
```

### Form & State Management (e.g. Formz / BLoC)

```dart
CountryPickerFormField(
  initial: state.nationality.value,
  decoration: InputDecoration(
    labelText: 'Nationality',
    errorText: state.nationality.isNotValid ? 'Please select a country' : null,
  ),
  onCountryPicked: (country) {
    context.read<MyFormBloc>().add(NationalityChanged(country));
  },
);
```

---

## Testing

`CountryPickerFormField` exposes stable testing keys:

- `CountryPickerFormField.countrySearchAnchorKey`: The `SearchAnchor` widget key.
- `CountryPickerFormField.countrySearchBarKey`: The search entry `TextFormField` key.

In widget tests, you can find and interact with the search bar:

```dart
await tester.tap(find.byKey(CountryPickerFormField.countrySearchBarKey));
await tester.pumpAndSettle();
await tester.enterText(find.byType(TextField).last, 'France');
await tester.pumpAndSettle();
```

---

## Additional Information

- Source code: [GitHub Repository](https://github.com/saible-app/saible_consulting.git)
- Issue tracker: File bugs or feature requests via GitHub Issues.
- License: See [LICENSE](LICENSE) for details.

