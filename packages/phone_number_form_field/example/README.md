# Example

A minimal application that demonstrates `phone_number_form_field`.

Everything lives in [`lib/main.dart`](lib/main.dart):

* `PhoneNumberFormField` prepopulated through `initialValue` with a
  `PhoneNumberState`, and an `InputDecoration` whose `errorText` reacts to the
  validation state.
* `onPhoneNumberChanged` receiving the latest `PhoneNumberState`, showing the
  parsed E.164 number (`e164`), the selected dial code (`regionCode`) and the
  `isValid` flag.
* A `MaterialApp` wired to `CountryLocalizations.supportedLocales` and
  `CountryLocalizations.localizationsDelegates`, so the dial code selector uses
  localized country names.

The example deliberately has no `pubspec.yaml` of its own: it is analyzed and
resolved with the dependencies of the package it ships inside. To run it, copy
[`lib/main.dart`](lib/main.dart) into a Flutter application that depends on
`phone_number_form_field`, `saible_consulting_core` and `material_ui`, and use
it as the app entrypoint.
