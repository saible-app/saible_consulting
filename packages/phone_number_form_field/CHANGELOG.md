## 0.2.0

* Bumped version to `0.2.0` aligned with the Saible Consulting package suite.
* Updated dependency constraint to `saible_consulting_core: ^0.2.0`.
* Verified compatibility with `material_ui` 1.5.0.
* Updated documentation with standard pub.dev package badges and demonstration media.

## 0.1.0

* Initial release.
* `PhoneNumberFormField`: an international phone number form field with a searchable dial
  code prefix selector and full `Form` integration; typed `validator` and `onSaved`
  callbacks receive the parsed `PhoneNumberState` (E.164, region code, raw text).
* `PhoneNumberState` value type (`rawText`, `e164`, `regionCode`, `isValid`) reported
  through `onPhoneNumberChanged`, plus `PhoneNumberState.empty()` and
  `PhoneNumberState.fromPhoneNumber()` for prepopulating the field.
* E.164 parsing and validation through `dlibphonenumber`, with localized example numbers
  per country.
* `AsYouTypePhoneNumberFormatter` and other stable widget keys exposed for integration
  and widget tests.
* Setup guidance for `material_ui` apps: use
  `SaibleLocalizations.localizationsDelegates` from `saible_consulting_core` to get the
  country strings together with `material_ui`'s Material, Cupertino and Widgets delegates.
* Built on `material_ui`, the official Flutter Material library.

