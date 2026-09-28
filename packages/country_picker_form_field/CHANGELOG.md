## 0.1.0

* Initial release.
* `CountryPickerFormField`: a searchable country selector form field that integrates with
  `Form`/`TextFormField` validation through `decoration` and `onCountryPicked`.
* Typo-tolerant fuzzy search (Jaro-Winkler) over country names, alpha-2/alpha-3 codes,
  dial codes and aliases, powered by `saible_consulting_core`.
* Flag emojis and localized country names that follow the active app locale.
* Exposes stable widget keys for widget tests.
* Built on `material_ui`, the official Flutter Material library.

