import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:saible_core/application/text_search_item.dart';
import 'package:saible_core/domain/iso3166_countries.dart';
import 'package:saible_core/saible_core.dart';

typedef Countries = ({
  List<Iso3166Country> countries,
  List<TextSearchItem<Iso3166Country>> searchTerms,
  List<TextSearchItem<Iso3166Country>> phoneSearchTerms,
});

class const CountriesProvider({super.key, required this.child}) extends StatelessWidget {
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final locale = context.watch<CountryLocalizations>();
    return Provider<Countries>(
      create: (context) {
        final countries = [...Iso3166Country.values]..sort((x, y) => x.tr(locale).compareTo(y.tr(locale)));
        final searchTerms = countries.map(
          (e) => TextSearchItem.fromTerms(e, e.searchTerms(locale))
        ).toList();
        final phoneSearchTerms = countries.map(
          (e) => TextSearchItem.fromTerms(e, e.phoneSearchTerms(locale))
        ).toList();
        return (countries: countries, searchTerms: searchTerms, phoneSearchTerms: phoneSearchTerms);
      },
      child: child,
    );
  }
}
