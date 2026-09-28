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

import 'package:country_picker_form_field/country_picker_form_field.dart';
import 'package:material_ui/material_ui.dart';
import 'package:saible_consulting_core/saible_consulting_core.dart';

/// Runs the `country_picker_form_field` example application.
void main() => runApp(const CountryPickerExampleApp());

/// Root widget, configured with the `saible_consulting_core` localizations,
/// including `material_ui`'s Material, Cupertino and Widgets delegates.
class const CountryPickerExampleApp({super.key}) extends StatelessWidget {
  /// Creates a [CountryPickerExampleApp].
  this;

  @override
  Widget build(BuildContext context) => const MaterialApp(
    supportedLocales: SaibleLocalizations.supportedLocales,
    localizationsDelegates: SaibleLocalizations.localizationsDelegates,
    home: CountryPickerExamplePage(),
  );
}

/// A form page that captures the user's nationality.
class const CountryPickerExamplePage({super.key}) extends StatefulWidget {
  /// Creates a [CountryPickerExamplePage].
  this;

  @override
  State<CountryPickerExamplePage> createState() =>
      _CountryPickerExamplePageState();
}

class _CountryPickerExamplePageState() extends State<CountryPickerExamplePage> {
  Iso3166Country? _nationality;

  @override
  Widget build(BuildContext context) {
    final Iso3166Country? nationality = _nationality;
    return Scaffold(
      appBar: AppBar(title: const Text('country_picker_form_field')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CountryPickerFormField(
              initial: Iso3166Country.unitedKingdom,
              decoration: const InputDecoration(
                labelText: 'Nationality',
                hintText: 'Search by name, ISO code or dial code',
                border: OutlineInputBorder(),
              ),
              onCountryPicked: (Iso3166Country country) =>
                  setState(() => _nationality = country),
            ),
            const SizedBox(height: 24),
            Text(
              nationality == null
                  ? 'No country selected yet.'
                  : '${nationality.flagEmoji()} '
                        '${nationality.tr(context)} (${nationality.alpha2})',
            ),
          ],
        ),
      ),
    );
  }
}
