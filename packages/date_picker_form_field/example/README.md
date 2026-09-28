# Example

A minimal application that demonstrates `date_picker_form_field`.

Everything lives in [`lib/main.dart`](lib/main.dart):

* `DatePickerFormField` with `initialDate`, `firstDate` and `lastDate` bounds,
  an `InputDecoration`, and an `onDateChanged` callback that receives the
  `DateInputValue` record (`parsedDate` plus the `rawText` as typed).
* `initializeDateFormatting()` called before `runApp`, so typed input is parsed
  with the date pattern of the active locale.
* A `StatefulWidget` that reports the parsed `DateTime` as soon as the typed
  date becomes complete and valid.

The example deliberately has no `pubspec.yaml` of its own: it is analyzed and
resolved with the dependencies of the package it ships inside. To run it, copy
[`lib/main.dart`](lib/main.dart) into a Flutter application that depends on
`date_picker_form_field`, `intl` and `material_ui`, and use it as the app
entrypoint.
