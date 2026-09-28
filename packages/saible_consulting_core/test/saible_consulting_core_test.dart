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

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:saible_consulting_core/application/jaro_winkler.dart';
import 'package:saible_consulting_core/saible_consulting_core.dart';

void main() {
  test('CountryLocalizations loads English and Welsh translations for ISO 3166 countries using ISO-2 keys', () async {
    final enLocalizations = await CountryLocalizations.delegate.load(const Locale('en', 'GB'));
    expect(enLocalizations.country_GB, 'United Kingdom');
    expect(enLocalizations.country_AF, 'Afghanistan');

    final cyLocalizations = await CountryLocalizations.delegate.load(const Locale('cy'));
    expect(cyLocalizations.country_GB, 'y Deyrnas Unedig');
    expect(cyLocalizations.country_AF, 'Affganistan');
  });

  test('Iso3166Country enum tr function looks up translations via CountryLocalizations', () async {
    final enLocalizations = await CountryLocalizations.delegate.load(const Locale('en', 'GB'));
    expect(Iso3166Country.unitedKingdom.tr(context), 'United Kingdom');
    expect(Iso3166Country.afghanistan.tr(enLocalizations), 'Afghanistan');

    final cyLocalizations = await CountryLocalizations.delegate.load(const Locale('cy'));
    expect(Iso3166Country.unitedKingdom.tr(cyLocalizations), 'y Deyrnas Unedig');
    expect(Iso3166Country.afghanistan.tr(cyLocalizations), 'Affganistan');
  });

  test('CountryLocalizations loads translations for common languages', () async {
    final esLocalizations = await CountryLocalizations.delegate.load(const Locale('es'));
    expect(Iso3166Country.unitedKingdom.tr(esLocalizations), 'Reino Unido');

    final frLocalizations = await CountryLocalizations.delegate.load(const Locale('fr'));
    expect(Iso3166Country.unitedKingdom.tr(frLocalizations), 'Royaume-Uni');

    final deLocalizations = await CountryLocalizations.delegate.load(const Locale('de'));
    expect(Iso3166Country.unitedKingdom.tr(deLocalizations), 'Vereinigtes Königreich');

    final zhLocalizations = await CountryLocalizations.delegate.load(const Locale('zh'));
    expect(Iso3166Country.unitedKingdom.tr(zhLocalizations), '英国');

    final jaLocalizations = await CountryLocalizations.delegate.load(const Locale('ja'));
    expect(Iso3166Country.unitedKingdom.tr(jaLocalizations), 'イギリス');

    final arLocalizations = await CountryLocalizations.delegate.load(const Locale('ar'));
    expect(Iso3166Country.unitedKingdom.tr(arLocalizations), 'المملكة المتحدة');
  });

  test('Iso3166Country enum elements have valid numeric phone codes', () {
    expect(Iso3166Country.unitedKingdom.phoneCode, 44);
    expect(Iso3166Country.unitedStates.phoneCode, 1);
    expect(Iso3166Country.afghanistan.phoneCode, 93);
    expect(Iso3166Country.france.phoneCode, 33);
    expect(Iso3166Country.germany.phoneCode, 49);

    for (final country in Iso3166Country.values) {
      expect(
        country.phoneCode,
        isPositive,
        reason: '${country.name} (${country.alpha2}) should have a positive phoneCode',
      );
    }
  });

  test('Iso3166Country enum tr function returns non-empty localized name for all countries', () async {
    final enLocalizations = await CountryLocalizations.delegate.load(const Locale('en', 'GB'));
    final cyLocalizations = await CountryLocalizations.delegate.load(const Locale('cy'));

    expect(Iso3166Country.values, isNotEmpty);
    expect(Iso3166Country.values.length, 249);

    for (final country in Iso3166Country.values) {
      final enTranslation = country.tr(enLocalizations);
      expect(
        enTranslation,
        isNotEmpty,
        reason: 'Country ${country.name} (${country.alpha2}) English translation should not be empty',
      );

      final cyTranslation = country.tr(cyLocalizations);
      expect(
        cyTranslation,
        isNotEmpty,
        reason: 'Country ${country.name} (${country.alpha2}) Welsh translation should not be empty',
      );
    }
  });

  test('CountryExtension methods generate valid flag emojis and search terms', () async {
    final enLoc = await CountryLocalizations.delegate.load(const Locale('en', 'GB'));

    for (final country in Iso3166Country.values) {
      final flag = country.flagEmoji();
      expect(flag, isNotEmpty, reason: '${country.name} flagEmoji should not be empty');

      final searchTerms = country.searchTerms(enLoc);
      expect(searchTerms, contains(country.alpha2));
      expect(searchTerms, contains(country.alpha3));
      expect(searchTerms, contains(country.tr(enLoc)));

      final phoneSearchTerms = country.phoneSearchTerms(enLoc);
      expect(phoneSearchTerms, contains(country.phoneCode.toString()));
      expect(phoneSearchTerms, contains('+${country.phoneCode}'));
    }

    const uk = Iso3166Country.unitedKingdom;
    expect(uk.flagEmoji(), '🇬🇧');
    expect(uk.searchTerms(enLoc), containsAll(['GB', 'GBR', 'United Kingdom']));
    expect(uk.phoneSearchTerms(enLoc), containsAll(['+44', '44']));
  });

  group('JaroWinkler', () {
    final jw = JaroWinkler();

    test('similarity is 1 for identical and 0 for disjoint strings', () {
      expect(jw.similarity('france', 'france'), 1);
      expect(jw.similarity('xyz', 'abc'), lessThan(0.4));
      expect(jw.similarity('', 'abc'), 0);
    });

    test('match window considers the longer string length', () {
      // With the historical window (based on the first string only) the
      // trailing 'k' could never match; using the maximum length lets it.
      final similarity = jw.similarity('uk', 'united kingdom');
      expect(similarity, greaterThan(0.7), reason: "'uk' should score highly against 'united kingdom'");
    });

    test('similarityUpperBound is never exceeded by actual similarity', () {
      const pairs = [
        ('fr', 'france'),
        ('uk', 'united kingdom'),
        ('de', 'germany'),
        ('kingdom', 'united kingdom'),
        ('abcd', 'ab'),
        ('xyz', 'united kingdom'),
      ];
      for (final (s1, s2) in pairs) {
        expect(
          jw.similarityUpperBound(s1.length, s2.length),
          greaterThanOrEqualTo(jw.similarity(s1, s2)),
          reason: 'bound must hold for "$s1" vs "$s2"',
        );
      }
    });

    test('distance is the complement of similarity', () {
      expect(jw.distance('france', 'france'), 0);
      expect(jw.distance('france', 'french'), closeTo(1 - jw.similarity('france', 'french'), 1e-12));
    });
  });

  group('TextSearch', () {
    TextSearch<String> buildSearch() => TextSearch([
      TextSearchItem.fromTerms('France', ['france', 'FR', 'french republic']),
      TextSearchItem.fromTerms('Germany', ['germany', 'DE', 'federal republic of germany']),
      TextSearchItem.fromTerms('United Kingdom', ['united kingdom', 'GB', 'great britain']),
    ]);

    test('exact and case-insensitive matches score 0 and come first', () {
      final results = buildSearch().search('FRANCE');
      expect(results.first.item, 'France');
      expect(results.first.score, 0);
    });

    test('search and fastSearch agree on ordering for the same term', () {
      final search = buildSearch();
      final scored = search.search('german');
      final fast = search.fastSearch('german');
      expect(fast, [for (final r in scored) r.item]);
    });

    test('empty search term matches every item in both methods', () {
      final search = buildSearch();
      expect(search.search('').map((r) => r.item), containsAll(['France', 'Germany', 'United Kingdom']));
      expect(search.fastSearch(''), containsAll(['France', 'Germany', 'United Kingdom']));
    });

    test('items without terms are safely ignored', () {
      final search = TextSearch<String>([const TextSearchItem('orphan', [])]);
      expect(search.search('orphan'), isEmpty);
      expect(search.fastSearch('orphan'), isEmpty);
    });

    test('fastSearch limit returns only the best k results', () {
      final search = buildSearch();
      final unlimited = search.fastSearch('republic');
      final limited = search.fastSearch('republic', limit: 1);
      expect(limited.length, 1);
      expect(limited.first, unlimited.first);
      expect(search.fastSearch('france', limit: 0), isEmpty);
    });

    test('single character terms match case-insensitively', () {
      // Historically the single-character check was case-sensitive, so a
      // lowercase search input never matched an uppercase single-character
      // term such as an ISO-2 code.
      final search = TextSearch<String>([
        TextSearchItem.fromTerms('France', ['F']),
      ]);
      expect(search.fastSearch('f'), contains('France'));
    });

    test('alwaysMatchPrefix matches lowercased search input', () {
      final search = buildSearch();
      expect(search.fastSearch('fren', alwaysMatchPrefix: true), contains('France'));
    });

    test('multi-word terms match on component words', () {
      final results = buildSearch().search('kingdom');
      expect(results, isNotEmpty);
      expect(results.first.item, 'United Kingdom');
    });

    test('multi-word term with all single characters matches', () {
      final search = TextSearch<String>([
        TextSearchItem.fromTerms('SingleChars', ['a b c']),
      ]);
      expect(search.search('z'), isNotEmpty);
    });

    test('multi-word prefix match', () {
      final search = TextSearch<String>([
        TextSearchItem.fromTerms('France', ['republic of france']),
      ]);
      expect(search.search('rep'), isNotEmpty);
    });

    test('fastSearch with limit uses bounded top-k correctly when capacity reached', () {
      final search = TextSearch<String>([
        TextSearchItem.fromTerms('Item1', ['apple one']),
        TextSearchItem.fromTerms('Item2', ['apple two']),
        TextSearchItem.fromTerms('Item3', ['apple three']),
      ]);
      final results = search.fastSearch('apple', limit: 2);
      expect(results.length, 2);
    });

    test('fastSearch with limit replaces worst score and inserts mid-list', () {
      final search = TextSearch<String>([
        TextSearchItem.fromTerms('Mid', ['apple banana']), // moderate score
        TextSearchItem.fromTerms('Worst', ['apple zebra xylophone']), // worse score
        TextSearchItem.fromTerms('Best', ['apple']), // exact match (score 0), replaces worst and inserts before Mid
      ]);
      final results = search.fastSearch('apple', limit: 2);
      expect(results, ['Best', 'Mid']);
    });

    test('search scaled distance returns effectiveThreshold when length bound fails', () {
      final search = TextSearch<String>([
        TextSearchItem.fromTerms('A', ['verylongwordthatclearlyexceedsthresholdandcannotmatch']),
      ]);
      expect(search.search('xy', matchThreshold: 0.1), isEmpty);
    });

    test('fastSearch empty term with limit returns prefix of items', () {
      final search = buildSearch();
      final results = search.fastSearch('', limit: 2);
      expect(results.length, 2);
      expect(results, ['France', 'Germany']);
    });
  });

  group('DateUtils extensions', () {
    test('DateCollection max returns the latest date', () {
      final d1 = DateTime(2020, 1, 1, 10, 30);
      final d2 = DateTime(2021, 5, 20, 8, 15);
      expect([d1, d2].max(), d2);
    });

    test('DateOperations extensions work as expected', () {
      final dt = DateTime(2020, 1, 15, 10, 30, 45);
      expect(dt.dateOnly(), DateTime(2020, 1, 15));
      expect(dt.addDays(5), DateTime(2020, 1, 20, 10, 30, 45));
      expect(dt.addYears(2), DateTime(2022, 1, 15, 10, 30, 45));
    });
  });

  group('JaroWinkler edge cases', () {
    test('similarityUpperBound returns 0 if either length is 0', () {
      final jw = JaroWinkler();
      expect(jw.similarityUpperBound(0, 5), 0);
      expect(jw.similarityUpperBound(5, 0), 0);
    });
  });

  group('CountriesProvider and presentation widgets', () {
    testWidgets('renders CountriesProvider, NationTile, PhoneCodeTile and FlagIcon', (tester) async {
      final loc = lookupCountryLocalizations(const Locale('en', 'GB'));
      var nationTapped = false;
      var phoneCodeTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Provider<CountryLocalizations>.value(
            value: loc,
            child: CountriesProvider(
              child: Builder(
                builder: (context) {
                  final countriesData = context.watch<Countries>();
                  return Scaffold(
                    body: ListView(
                      children: [
                        Text('Count: ${countriesData.countries.length}'),
                        NationTile(
                          country: Iso3166Country.unitedKingdom,
                          onTap: () {
                            nationTapped = true;
                          },
                        ),
                        PhoneCodeTile(
                          country: Iso3166Country.france,
                          onTap: () {
                            phoneCodeTapped = true;
                          },
                        ),
                        const FlagIcon.forIso3166(country: Iso3166Country.germany),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Count: 249'), findsOneWidget);
      expect(find.text('United Kingdom'), findsOneWidget);
      expect(find.text('France'), findsOneWidget);
      expect(find.text('+33'), findsOneWidget);
      expect(find.text(Iso3166Country.germany.flagEmoji()), findsOneWidget);

      await tester.tap(find.text('United Kingdom'));
      expect(nationTapped, isTrue);

      await tester.tap(find.text('France'));
      expect(phoneCodeTapped, isTrue);
    });
  });
}
