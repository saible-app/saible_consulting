## 0.1.0

* Initial release.
* `DatePickerFormField`: a locale-aware date form field that can be typed manually or
  picked from the calendar dialog, with `initialDate`, `firstDate` and `lastDate` bounds.
* `DateInputFormatter`: the locale-aware as-you-type date formatter, exported separately
  so it can be applied to any `TextFormField` (`hintText` reflects the locale pattern).
* Localized `hintText`/pattern ordering driven by the active app locale.
* Exposes stable widget keys for widget tests (`switchToEntryModeKey`, `textInputKey`,
  `launchDatePickerKey`).
* Built on `material_ui`, the official Flutter Material library.

