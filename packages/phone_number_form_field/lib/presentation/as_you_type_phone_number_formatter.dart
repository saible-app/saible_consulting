import 'package:dlibphonenumber/dlibphonenumber.dart';
import 'package:flutter/services.dart';
import 'package:saible_core/domain/iso3166_countries.dart';

/// A [TextInputFormatter] that uses dlibphonenumber's [AsYouTypeFormatter]
/// to format phone numbers in real-time as the user types.

class AsYouTypePhoneNumberFormatter({
  required this.country,
  this.onFormatFinished,
}) extends TextInputFormatter {
  final Iso3166Country country; // e.g., _selectedCountry.countryCode ('GB', 'US')
  final void Function(String formattedValue)? onFormatFinished;

  final PhoneNumberUtil _phoneUtil = PhoneNumberUtil.instance;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      onFormatFinished?.call('');
      return newValue;
    }

    final AsYouTypeFormatter formatter = _phoneUtil.getAsYouTypeFormatter(country.alpha2);
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
