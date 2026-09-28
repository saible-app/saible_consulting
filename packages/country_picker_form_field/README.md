# country_picker_form_field

An accessible, high-performance country picker form field for Flutter applications with integrated fuzzy search, native flag emojis, and multi-lingual localization.

`CountryPickerFormField` embeds directly into Flutter forms as a first-class form component. Powered by the Material 3 `SearchAnchor` pattern, it provides a fluid search experience that responds in real time across mobile, tablet, desktop, and web platforms.

---

## Key Architectural Strengths

- **Modern Material 3 `SearchAnchor` Architecture**:
  - Leverages Flutter's native `SearchAnchor` and `TextFormField` interaction model rather than cumbersome modal sheets, full-page navigators, or custom overlay hacks.
  - Automatically adapts its display presentation to the current screen size and input modality (touch, mouse, keyboard).
- **Fast, Typo-Tolerant Search Engine**:
  - Backed by an in-memory Jaro-Winkler fuzzy search engine with length-bound early rejection.
  - Users can search naturally by localized country name, ISO 3166-1 alpha-2 code, alpha-3 code, or colloquial alternative names.
- **Offline & Zero Extra Asset Footprint**:
  - No asset bundles, custom fonts, or hundreds of SVG files: renders crisp country flag icons using system-native Unicode regional indicator flag emojis.
  - Works 100% offline with zero network latency.
- **Enterprise-Grade Localization**:
  - Built-in translations across 39 global languages (English, French, German, Spanish, Welsh, Japanese, Chinese, Arabic, Russian, Korean, Turkish, Hindi, and more).
- **Comprehensive Testability**:
  - Fully decoupled and deterministic, exporting stable testing keys (`countrySearchAnchorKey`, `countrySearchBarKey`) for clean widget test automation.
  - Maintained with over 99% automated test coverage.

---

## Features

- **Full ISO 3166-1 Country Support**: Covers all 249 recognized countries and territories.
- **Dynamic Fuzzy Search**: Instant, typo-tolerant search across names, codes, and aliases.
- **Multi-Lingual Localization**: Displays localized country names matching the active Flutter app locale, with translations for all 39 supported languages.
- **First-Class Form Integration**: Seamlessly works with `Form`, `Formz`, `InputDecoration`, and state management solutions (BLoC, Riverpod, Provider).
- **Flag Badge Affordance**: Displays clean suffix/prefix flag emojis for the active selection.

---

## Getting Started

Add `country_picker_form_field` and `saible_consulting_core` to your `pubspec.yaml`:

```yaml
dependencies:
  country_picker_form_field: ^0.0.1
  saible_consulting_core: ^0.0.1
```

Ensure your `MaterialApp` is configured with the `saible_consulting_core`
localization delegates (no provider or lookup is required):

```dart
import 'package:flutter/material.dart';
import 'package:saible_consulting_core/saible_consulting_core.dart';

MaterialApp(
  supportedLocales: CountryLocalizations.supportedLocales,
  localizationsDelegates: CountryLocalizations.localizationsDelegates,
  home: const MyFormPage(),
);
```

---

## Usage

### Basic Example

```dart
import 'package:flutter/material.dart';
import 'package:country_picker_form_field/country_picker_form_field.dart';
import 'package:saible_consulting_core/domain/iso3166_countries.dart';

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

`CountryPickerFormField` exposes stable testing keys for automation:

- `CountryPickerFormField.countrySearchAnchorKey`: The `SearchAnchor` widget key.
- `CountryPickerFormField.countrySearchBarKey`: The search entry `TextFormField` key.

In widget tests, you can find and interact with the search bar reliably:

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

