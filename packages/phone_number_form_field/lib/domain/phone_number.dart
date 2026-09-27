import 'package:dlibphonenumber/dlibphonenumber.dart';
import 'package:phone_number_form_field/application/phone_util.dart';
import 'package:saible_core/domain/iso3166_countries.dart';

/// Default two-letter ISO 3166-1 alpha-2 region code used when none is provided.
const defaultRegionCode = 'GB';

/// Formatting utilities on [PhoneNumber].
extension FormatUtils on PhoneNumber {
  /// Returns the phone number formatted internationally without the trunk/country code prefix.
  String internationalFormatWithoutTrunk() {
    final String intlFormatted = phoneUtil.format(this, PhoneNumberFormat.international);
    final String countryCodePrefix = '+$countryCode';
    return intlFormatted.replaceFirst(countryCodePrefix, '').trim();
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
