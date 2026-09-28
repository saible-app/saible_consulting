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

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_demo/application/registration_form_bloc.dart';
import 'package:form_demo/l10n/app_localizations.dart';
import 'package:form_demo/presentation/registration_form.dart';
import 'package:form_demo/presentation/theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:saible_consulting_core/saible_consulting_core.dart';

void main() {
  runApp(const DemoApp());
}

/// The root widget of the demo application.
class const DemoApp({super.key}) extends StatefulWidget {
  /// Creates the [DemoApp].
  this;

  @override
  State<DemoApp> createState() => _DemoAppState();
}

class _DemoAppState() extends State<DemoApp> {
  /// The locale chosen via the app bar language switcher; null falls back
  /// to the app's default language, British English.
  Locale? _locale;

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Saible Form Demo',
    locale: _locale ?? const Locale('en', 'GB'),
    theme: SaibleTheme().dark(),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: const [
      ...AppLocalizations.localizationsDelegates,
      ...CountryLocalizations.localizationsDelegates,
      ...GlobalMaterialLocalizations.delegates,
    ],
    home: BlocProvider<RegistrationFormBloc>(
      create: (context) => RegistrationFormBloc(),
      child: RegistrationForm(
        onLocaleChanged: (locale) => setState(() => _locale = locale),
      )
    ),
  );
}
