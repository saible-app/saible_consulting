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

  });
}
