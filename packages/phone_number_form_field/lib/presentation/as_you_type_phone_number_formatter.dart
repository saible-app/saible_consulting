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
import 'package:flutter/services.dart';
import 'package:phone_number_form_field/application/phone_util.dart';
import 'package:saible_consulting_core/saible_consulting_core.dart';

/// A [TextInputFormatter] that uses dlibphonenumber's [AsYouTypeFormatter]
/// to format phone numbers in real-time as the user types.
class AsYouTypePhoneNumberFormatter({
  required this.country,
  this.onFormatFinished,
}) extends TextInputFormatter {
  /// Creates an [AsYouTypePhoneNumberFormatter].
  this;

  /// The [Iso3166Country] used to determine formatting rules (e.g. GB, US).
  final Iso3166Country country; // e.g., _selectedCountry.countryCode ('GB', 'US')

  /// Optional callback invoked whenever formatting finishes with the formatted text.
  final void Function(String formattedValue)? onFormatFinished;

  /// The national trunk prefix (national dialling prefix, e.g. `0` for GB or
  /// `1` for US) for [country], or `null` when the region has none.
  ///
  /// The prefix is stripped from user input so the field always works with
  /// the national significant number, mirroring how the number will be
  /// rendered with the country calling code prefix (e.g. `+44`).
  String? get _nationalTrunkPrefix {
    try {
      final String? prefix = phoneUtil.getNddPrefixForRegion(country.alpha2, true);
      return (prefix == null || prefix.isEmpty) ? null : prefix;
    } catch (_) {
      return null;
    }
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      onFormatFinished?.call('');
      return newValue;
    }

    final nationalTrunkPrefix = _nationalTrunkPrefix;
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    // Normalise to the national significant number by dropping a trunk
    // prefix the user may have typed (e.g. the leading `0` in `020 7946 0123`).
    var nationalDigits = digits;
    if (nationalTrunkPrefix != null && nationalDigits.startsWith(nationalTrunkPrefix)) {
      nationalDigits = nationalDigits.substring(nationalTrunkPrefix.length);
    }
    if (nationalDigits.isEmpty) {
      onFormatFinished?.call('');
      return TextEditingValue.empty;
    }

    final AsYouTypeFormatter formatter = phoneUtil.getAsYouTypeFormatter(country.alpha2);
    String formattedText = '';

    // Feed the trunk prefix first so dlibphonenumber applies the national
    // formatting template, then strip it from the output below.
    if (nationalTrunkPrefix != null) {
      for (final char in nationalTrunkPrefix.split('')) {
        formattedText = formatter.inputDigit(char);
      }
    }

    // Feed the national significant digits into AsYouTypeFormatter.
    for (final rune in nationalDigits.runes) {
      final char = String.fromCharCode(rune);
      if (RegExp(r'\d').hasMatch(char)) {
        formattedText = formatter.inputDigit(char);
      }
    }

    // Strip the trunk prefix (and any spacing it introduced) so the formatted
    // text matches the national significant number, e.g. `20 7946 0123`.
    if (nationalTrunkPrefix != null) {
      formattedText = formattedText.replaceFirst(RegExp('^$nationalTrunkPrefix\\s?'), '');
    }

    // Trigger callback with the updated formatted text
    onFormatFinished?.call(formattedText);

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
