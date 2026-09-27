import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:saible_core/saible_core.dart';

/// Precomputed country lists and search terms for lookup and telephone filtering.
typedef Countries = ({
  List<Iso3166Country> countries,
  List<TextSearchItem<Iso3166Country>> searchTerms,
  List<TextSearchItem<Iso3166Country>> phoneSearchTerms,
});

/// Injects localized [Countries] data into the widget tree via [Provider].
class const CountriesProvider({super.key, required this.child}) extends StatelessWidget {
  /// The widget below this provider in the tree.
  final Widget child;

  /// Creates a [CountriesProvider] that provides country metadata to [child].
  this;

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<CountryLocalizations>();
    final countries = [...Iso3166Country.values]..sort((x, y) => x.tr(locale).compareTo(y.tr(locale)));
    return Provider<Countries>.value(
      value: (
        countries: countries,
        searchTerms: countries.map((e) => TextSearchItem.fromTerms(e, e.searchTerms(locale))).toList(),
        phoneSearchTerms: countries.map((e) => TextSearchItem.fromTerms(e, e.phoneSearchTerms(locale))).toList(),
      ),
      child: child,
    );
  }
}
