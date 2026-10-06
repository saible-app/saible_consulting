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

import 'package:flutter/scheduler.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:saible_consulting_core/application/text_search_item.dart';
import 'package:saible_consulting_core/domain/iso3166_countries.dart';
import 'package:saible_consulting_core/presentation/countries_provider.dart';
import 'package:saible_consulting_core/presentation/nation_tile.dart';

class const _DefaultSuffix({
  this.country
}) extends StatelessWidget {
  final Iso3166Country? country;

  @override
  Widget build(BuildContext context) {
    final country = this.country;
    if (country == null) return const Icon(Icons.language);
    return Padding(
      padding: const EdgeInsets.all(8),
      child: FlagIcon.forIso3166(country: country),
    );
  }
}

class const _CountryPicker({
  required this.onCountryPicked,
  this.initial,
  this.decoration,
  this.focusNode,
  this.validator,
  this.onSaved,
}) extends StatefulWidget {
  static Key countrySuggestionKey(Iso3166Country country) => Key('countryPicker_country_${country.alpha2}');
  final void Function(Iso3166Country country) onCountryPicked;
  final Iso3166Country? initial;
  final InputDecoration? decoration;
  final FocusNode? focusNode;
  final String? Function(Iso3166Country? country)? validator;
  final void Function(Iso3166Country? country)? onSaved;

  @override
  State<_CountryPicker> createState() => _CountryPickerState();
}

class _CountryPickerState() extends State<_CountryPicker> {
  late final SearchController controller;
  Iso3166Country? chosenCountry;
  Locale? _lastLocale;

  @override
  void initState() {
    super.initState();
    controller = SearchController();
    // The initial display text is seeded in didChangeDependencies, which runs
    // immediately after initState with a fully mounted context; localization
    // lookups are not legal in initState itself.
    chosenCountry = widget.initial;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = Localizations.maybeLocaleOf(context);
    // isOpen asserts that the controller is attached to a SearchAnchor, which
    // it is not during the first pass, so isAttached is checked first.
    if (locale == _lastLocale || (controller.isAttached && controller.isOpen)) return;
    _lastLocale = locale;
    // The controller text is a pure presentation of the selection, so it is
    // re-derived whenever the ambient locale changes (e.g. the user switches
    // the app language and "United Kingdom" becomes "Vereinigtes Königreich").
    SchedulerBinding.instance.addPostFrameCallback((_) {
      controller.text = chosenCountry?.tr(context) ?? '';
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchTerms = context.watch<Countries>().searchTerms;
    // Built once per rebuild (not per keystroke) since the search terms
    // are stable for the current locale.
    final textSearch = TextSearch(searchTerms);
    return SearchAnchor(
      key: CountryPickerFormField.countrySearchAnchorKey,
      searchController: controller,
      builder: (context, controller) => TextFormField(
        focusNode: widget.focusNode,
        key: CountryPickerFormField.countrySearchBarKey,
        controller: controller,
        onTap: () => controller.openView(),
        onChanged: (_) => controller.openView(),
        // Typed form integration: the enclosing Form validates and saves the
        // chosen country rather than the search text.
        validator: (_) => widget.validator?.call(chosenCountry),
        onSaved: (_) => widget.onSaved?.call(chosenCountry),
        decoration: (widget.decoration ?? const InputDecoration()).copyWith(
          errorMaxLines: widget.decoration?.errorMaxLines ?? 2,
          suffixIcon: widget.decoration?.suffixIcon ?? _DefaultSuffix(country: chosenCountry),
        ),
      ),
      viewOnClose: () {
        controller.text = chosenCountry?.tr(context) ?? '';
      },
      suggestionsBuilder: (context, controller) {
        final results = textSearch.fastSearch(controller.text, limit: 12);
        return [
          for (final result in results)
            NationTile(
              key: _CountryPicker.countrySuggestionKey(result),
              country: result,
              onTap: () {
                setState(() { chosenCountry = result; });
                controller.closeView(result.tr(context));
                widget.onCountryPicked(result);
              },
            ),
        ];
      },
    );
  }
}

/// A form field widget that allows selecting a country using a searchable view.
class const CountryPickerFormField({
  super.key,
  this.decoration,
  required this.onCountryPicked,
  this.initial,
  this.focusNode,
  this.validator,
  this.onSaved,
}) extends StatelessWidget {
  /// The [Key] for the country search anchor view.
  static const Key countrySearchAnchorKey = Key('countryPicker_searchAnchor');

  /// The [Key] for the country search bar field.
  static const Key countrySearchBarKey = Key('countryPicker_searchBar');

  /// Creates a [CountryPickerFormField].
  this;

  /// The decoration applied to the underlying [TextFormField].
  /// 
  /// This offers rich customisation for your form input (e.g. labels, hints, error descriptions).
  /// If you provide a suffix icon, that will override the default suffix icon we have provided,
  /// but that won't break the underlying implementation.
  final InputDecoration? decoration;

  /// Callback invoked when a country is selected.
  final void Function(Iso3166Country country) onCountryPicked;

  /// The initially selected country, if any.
  final Iso3166Country? initial;

  /// An optional [FocusNode] to control the focus of the field.
  final FocusNode? focusNode;

  /// Validates the chosen country whenever the enclosing [Form] validates, e.g.
  /// through `Form.validate()` or a form-level [AutovalidateMode]. The value is
  /// the selected [Iso3166Country], or `null` while nothing is selected. Return
  /// `null` when the selection is acceptable.
  ///
  /// ```dart
  /// CountryPickerFormField(
  ///   decoration: const InputDecoration(labelText: 'Nationality'),
  ///   onCountryPicked: (country) => setState(() => _country = country),
  ///   validator: (country) => country == null ? 'Select a country' : null,
  ///   onSaved: (country) => _savedCountry = country,
  /// )
  /// ```
  final String? Function(Iso3166Country? country)? validator;

  /// Callback invoked with the chosen country (or `null`) when the enclosing
  /// [Form] saves, i.e. through `Form.save()`.
  final void Function(Iso3166Country? country)? onSaved;

  @override
  Widget build(BuildContext context) => CountriesProvider(child: _CountryPicker(
    decoration: decoration, 
    onCountryPicked: onCountryPicked,
    initial: initial,
    focusNode: focusNode,
    validator: validator,
    onSaved: onSaved,
  ));
}
