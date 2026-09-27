import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:saible_core/application/text_search_item.dart';
import 'package:saible_core/domain/iso3166_countries.dart';
import 'package:saible_core/l10n/app_localizations.dart';
import 'package:saible_core/presentation/countries_provider.dart';
import 'package:saible_core/presentation/nation_tile.dart';

class const _CountryPicker({
  required this.onCountryPicked,
  this.initial,
  this.decoration,
  this.focusNode,
}) extends StatefulWidget {
  static Key countrySuggestionKey(Iso3166Country country) => Key('countryPicker_country_${country.alpha2}');
  final void Function(Iso3166Country country) onCountryPicked;
  final Iso3166Country? initial;
  final InputDecoration? decoration;
  final FocusNode? focusNode;

  @override
  State<_CountryPicker> createState() => _CountryPickerState();
}

class _CountryPickerState() extends State<_CountryPicker> {
  late final SearchController controller;
  Iso3166Country? chosenCountry;

  @override
  void initState() {
    super.initState();
    controller = SearchController();
    final initial = widget.initial;
    final locale = context.read<CountryLocalizations>();
    if (initial != null) {
      controller.text = initial.tr(locale);
      chosenCountry = widget.initial;
    }
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
    final country = chosenCountry;
    return SearchAnchor(
      key: CountryPickerFormField.countrySearchAnchorKey,
      searchController: controller,
      builder: (context, controller) => TextFormField(
        focusNode: widget.focusNode,
        key: CountryPickerFormField.countrySearchBarKey,
        controller: controller,
        onTap: () => controller.openView(),
        onChanged: (_) => controller.openView(),
        decoration: (widget.decoration ?? const InputDecoration()).copyWith(
          suffixIcon: country == null
            ? const Icon(Icons.language)
            : Padding(
                padding: const EdgeInsets.all(8),
                child: FlagIcon.forIso3166(country: country),
              ),
        ),
      ),
      viewOnClose: () {
        final locale = context.read<CountryLocalizations>();
        controller.text = chosenCountry?.tr(locale) ?? '';
      },
      suggestionsBuilder: (context, controller) {
        final results = textSearch.fastSearch(controller.text, limit: 12);
        final locale = context.read<CountryLocalizations>();
        return [
          for (final result in results)
            NationTile(
              key: _CountryPicker.countrySuggestionKey(result),
              country: result,
              onTap: () {
                setState(() { chosenCountry = result; });
                controller.closeView(result.tr(locale));
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
  required this.decoration,
  required this.onCountryPicked,
  this.initial,
  this.focusNode,
}) extends StatelessWidget {
  /// The [Key] for the country search anchor view.
  static const Key countrySearchAnchorKey = Key('countryPicker_searchAnchor');

  /// The [Key] for the country search bar field.
  static const Key countrySearchBarKey = Key('countryPicker_searchBar');

  /// Creates a [CountryPickerFormField].
  this;

  /// The decoration applied to the underlying [TextFormField].
  final InputDecoration? decoration;

  /// Callback invoked when a country is selected.
  final void Function(Iso3166Country country) onCountryPicked;

  /// The initially selected country, if any.
  final Iso3166Country? initial;

  /// An optional [FocusNode] to control the focus of the field.
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) => CountriesProvider(child: _CountryPicker(
    decoration: decoration, 
    onCountryPicked: onCountryPicked,
    initial: initial,
    focusNode: focusNode,
  ));
}
