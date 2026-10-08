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
import 'package:phone_number_form_field/application/phone_util.dart';
import 'package:phone_number_form_field/domain/phone_number.dart';
import 'package:phone_number_form_field/presentation/as_you_type_phone_number_formatter.dart';
import 'package:saible_consulting_core/saible_consulting_core.dart';

void main() {
  group('PhoneNumberState and FormatUtils', () {
    test('PhoneNumberState.empty initializes with default region code and empty rawText', () {
      const state = PhoneNumberState.empty();
      expect(state.rawText, '');
      expect(state.e164, isNull);
      expect(state.regionCode, defaultRegionCode);
      expect(state.isEmpty, isTrue);
      expect(state.isNotEmpty, isFalse);
      expect(state.isValid, isFalse);
    });

    test('PhoneNumberState.fromPhoneNumber creates valid state and FormatUtils formats without trunk', () {
      final parsed = phoneUtil.parse('+442079460123', 'GB');
      final state = PhoneNumberState.fromPhoneNumber(parsed);

      expect(state.rawText, '20 7946 0123');
      expect(state.e164, '+442079460123');
      expect(state.regionCode, '+44');
      expect(state.isEmpty, isFalse);
      expect(state.isNotEmpty, isTrue);
      expect(state.isValid, isTrue);
      expect(parsed.internationalFormatWithoutTrunk(), '20 7946 0123');
    });

    test('internationalFormatWithoutTrunk uses the national format for US numbers', () {
      // Standard reserved 555 fictional US number: +12015550123
      final parsed = phoneUtil.parse('+12015550123', 'US');

      // The international format would be `201-555-0123`; the field instead
      // renders the national style so initial values and typed input agree.
      expect(parsed.internationalFormatWithoutTrunk(), '(201) 555-0123');
    });

    test('PhoneNumberState.fromPhoneNumber formats US numbers in national style', () {
      final parsed = phoneUtil.parse('+12015550123', 'US');
      final state = PhoneNumberState.fromPhoneNumber(parsed);

      expect(state.rawText, '(201) 555-0123');
      expect(state.e164, '+12015550123');
      expect(state.regionCode, '+1');
      expect(state.isEmpty, isFalse);
      expect(state.isValid, isTrue);
    });

    test('internationalFormatWithoutTrunk matches the as-you-type formatter output', () {
      const cases = <String, Iso3166Country>{
        '+12015550123': Iso3166Country.unitedStates,
        '+442079460123': Iso3166Country.unitedKingdom,
        '+33612345678': Iso3166Country.france,
        '+81312345678': Iso3166Country.japan,
        '+61412345678': Iso3166Country.australia,
      };

      for (final entry in cases.entries) {
        final parsed = phoneUtil.parse(entry.key, null);
        final nationalSignificantNumber = phoneUtil.getNationalSignificantNumber(parsed);
        final typed = AsYouTypePhoneNumberFormatter(country: entry.value).formatEditUpdate(
          TextEditingValue.empty,
          TextEditingValue(text: nationalSignificantNumber),
        );

        expect(
          parsed.internationalFormatWithoutTrunk(),
          typed.text,
          reason: '${entry.key} should display identically to typed input',
        );
      }
    });

  });
}
