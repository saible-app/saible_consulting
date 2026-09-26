import 'package:collection/collection.dart';
import 'package:dlibphonenumber/dlibphonenumber.dart';
import 'package:material_ui/material_ui.dart';
import 'package:phone_number_form_field/domain/phone_number.dart';
import 'package:phone_number_form_field/presentation/as_you_type_phone_number_formatter.dart';
import 'package:provider/provider.dart';
import 'package:saible_core/application/text_search_item.dart';
import 'package:saible_core/domain/iso3166_countries.dart';
import 'package:saible_core/l10n/app_localizations.dart';
import 'package:saible_core/presentation/countries_provider.dart';
import 'package:saible_core/presentation/nation_tile.dart';

String? _getE164Number(String rawValue, Iso3166Country country) {
  if (rawValue.isEmpty) return null;
  
  final phoneUtil = PhoneNumberUtil.instance;
  try {
    final PhoneNumber phoneNumber = phoneUtil.parse(rawValue, country.alpha2);
    if (phoneUtil.isValidNumber(phoneNumber)) {
      return phoneUtil.format(phoneNumber, PhoneNumberFormat.e164);
    }
  } catch (_) {
    // Return null if parsing fails or number is invalid/incomplete
  }
  return null;
}

class const _PhoneNumberField({
  this.focusNode,
  this.labelText,
  this.errorText,
  this.errorMaxLines,
  this.initialValue,
  this.onPhoneNumberChanged,
}) extends StatefulWidget {
  final FocusNode? focusNode;
  final String? labelText;
  final String? errorText;
  final int? errorMaxLines;
  final ValueChanged<PhoneNumberInputs>? onPhoneNumberChanged;
  final PhoneNumberInputs? initialValue;

  @override
  State<_PhoneNumberField> createState() => _PhoneNumberFieldState();
}

class _PhoneNumberFieldState() extends State<_PhoneNumberField> {
  final TextEditingController _controller = TextEditingController();
  Iso3166Country _selectedCountry = Iso3166Country.unitedKingdom;

  @override
  void initState() {
    super.initState();
    final initialValue = widget.initialValue;
    if (initialValue != null && initialValue.isNotEmpty) {
      final phoneNumber = phoneUtil.parse(initialValue.e164, null);
      final regionCode = phoneUtil.getRegionCodeForNumber(phoneNumber)?.toLowerCase();
      if (regionCode == null) return;
      final country = Iso3166Country.values.firstWhereOrNull((c) => c.alpha2.toLowerCase() == regionCode);
      if (country != null) {
        _selectedCountry = country;
        _controller.text = phoneUtil.getNationalSignificantNumber(phoneNumber);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final onPhoneNumberChanged = widget.onPhoneNumberChanged;
    final searchTerms = context.watch<Countries>().phoneSearchTerms;
    // Built once per rebuild (not per keystroke) since the search terms
    // are stable for the current locale.
    final textSearch = TextSearch(searchTerms);
    return TextFormField(
      key: PhoneNumberFormField.countrySearchBarKey,
      focusNode: widget.focusNode,
      controller: _controller,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        AsYouTypePhoneNumberFormatter(
          country: _selectedCountry,
          onFormatFinished: (value) {
            final String? e164Result = _getE164Number(value, _selectedCountry);
            onPhoneNumberChanged?.call(
              PhoneNumberInputs(
                rawText: value,
                e164: e164Result,
                regionCode: '+${_selectedCountry.phoneCode}',
              ),
            );
          },
        ),
      ],
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: _selectedCountry.examplePhoneNumberWithoutTrunk(),
        errorText: widget.errorText,
        errorMaxLines: widget.errorMaxLines,
        prefixIcon: SearchAnchor(
          key: PhoneNumberFormField.countrySearchAnchorKey,
          shrinkWrap: true,
          builder: (context, controller) => InkWell(
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_selectedCountry.flagEmoji(), style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 6),
                  Text('+${_selectedCountry.phoneCode}'),
                  const Icon(Icons.arrow_drop_down),
                  const SizedBox(width: 4),
                  // Vertical divider separating prefix control from text field
                  Container(height: 24, width: 1, color: Theme.of(context).colorScheme.outlineVariant),
                ],
              ),
            ),
          ),
          suggestionsBuilder: (context, controller) {
            final results = textSearch.fastSearch(controller.text, limit: 12);
            final locale = context.read<CountryLocalizations>();
            return [
              for (final result in results)
                PhoneCodeTile(
                  key: PhoneNumberFormField.countrySuggestionKey(result),
                  country: result,
                  onTap: () {
                    if (_selectedCountry != result) {
                      setState(() {
                        _selectedCountry = result;
                      });
                      _controller.text = '';
                      widget.onPhoneNumberChanged?.call(
                        PhoneNumberInputs(rawText: '', e164: null, regionCode: '+${result.phoneCode}'),
                      );
                    }
                    controller.closeView(result.tr(locale));
                  },
                ),
            ];
          },
        ),
      ),
    );
  }
}

class const PhoneNumberFormField({
  super.key,
  this.focusNode,
  this.labelText,
  this.errorText,
  this.errorMaxLines,
  this.initialValue,
  this.onPhoneNumberChanged,
}) extends StatelessWidget {
  static const Key countrySearchAnchorKey = Key('phoneNumberTextField_searchAnchor');
  static const Key countrySearchBarKey = Key('phoneNumberTextField_searchBar');
  static Key countrySuggestionKey(Iso3166Country country) => Key(
    'phoneNumberTextField_country_${country.alpha2}'
  );
  final FocusNode? focusNode;
  final String? labelText;
  final String? errorText;
  final int? errorMaxLines;
  final ValueChanged<PhoneNumberInputs>? onPhoneNumberChanged;
  final PhoneNumberInputs? initialValue;
  @override
  Widget build(BuildContext context) => CountriesProvider(child: _PhoneNumberField(
    focusNode: focusNode,
    labelText: labelText,
    errorText: errorText,
    errorMaxLines: errorMaxLines,
    initialValue: initialValue,
    onPhoneNumberChanged: onPhoneNumberChanged,
  ));
}
