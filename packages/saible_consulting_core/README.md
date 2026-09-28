# saible_consulting_core

Shared core domain models, high-performance fuzzy search, localization delegates, and UI components for the Saible Consulting Flutter packages suite (`country_picker_form_field`, `date_picker_form_field`, `phone_number_form_field`, and `form_demo`).

---

## Key Architectural Strengths

- **Comprehensive, Embedded ISO 3166 Dataset**:
  - Full dataset covering all 249 ISO 3166-1 countries and territories (`Iso3166Country` enum) with ISO-2 alpha codes, ISO-3 codes, international calling codes, and native flag emojis.
  - Zero external network dependencies: all country metadata is bundled, type-safe, and instantly accessible offline.
  - Deep multi-lingual localization across 15+ locales (English, Welsh, French, German, Spanish, Japanese, Chinese, Arabic, Russian, Hindi, Italian, Dutch, Polish, Portuguese, etc.).
- **Mathematically Optimized In-Memory Search**:
  - **Jaro-Winkler with Provable Upper-Bound Pruning**: Computes similarity and distance with Winkler prefix scaling while utilizing a mathematical length bound (`similarityUpperBound`) to prune non-matching candidates before running costly $O(N \cdot M)$ string comparisons.
  - **Bounded Top-$k$ Selection (`fastSearch`)**: Retains only the best matching candidates with early termination, eliminating the need to score or sort full datasets on every keystroke.
  - **Zero-Allocation Tokenization**: Search terms precompute lowercased, stripped, and word-split representations up front, keeping UI typing completely jank-free.
- **Timezone-Safe Date Arithmetic**:
  - `DateOperations` (`dateOnly()`, `addDays()`, `addYears()`) manipulates calendar year, month, and day components directly rather than naive duration addition, completely eliminating Daylight Saving Time (DST) timezone shift bugs.
- **Lean Dependency Footprint & Enterprise Quality**:
  - Lightweight, modular architecture with zero bloat.
  - Exceptionally high test coverage (>99% lines and branches) ensuring rock-solid stability in production environments.

---

## Features

- **ISO 3166-1 Country Directory**: Complete enum mapping with dial codes, alpha codes, and flag emojis.
- **Jaro-Winkler Fuzzy Matching (`JaroWinkler`)**: Memory-efficient fuzzy distance calculator with tunable prefix scaling.
- **In-Memory Text Search Engine (`TextSearch` & `TextSearchItem`)**: Typo-tolerant, multi-term matching with prefix incentives and word-boundary handling.
- **Calendar & Date Utilities (`DateOperations` & `DateCollection`)**: Safe date math and collection aggregations (`max()`).
- **Presentation Primitives**: `CountriesProvider` for reactive caching, `FlagIcon.forIso3166`, `NationTile`, and `PhoneCodeTile`.

---

## Getting Started

Add `saible_consulting_core` to your `pubspec.yaml`:

```yaml
dependencies:
  saible_consulting_core: ^0.0.1
```

Import the package in your Dart code:

```dart
import 'lib/saible_consulting_core.dart';
```

---

## Usage

### 1. Working with Countries and Flag Emojis

```dart
import 'lib/domain/iso3166_countries.dart';
import 'lib/l10n/app_localizations.dart';

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
import 'lib/application/text_search_item.dart';

final search = TextSearch<String>([
  TextSearchItem.fromTerms('United Kingdom', ['united kingdom', 'GB', 'GBR', 'great britain']),
  TextSearchItem.fromTerms('France', ['france', 'FR', 'FRA', 'french republic']),
  TextSearchItem.fromTerms('Germany', ['germany', 'DE', 'DEU', 'deutschland']),
]);

// Returns top 2 matches ordered by score using bounded top-k pruning
final topMatches = search.fastSearch('britain', limit: 2);
print(topMatches); // ['United Kingdom']
```

### 3. Date Manipulation Extensions

```dart
import 'lib/application/date_utils.dart';

final now = DateTime.now();
final date = now.dateOnly(); // Strip time component
final nextWeek = date.addDays(7); // Safe across DST transitions
final adultDate = date.addYears(-18);

final dates = [date, nextWeek, adultDate];
print(dates.max()); // nextWeek
```

### 4. Injecting Country Localization in Widgets

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'lib/saible_consulting_core.dart';

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

