# Example

A minimal application that demonstrates `country_picker_form_field`.

Everything lives in [`lib/main.dart`](lib/main.dart):

* `CountryPickerFormField` bound to an `Iso3166Country?` field in a
  `StatefulWidget`, with an `initial` selection and an `InputDecoration`
  (including `errorText`) that integrates with `Form` validation.
* A `MaterialApp` wired to `SaibleLocalizations.supportedLocales` and
  `SaibleLocalizations.localizationsDelegates`, so the country names, the fuzzy
  search and `material_ui`'s own Material strings all follow the active locale.
* The selected country rendered with its flag emoji (`flagEmoji()`) and its
  localized name (`tr(context)`).

The example deliberately has no `pubspec.yaml` of its own: it is analyzed and
resolved with the dependencies of the package it ships inside. To run it, copy
[`lib/main.dart`](lib/main.dart) into a Flutter application that depends on
`country_picker_form_field`, `saible_consulting_core` and `material_ui`, and use
it as the app entrypoint.
