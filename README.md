# Saible Consulting Monorepo

A modular collection of enterprise-grade Flutter packages and form field widgets developed by Saible Consulting, alongside a comprehensive interactive demonstration application.

---

## Workspace Structure

This repository is organized as a Melos-managed Flutter/Dart workspace:

| Package / App | Path | Description |
|---|---|---|
| [`saible_core`](packages/saible_core) | `packages/saible_core` | ISO 3166-1 country data (249 countries), multi-lingual localizations, Jaro-Winkler fuzzy search, date utilities, and UI tile primitives. |
| [`country_picker_form_field`](packages/country_picker_form_field) | `packages/country_picker_form_field` | Searchable country selector form field with fuzzy search, flag emojis, and multi-lingual translations. |
| [`date_picker_form_field`](packages/date_picker_form_field) | `packages/date_picker_form_field` | Locale-aware date input field supporting both as-you-type formatting and calendar dialog selection. |
| [`phone_number_form_field`](packages/phone_number_form_field) | `packages/phone_number_form_field` | International telephone input field with searchable dial code prefix selector, as-you-type formatting, and E.164 validation. |
| [`form_demo`](apps/form_demo) | `apps/form_demo` | Production-ready reference application demonstrating form integration, `flutter_bloc`, `formz` validation, and real-time language switching. |

---

## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) `3.13.2` or later
- [Melos](https://melos.community/) `8.9.0` or later (`dart pub global activate melos`)

### Bootstrap Workspace

From the workspace root:

```bash
# Bootstrap dependencies across all packages
melos bootstrap
```

### Running the Demo Application

```bash
cd apps/form_demo
flutter run
```

Or from root:

```bash
melos exec --scope="form_demo" -- "flutter run"
```

---

## Testing & Code Coverage

Run tests with code coverage across all packages in the monorepo:

```bash
# Run tests and generate coverage traces
melos run test:coverage

# Merge, clean, and generate consolidated HTML coverage report
melos run coverage:report
```

Open `coverage/html/index.html` in your browser to inspect test coverage details.

---

## Code Quality & Analysis

```bash
# Analyze code across all packages
melos exec -- "flutter analyze"

# Format Dart source files
melos exec -- "dart format ."
```

---

## License

This repository is licensed under the MIT License. See [LICENSE](LICENSE) for details.
