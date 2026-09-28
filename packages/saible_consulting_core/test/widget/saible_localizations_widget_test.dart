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

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:saible_consulting_core/saible_consulting_core.dart';

void main() {
  test('SaibleLocalizations lists every delegate type exactly once', () {
    final delegateTypes = SaibleLocalizations.localizationsDelegates
        .map((delegate) => delegate.type)
        .toList();

    // Duplicate delegate types in a single list are ambiguous for Localizations,
    // so the list is deliberately free of the legacy globals that
    // CountryLocalizations.localizationsDelegates bundles.
    expect(delegateTypes.toSet().length, delegateTypes.length);
    expect(delegateTypes.first, CountryLocalizations);
    expect(
      delegateTypes,
      containsAll(GlobalMaterialLocalizations.delegates.map((delegate) => delegate.type)),
    );
  });

  test('SaibleLocalizations re-exports the supported locales', () {
    expect(SaibleLocalizations.supportedLocales, CountryLocalizations.supportedLocales);
    expect(SaibleLocalizations.supportedLocales.length, 40);
  });

  testWidgets('SaibleLocalizations delegates resolve material_ui strings for a supported locale', (tester) async {
    late MaterialLocalizations materialLocalizations;
    late CountryLocalizations countryLocalizations;

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('de'),
        supportedLocales: SaibleLocalizations.supportedLocales,
        localizationsDelegates: SaibleLocalizations.localizationsDelegates,
        home: Builder(
          builder: (context) {
            materialLocalizations = MaterialLocalizations.of(context);
            countryLocalizations = CountryLocalizations.of(context);
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Country names come from this package...
    expect(countryLocalizations.country_GB, 'Vereinigtes Königreich');
    // ...while Material-owned strings come from material_ui's delegates, which
    // the legacy flutter_localizations delegates in
    // CountryLocalizations.localizationsDelegates would never satisfy.
    expect(materialLocalizations.cancelButtonLabel, 'Abbrechen');
  });
}
