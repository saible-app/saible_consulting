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

import 'package:collection/collection.dart';
import 'package:dlibphonenumber/dlibphonenumber.dart';
import 'package:material_ui/material_ui.dart';
import 'package:phone_number_form_field/application/phone_util.dart';
import 'package:phone_number_form_field/domain/phone_number.dart';
import 'package:phone_number_form_field/presentation/as_you_type_phone_number_formatter.dart';
import 'package:provider/provider.dart';
import 'package:saible_consulting_core/saible_consulting_core.dart';

String? _getE164Number(String rawValue, Iso3166Country country) {
  if (rawValue.isEmpty) return null;
  try {
    final PhoneNumber phoneNumber = phoneUtil.parse(rawValue, country.alpha2);
    if (phoneUtil.isValidNumber(phoneNumber)) {
      return phoneUtil.format(phoneNumber, PhoneNumberFormat.e164);
    }
  } catch (_) {
    return null;
  }
  
  return null;
}

class const _PhoneNumberField({
  this.focusNode,
  this.decoration,
  this.initialValue,
  this.onPhoneNumberChanged,
}) extends StatefulWidget {
  final FocusNode? focusNode;
  final InputDecoration? decoration;
  final ValueChanged<PhoneNumberState>? onPhoneNumberChanged;
  final PhoneNumberState? initialValue;

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
              PhoneNumberState(
                rawText: value,
                e164: e164Result,
                regionCode: '+${_selectedCountry.phoneCode}',
              ),
            );
          },
        ),
      ],
      decoration: (widget.decoration ?? const InputDecoration()).copyWith(
        hintText: _selectedCountry.examplePhoneNumberWithoutTrunk(),
        errorMaxLines: widget.decoration?.errorMaxLines ?? 2,
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
                        PhoneNumberState(rawText: '', e164: null, regionCode: '+${result.phoneCode}'),
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

/// A form field widget for inputting international phone numbers with country code selection and validation.
class const PhoneNumberFormField({
  super.key,
  this.focusNode,
  this.initialValue,
  this.decoration,
  this.onPhoneNumberChanged,
}) extends StatelessWidget {
  /// Creates a [PhoneNumberFormField].
  this;

  /// The [Key] for the country search anchor prefix icon button.
  static const Key countrySearchAnchorKey = Key('phoneNumberTextField_searchAnchor');

  /// The [Key] for the phone number text input search/entry field.
  static const Key countrySearchBarKey = Key('phoneNumberTextField_searchBar');

  /// Generates a [Key] for a country suggestion tile based on the country's alpha2 code.
  static Key countrySuggestionKey(Iso3166Country country) => Key(
    'phoneNumberTextField_country_${country.alpha2}'
  );

  /// An optional [FocusNode] to control the focus of the text input.
  final FocusNode? focusNode;

  /// The decoration applied to the underlying [TextFormField].
  final InputDecoration? decoration;

  /// Callback invoked when the phone number input changes or country selection changes.
  final ValueChanged<PhoneNumberState>? onPhoneNumberChanged;

  /// An optional initial value to populate the field with.
  final PhoneNumberState? initialValue;
  @override
  Widget build(BuildContext context) => CountriesProvider(child: _PhoneNumberField(
    focusNode: focusNode,
    initialValue: initialValue,
    decoration: decoration,
    onPhoneNumberChanged: onPhoneNumberChanged,
  ));
}
