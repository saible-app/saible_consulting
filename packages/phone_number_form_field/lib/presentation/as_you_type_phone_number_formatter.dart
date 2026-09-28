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

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      onFormatFinished?.call('');
      return newValue;
    }

    final AsYouTypeFormatter formatter = phoneUtil.getAsYouTypeFormatter(country.alpha2);
    String formattedText = '';

    // Feed digits into AsYouTypeFormatter
    for (final rune in newValue.text.runes) {
      final char = String.fromCharCode(rune);
      if (RegExp(r'\d').hasMatch(char)) {
        formattedText = formatter.inputDigit(char);
      }
    }

    // Trigger callback with the updated formatted text
    onFormatFinished?.call(formattedText);

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
