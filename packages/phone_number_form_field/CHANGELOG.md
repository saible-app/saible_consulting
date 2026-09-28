## 0.1.0

* Initial release.
* `PhoneNumberFormField`: an international phone number form field with a searchable dial
  code prefix selector and full `Form`/`TextFormField` integration.
* `PhoneNumberState` value type (`rawText`, `e164`, `regionCode`, `isValid`) reported
  through `onPhoneNumberChanged`, plus `PhoneNumberState.empty()` and
  `PhoneNumberState.fromPhoneNumber()` for prepopulating the field.
* E.164 parsing and validation through `dlibphonenumber`, with localized example numbers
  per country.
* `AsYouTypePhoneNumberFormatter` and other stable widget keys exposed for integration
  and widget tests.
* Built on `material_ui`, the official Flutter Material library.

