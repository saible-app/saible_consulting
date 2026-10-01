## 0.2.0

* **Adaptive platform picker**: introduced `AdaptiveDatePickerProvider` with
  `CupertinoDatePickerProvider` (Cupertino date picker in a modal popup on iOS and macOS)
  and `MaterialDatePickerProvider` (`DatePickerDialog` on Android, Linux, and Windows).
* **Custom provider injection**: added `pickerProvider` parameter to `DatePickerFormField`
  to allow supplying custom date picker implementations or overriding the platform default.
* **Direct separator keyboard typing**: `DateInputFormatter` now supports typing separators
  directly (`/`, `.`, `-`, `,`, space) with immediate display feedback, and automatically
  pads single-digit day or month entries with a leading zero (e.g. `3/` becomes `03/`).
* **Cleaned up testing keys**: removed obsolete `DatePickerFormField.switchToEntryModeKey`
  as the field now defaults directly to keyboard entry.
* **Updated dependencies**: added `cupertino_ui: ^1.1.1` and `provider: ^6.1.5+1`.

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

