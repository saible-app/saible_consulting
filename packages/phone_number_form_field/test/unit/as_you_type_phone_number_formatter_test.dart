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
import 'package:phone_number_form_field/presentation/as_you_type_phone_number_formatter.dart';
import 'package:saible_consulting_core/saible_consulting_core.dart';

TextEditingValue _type(String text, Iso3166Country country, {List<String>? formatted}) {
  final collected = formatted ?? <String>[];
  final formatter = AsYouTypePhoneNumberFormatter(
    country: country,
    onFormatFinished: collected.add,
  );
  return formatter.formatEditUpdate(
    TextEditingValue.empty,
    TextEditingValue(text: text),
  );
}

void main() {
  group('AsYouTypePhoneNumberFormatter', () {
    test('formats UK national significant number stripping the trunk code', () {
      final result = _type('2079460123', Iso3166Country.unitedKingdom);
      expect(result.text, '20 7946 0123');
      expect(result.selection.isCollapsed, isTrue);
      expect(result.selection.baseOffset, result.text.length);
    });

    test('strips a typed UK trunk prefix and formats identically', () {
      final result = _type('02079460123', Iso3166Country.unitedKingdom);
      expect(result.text, '20 7946 0123');
    });

    test('formats progressively while typing a UK number', () {
      var result = _type('2', Iso3166Country.unitedKingdom);
      expect(result.text, '2');
      result = _type('20', Iso3166Country.unitedKingdom);
      expect(result.text, '20');
      result = _type('207', Iso3166Country.unitedKingdom);
      expect(result.text, '20 7');
      result = _type('207946', Iso3166Country.unitedKingdom);
      expect(result.text, '20 7946');
      result = _type('2079460', Iso3166Country.unitedKingdom);
      expect(result.text, '20 7946 0');
    });

    test('formats US national significant number stripping the trunk code', () {
      final result = _type('2015550123', Iso3166Country.unitedStates);
      expect(result.text, '(201) 555-0123');
    });

    test('strips a typed US trunk prefix ("1") and formats identically', () {
      final result = _type('12015550123', Iso3166Country.unitedStates);
      expect(result.text, '(201) 555-0123');
    });

    test('formats French mobile number without the trunk code', () {
      final result = _type('612345678', Iso3166Country.france);
      expect(result.text, '6 12 34 56 78');

      final withTrunk = _type('0612345678', Iso3166Country.france);
      expect(withTrunk.text, '6 12 34 56 78');
    });

    test('empty input is passed through and reported via onFormatFinished', () {
      final formatted = <String>[];
      final formatter = AsYouTypePhoneNumberFormatter(
        country: Iso3166Country.unitedKingdom,
        onFormatFinished: formatted.add,
      );
      final result = formatter.formatEditUpdate(
        const TextEditingValue(text: '2'),
        TextEditingValue.empty,
      );
      expect(result.text, isEmpty);
      expect(formatted, ['']);
    });

    test('input containing only the trunk prefix is cleared', () {
      final formatted = <String>[];
      final formatter = AsYouTypePhoneNumberFormatter(
        country: Iso3166Country.unitedKingdom,
        onFormatFinished: formatted.add,
      );
      final result = formatter.formatEditUpdate(
        TextEditingValue.empty,
        const TextEditingValue(text: '0'),
      );
      expect(result.text, isEmpty);
      expect(formatted, ['']);
    });

    test('non-digit characters are ignored when formatting', () {
      final result = _type('20 7946-0123', Iso3166Country.unitedKingdom);
      expect(result.text, '20 7946 0123');
    });

    test('onFormatFinished receives the formatted text', () {
      final formatted = <String>[];
      _type('2079460123', Iso3166Country.unitedKingdom, formatted: formatted);
      expect(formatted, ['20 7946 0123']);
    });
  });
}
