# saible_core

Shared core domain models, utilities, localization delegates, and UI components for the Saible Consulting Flutter packages suite (`country_picker_form_field`, `date_picker_form_field`, `phone_number_form_field`, and `form_demo`).

---

## Features

- **Comprehensive ISO 3166 Country Dataset**:
  - Full list of 249 ISO 3166-1 countries (`Iso3166Country` enum) with alpha-2 codes, alpha-3 codes, numeric calling codes, and flag emojis.
  - Multi-language localized country names and search terms across 15+ locales (English, Welsh, German, French, Spanish, Japanese, Chinese, Arabic, Russian, Hindi, Italian, Dutch, Polish, Portuguese, etc.).
- **Jaro-Winkler Fuzzy Matching (`JaroWinkler`)**:
  - Fast, memory-efficient string similarity and distance computation with prefix bonuses.
  - Provable upper-bound pruning (`similarityUpperBound`) to reject non-matching candidate strings by length prior to performing costly calculations.
- **In-Memory Text Search (`TextSearch` & `TextSearchItem`)**:
  - Multi-term scoring with penalties, word-splitting, stripped whitespace matching, and prefix matching.
  - Efficient top-$k$ bounded candidate selection with early exit (`fastSearch(term, limit: k)`).
- **Date Extensions (`DateOperations` & `DateCollection`)**:
  - Timezone-safe date arithmetic (`dateOnly()`, `addDays()`, `addYears()`) and collection helpers (`max()`).
- **Country Presentation Helpers**:
  - `CountriesProvider`: Precomputes and caches country search terms in the widget tree.
  - `FlagIcon.forIso3166`: Renders high-quality country flag emojis.
  - `NationTile` & `PhoneCodeTile`: Ready-to-use `ListTile` components for selection dialogs and search anchors.

---

## Getting Started

Add `saible_core` to your `pubspec.yaml`:

```yaml
dependencies:
  saible_core: ^0.0.1
```

Import the package in your Dart code:

```dart
import 'package:saible_core/saible_core.dart';
```

---

## Usage

### 1. Working with Countries and Flag Emojis

```dart
import 'package:saible_core/domain/iso3166_countries.dart';
import 'package:saible_core/l10n/app_localizations.dart';

// Lookup by country enum
const country = Iso3166Country.unitedKingdom;
print(country.alpha2);     // 'GB'
print(country.alpha3);     // 'GBR'
print(country.phoneCode);  // 44
print(country.flagEmoji()); // '🇬🇧'

// Localized translation
final enLoc = lookupCountryLocalizations(const Locale('en', 'GB'));
print(country.tr(enLoc));  // 'United Kingdom'

final cyLoc = lookupCountryLocalizations(const Locale('cy'));
print(country.tr(cyLoc));  // 'y Deyrnas Unedig'
```

### 2. High-Performance Fuzzy Search

```dart
import 'package:saible_core/application/text_search_item.dart';

final search = TextSearch<String>([
  TextSearchItem.fromTerms('United Kingdom', ['united kingdom', 'GB', 'GBR', 'great britain']),
  TextSearchItem.fromTerms('France', ['france', 'FR', 'FRA', 'french republic']),
  TextSearchItem.fromTerms('Germany', ['germany', 'DE', 'DEU', 'deutschland']),
]);

// Returns top 2 matches ordered by score
final topMatches = search.fastSearch('britain', limit: 2);
print(topMatches); // ['United Kingdom']
```

### 3. Date Manipulation Extensions

```dart
import 'package:saible_core/application/date_utils.dart';

final now = DateTime.now();
final date = now.dateOnly(); // Strip time component
final nextWeek = date.addDays(7);
final adultDate = date.addYears(-18);

final dates = [date, nextWeek, adultDate];
print(dates.max()); // nextWeek
```

### 4. Injecting Country Localization in Widgets

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saible_core/saible_core.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: CountryLocalizations.supportedLocales,
      localizationsDelegates: CountryLocalizations.localizationsDelegates,
      builder: (context, child) => Provider<CountryLocalizations>.value(
        value: lookupCountryLocalizations(
          Localizations.maybeLocaleOf(context) ?? const Locale('en', 'GB'),
        ),
        child: child,
      ),
      home: const MyHomeScreen(),
    );
  }
}
```

---

## Additional Information

- Source code: [GitHub Repository](https://github.com/saible-app/saible_consulting.git)
- Issue tracker: File bugs or feature requests via GitHub Issues.
- License: See [LICENSE](LICENSE) for details.

