// Copyright 2026 Saible Ltd
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:material_ui/material_ui.dart';
import 'package:saible_consulting_core/l10n/app_localizations.dart';

/// The localization plumbing a `material_ui` application needs to render the
/// saible_consulting widgets in every supported language.
///
/// The generated [CountryLocalizations.localizationsDelegates] pairs the country
/// delegate with the *legacy* `package:flutter_localizations` Material,
/// Cupertino and Widgets delegates. Widgets built on `material_ui` never look
/// those types up: they resolve `material_ui`'s `MaterialLocalizations`,
/// `cupertino_ui`'s `CupertinoLocalizations` and the shared
/// `WidgetsLocalizations`. [localizationsDelegates] therefore pairs
/// [CountryLocalizations.delegate] with [GlobalMaterialLocalizations.delegates]
/// from `material_ui`, which provides all three for the same locales. Without
/// it, Material-owned strings (dialog buttons, text selection toolbars, and so
/// on) silently fall back to English even when the country names are localized.
///
/// ```dart
/// import 'package:material_ui/material_ui.dart';
/// import 'package:saible_consulting_core/saible_consulting_core.dart';
///
/// MaterialApp(
///   supportedLocales: SaibleLocalizations.supportedLocales,
///   localizationsDelegates: SaibleLocalizations.localizationsDelegates,
///   home: const MyFormPage(),
/// );
/// ```
///
/// If part of your tree is still built with `package:flutter/material.dart`,
/// list the legacy delegates as well (e.g. append
/// [CountryLocalizations.localizationsDelegates]) or wrap that subtree in
/// `MaterialUiCompatibilityBridge` from `material_ui`.
abstract final class SaibleLocalizations() {
  /// Creates a [SaibleLocalizations] namespace.
  ///
  /// The class only exposes static members, so instances carry no state.
  this;

  /// The [LocalizationsDelegate]s an app on `material_ui` needs to use these
  /// packages: the country strings of [CountryLocalizations] plus `material_ui`'s
  /// Material, Cupertino and Widgets delegates.
  ///
  /// Unlike [CountryLocalizations.localizationsDelegates] this list contains no
  /// duplicate delegate types, so it can be spread into `MaterialApp` alongside
  /// other delegate lists without ambiguity.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    CountryLocalizations.delegate,
    ...GlobalMaterialLocalizations.delegates,
  ];

  /// The locales that [localizationsDelegates] - and every saible_consulting
  /// widget - is translated for, re-exported from [CountryLocalizations].
  static const List<Locale> supportedLocales = CountryLocalizations.supportedLocales;
}
