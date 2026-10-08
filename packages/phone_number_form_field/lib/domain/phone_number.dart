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

import 'package:dlibphonenumber/dlibphonenumber.dart';
import 'package:phone_number_form_field/application/phone_util.dart';
import 'package:saible_consulting_core/saible_consulting_core.dart';

/// Default two-letter ISO 3166-1 alpha-2 region code used when none is provided.
const defaultRegionCode = 'GB';

/// Formatting utilities on [PhoneNumber].
extension FormatUtils on PhoneNumber {
  /// Returns the phone number formatted the way this package renders it inside
  /// the field: the region's national format with its national (trunk) prefix
  /// removed, e.g. `(201) 555-0123` for `+12015550123` or `20 7946 0123` for
  /// `+442079460123`.
  ///
  /// This deliberately mirrors the output of `AsYouTypePhoneNumberFormatter`
  /// rather than the international format, so that initial values, example
  /// hints and as-you-type input all display identically.
  String internationalFormatWithoutTrunk() {
    final String nationalFormatted = phoneUtil.format(this, PhoneNumberFormat.national);
    final String? regionCode = phoneUtil.getRegionCodeForNumber(this);
    final String? nationalPrefix =
        regionCode == null ? null : phoneUtil.getNddPrefixForRegion(regionCode, true);
    if (nationalPrefix == null || nationalPrefix.isEmpty) return nationalFormatted;
    return nationalFormatted.replaceFirst(RegExp('^$nationalPrefix\\s?'), '');
  }
}

/// Represents the current input and parsing state of a phone number field.
class const PhoneNumberState({required this.rawText, required this.e164, required this.regionCode}) {
  /// Creates a [PhoneNumberState].
  this;

  /// The unformatted or user-typed raw text of the phone number.
  final String rawText;

  /// The parsed international E.164 representation of the phone number, or null if invalid or incomplete.
  final String? e164;

  /// The dial code / country calling code prefix (e.g. `+44`).
  final String regionCode;

  /// Creates an empty [PhoneNumberState] with the default region code.
  const PhoneNumberState.empty() : this(rawText: '', e164: null, regionCode: defaultRegionCode);

  /// Creates a [PhoneNumberState] from an existing [PhoneNumber].
  PhoneNumberState.fromPhoneNumber(PhoneNumber phoneNumber) : this(
    rawText: phoneNumber.internationalFormatWithoutTrunk(),
    e164: phoneUtil.format(phoneNumber, PhoneNumberFormat.e164),
    regionCode: '+${phoneNumber.countryCode}',
  );

  /// Whether the raw text input is empty.
  bool get isEmpty => rawText.isEmpty;

  /// Whether the raw text input is not empty.
  bool get isNotEmpty => !isEmpty;

  /// Whether the phone number parsed to a valid E.164 number.
  bool get isValid => e164 != null;
}

/// Phone-related extensions on [Iso3166Country].
extension PhoneExtension on Iso3166Country {
  /// Returns an example phone number for the country without the country calling code trunk.
  String? examplePhoneNumberWithoutTrunk() => phoneUtil.getExampleNumber(alpha2)?.internationalFormatWithoutTrunk();
}
