## 0.1.0

* Initial release.
* `DatePickerFormField`: a locale-aware date form field that can be typed manually or
  picked from the calendar dialog, with `initialDate`, `firstDate` and `lastDate` bounds.
* `DateInputFormatter`: the locale-aware as-you-type date formatter, exported separately
  so it can be applied to any `TextFormField` (`hintText` reflects the locale pattern).
* Localized `hintText`/pattern ordering driven by the active app locale.
* Typed `validator` and `onSaved` callbacks for `Form` integration, receiving the parsed
  `DateTime` (or `null` while the input is empty, incomplete or out of range).
* Exposes stable widget keys for widget tests (`switchToEntryModeKey`, `textInputKey`,
  `launchDatePickerKey`).
* Setup guidance for `material_ui` apps: use
  `SaibleLocalizations.localizationsDelegates` from `saible_consulting_core` to get the
  country strings together with `material_ui`'s Material, Cupertino and Widgets delegates.
* Built on `material_ui`, the official Flutter Material library.

