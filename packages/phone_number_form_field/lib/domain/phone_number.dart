import 'package:dlibphonenumber/dlibphonenumber.dart';
import 'package:saible_core/domain/iso3166_countries.dart';

const defaultRegionCode = 'GB';

final phoneUtil = PhoneNumberUtil.instance;

extension FormatUtils on PhoneNumber {
  String internationalFormatWithoutTrunk() {
    final String intlFormatted = phoneUtil.format(this, PhoneNumberFormat.international);
    final String countryCodePrefix = '+$countryCode';
    return intlFormatted.replaceFirst(countryCodePrefix, '').trim();
  }
}

class const PhoneNumberInputs({required this.rawText, required this.e164, required this.regionCode}) {
  final String rawText;
  final String? e164;
  final String regionCode;
  const PhoneNumberInputs.empty() : this(rawText: '', e164: null, regionCode: defaultRegionCode);
  PhoneNumberInputs.fromPhoneNumber(PhoneNumber phoneNumber) : this(
    rawText: phoneNumber.internationalFormatWithoutTrunk(),
    e164: phoneUtil.format(phoneNumber, PhoneNumberFormat.e164),
    regionCode: '+${phoneNumber.countryCode}',
  );

  bool get isEmpty => rawText.isEmpty;
  bool get isNotEmpty => !isEmpty;
  bool get isValid => e164 != null;
}

extension PhoneExtension on Iso3166Country {
  String? examplePhoneNumberWithoutTrunk() => phoneUtil.getExampleNumber(alpha2)?.internationalFormatWithoutTrunk();
}
