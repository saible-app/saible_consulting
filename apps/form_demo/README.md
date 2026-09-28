# Form Demo Application (`form_demo`)

A lightweight Flutter demonstration application showcasing the Saible Consulting form field package suite:
- [`saible_consulting_core`](../../packages/saible_consulting_core)
- [`date_picker_form_field`](../../packages/date_picker_form_field)
- [`country_picker_form_field`](../../packages/country_picker_form_field)
- [`phone_number_form_field`](../../packages/phone_number_form_field)

---

## What This Demo Demonstrates

The application presents a user registration form implementing clean architecture and enterprise form validation patterns:

1. **Date of Birth (`DatePickerFormField`)**:
   - Supports keyboard input formatted to the active locale (`DD/MM/YYYY`, `MM/DD/YYYY`, or `YYYY-MM-DD`).
   - Integrated calendar popup dialog.
   - Comprehensive validation checks: required, invalid date, date before minimum boundary (1900-01-01), and underage restriction (minimum age 18).
2. **Nationality (`CountryPickerFormField`)**:
   - Searchable country dropdown covering 249 ISO 3166-1 countries.
   - Instant fuzzy search matching country name, ISO-2 / ISO-3 codes, and localized aliases.
   - Flag emoji indicators.
3. **Phone Number (`PhoneNumberFormField`)**:
   - Interactive international dial code prefix selector with search view.
   - As-you-type formatting tailored to the selected country's conventions.
   - E.164 phone validation via Google `libphonenumber` bindings (`dlibphonenumber`).
4. **Dynamic Language Switcher**:
   - Seamlessly switch between English, French, German, Welsh, and Japanese on the fly.
   - Fully translates form labels, hint formats, errors, buttons, and country names in real time.
5. **State Management & Architecture**:
   - State managed with `flutter_bloc` (`RegistrationFormBloc`) and `formz` (`FormzInput` models for each field).
   - Reactive submit button enabled only when all fields satisfy validation rules.
   - Submitting the form displays a confirmation `SnackBar` summarizing the validated user inputs.

---

## Running the Demo

### Prerequisites

- Flutter SDK version `3.13.2` or later.
- Dart SDK `3.13.2` or later.

### From Root Workspace

You can run the demo directly from the root repository or inside `apps/form_demo`:

```bash
cd apps/form_demo
flutter pub get
flutter run
```

Or target specific platforms:

```bash
# macOS desktop
flutter run -d macos

# Chrome web
flutter run -d chrome

# Connected mobile device / emulator
flutter run -d <device-id>
```

---

## Running Tests

The application includes an end-to-end widget test suite verifying rendering, language switching, validation triggers, calendar pickers, country selection, and form submission:

```bash
cd apps/form_demo
flutter test
```

To run with coverage:

```bash
flutter test --coverage
```

---

## Architecture Overview

```text
apps/form_demo/lib/
├── application/
│   ├── country_input_state.dart         # Formz input model for country selection
│   ├── date_input_state.dart            # Formz input model for date of birth (with age 18+ validation)
│   ├── phone_number_input_state.dart    # Formz input model for phone number
│   ├── registration_form_bloc.dart      # Bloc coordinating form input events & state
│   ├── registration_form_event.dart     # Form events (DateOfBirthChanged, NationalityChanged, etc.)
│   └── registration_form_state.dart     # Unified immutable form state
├── presentation/
│   ├── language_menu.dart               # Language selection popup menu
│   ├── registration_form.dart           # Form layout, inputs, and submission action
│   └── theme.dart                       # Custom Saible design system & dark theme
└── main.dart                            # Entrypoint & localization provider wiring
```

