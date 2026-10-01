## 0.2.0

* Bumped version to `0.2.0` aligned with the Saible Consulting package suite.
* Updated dependency constraint to `saible_consulting_core: ^0.2.0`.
* Verified compatibility with `material_ui` 1.5.0.
* Updated documentation with standard pub.dev package badges and demonstration media.

## 0.1.0

* Initial release.
* `CountryPickerFormField`: a searchable country selector form field that integrates with
  `Form` through `decoration` and `onCountryPicked`, plus typed `validator` and `onSaved`
  callbacks that receive the selected `Iso3166Country`.
* Typo-tolerant fuzzy search (Jaro-Winkler) over country names, alpha-2/alpha-3 codes,
  dial codes and aliases, powered by `saible_consulting_core`.
* Flag emojis and localized country names that follow the active app locale.
* Exposes stable widget keys for widget tests.
* Setup guidance for `material_ui` apps: use
  `SaibleLocalizations.localizationsDelegates` from `saible_consulting_core` to get the
  country strings together with `material_ui`'s Material, Cupertino and Widgets delegates.
* Built on `material_ui`, the official Flutter Material library.

