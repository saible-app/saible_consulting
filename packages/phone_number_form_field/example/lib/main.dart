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
import 'package:phone_number_form_field/phone_number_form_field.dart';
import 'package:saible_consulting_core/saible_consulting_core.dart';

/// Runs the `phone_number_form_field` example application.
void main() => runApp(const PhoneNumberExampleApp());

/// Root widget, configured with the `saible_consulting_core` localizations.
class const PhoneNumberExampleApp({super.key}) extends StatelessWidget {
  /// Creates a [PhoneNumberExampleApp].
  this;

  @override
  Widget build(BuildContext context) => const MaterialApp(
    supportedLocales: CountryLocalizations.supportedLocales,
    localizationsDelegates: CountryLocalizations.localizationsDelegates,
    home: PhoneNumberExamplePage(),
  );
}

/// A form page that captures a phone number and reports its E.164 form.
class const PhoneNumberExamplePage({super.key}) extends StatefulWidget {
  /// Creates a [PhoneNumberExamplePage].
  this;

  @override
  State<PhoneNumberExamplePage> createState() => _PhoneNumberExamplePageState();
}

class _PhoneNumberExamplePageState() extends State<PhoneNumberExamplePage> {
  PhoneNumberState _phoneNumber = const PhoneNumberState.empty();

  @override
  Widget build(BuildContext context) {
    final bool showError = _phoneNumber.isNotEmpty && !_phoneNumber.isValid;
    return Scaffold(
      appBar: AppBar(title: const Text('phone_number_form_field')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PhoneNumberFormField(
              initialValue: const PhoneNumberState(
                rawText: '20 7946 0123',
                e164: '+442079460123',
                regionCode: '+44',
              ),
              decoration: InputDecoration(
                labelText: 'Phone number',
                border: const OutlineInputBorder(),
                errorText: showError
                    ? 'Please enter a valid phone number'
                    : null,
              ),
              onPhoneNumberChanged: (PhoneNumberState state) =>
                  setState(() => _phoneNumber = state),
            ),
            const SizedBox(height: 24),
            Text('E.164: ${_phoneNumber.e164 ?? 'not a valid number yet'}'),
            Text('Dial code: ${_phoneNumber.regionCode}'),
            Text('Valid: ${_phoneNumber.isValid}'),
          ],
        ),
      ),
    );
  }
}
