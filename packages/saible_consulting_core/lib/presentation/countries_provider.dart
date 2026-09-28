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

import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:saible_consulting_core/application/text_search_item.dart';
import 'package:saible_consulting_core/domain/iso3166_countries.dart';
import 'package:saible_consulting_core/l10n/app_localizations.dart';

/// Precomputed country lists and search terms for lookup and telephone filtering.
typedef Countries = ({
  List<Iso3166Country> countries,
  List<TextSearchItem<Iso3166Country>> searchTerms,
  List<TextSearchItem<Iso3166Country>> phoneSearchTerms,
});

class const _Provider({required this.child}) extends StatelessWidget {
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final countries = [...Iso3166Country.values]..sort((x, y) => x.tr(context).compareTo(y.tr(context)));
    return Provider<Countries>.value(
      value: (
        countries: countries,
        searchTerms: countries.map((e) => TextSearchItem.fromTerms(e, e.searchTerms(context))).toList(),
        phoneSearchTerms: countries.map((e) => TextSearchItem.fromTerms(e, e.phoneSearchTerms(context))).toList(),
      ),
      child: child,
    );
  }
}

/// Injects localized [Countries] data into the widget tree via [Provider].
class const CountriesProvider({super.key, required this.child}) extends StatelessWidget {
  /// The widget below this provider in the tree.
  final Widget child;

  /// Creates a [CountriesProvider] that provides country metadata to [child].
  this;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.maybeLocaleOf(context) ?? const Locale('en', 'GB');
    return Provider<CountryLocalizations>.value(
      value: lookupCountryLocalizations(locale),
      child: _Provider(child: child),
    );
  }
}
