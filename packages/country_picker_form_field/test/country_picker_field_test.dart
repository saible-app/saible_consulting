import 'package:country_picker_form_field/presentation/country_picker_form_field.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:saible_core/domain/iso3166_countries.dart';
import 'package:saible_core/l10n/app_localizations.dart';
import 'package:saible_core/presentation/nation_tile.dart';

void main() {
  Widget buildTestWidget({
    Locale locale = const Locale('en', 'GB'),
    required String labelText,
    required void Function(Iso3166Country country) onCountryPicked,
    Iso3166Country? initial,
    String? hintText,
    FocusNode? focusNode,
  }) {
    final saibleLoc = lookupCountryLocalizations(locale);
    return MaterialApp(
      locale: locale,
      supportedLocales: CountryLocalizations.supportedLocales,
      localizationsDelegates: const [
        ...CountryLocalizations.localizationsDelegates,
        ...GlobalMaterialLocalizations.delegates
      ],
      builder: (context, child) => Provider<CountryLocalizations>.value(
        value: saibleLoc,
        child: child,
      ),
      home: Scaffold(
        body: Center(
          child: CountryPickerFormField(
            decoration: InputDecoration(
              labelText: labelText,
              hintText: hintText,
            ),
            onCountryPicked: onCountryPicked,
            initial: initial,
            focusNode: focusNode,
          ),
        ),
      ),
    );
  }

  group('CountryPicker', () {
    testWidgets('renders properly with labelText, hintText, and default icon when initial is null', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          labelText: 'Country of Residence',
          hintText: 'Select country',
          onCountryPicked: (_) {},
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Country of Residence'), findsOneWidget);
      expect(find.text('Select country'), findsOneWidget);
      expect(find.byIcon(Icons.language), findsOneWidget);
      expect(find.byType(FlagIcon), findsNothing);
    });

    testWidgets('renders initial country name and flag icon when initial country is provided', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          labelText: 'Country of Residence',
          initial: Iso3166Country.unitedKingdom,
          onCountryPicked: (_) {},
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('United Kingdom'), findsOneWidget);
      expect(find.byType(FlagIcon), findsOneWidget);
      expect(find.byIcon(Icons.language), findsNothing);
    });

    testWidgets('opens suggestions view on tap and displays suggestions', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          labelText: 'Country',
          onCountryPicked: (_) {},
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('countryPicker_searchBar')));
      await tester.pumpAndSettle();

      expect(find.byType(NationTile), findsWidgets);
    });

    testWidgets('filters suggestions and selects a country', (tester) async {
      Iso3166Country? selectedCountry;
      await tester.pumpWidget(
        buildTestWidget(
          labelText: 'Country',
          onCountryPicked: (country) => selectedCountry = country,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('countryPicker_searchBar')));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).last, 'France');
      await tester.pumpAndSettle();

      final franceTileKey = Key('countryPicker_country_${Iso3166Country.france.alpha2}');
      expect(find.byKey(franceTileKey), findsOneWidget);

      await tester.tap(find.byKey(franceTileKey));
      await tester.pumpAndSettle();

      expect(selectedCountry, Iso3166Country.france);
      expect(find.text('France'), findsOneWidget);
      expect(find.byType(FlagIcon), findsOneWidget);
    });

    testWidgets('restores previous selection on close if no new country was selected', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          labelText: 'Country',
          initial: Iso3166Country.germany,
          onCountryPicked: (_) {},
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Germany'), findsOneWidget);

      await tester.tap(find.byKey(const Key('countryPicker_searchBar')));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).last, 'xyz');
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();

      expect(find.text('Germany'), findsOneWidget);
    });

    testWidgets('uses provided focusNode', (tester) async {
      final focusNode = FocusNode();
      await tester.pumpWidget(
        buildTestWidget(
          labelText: 'Country',
          focusNode: focusNode,
          onCountryPicked: (_) {},
        ),
      );
      await tester.pumpAndSettle();

      expect(focusNode.hasFocus, isFalse);
      focusNode.requestFocus();
      await tester.pump();
      expect(focusNode.hasFocus, isTrue);

      focusNode.dispose();
    });

    testWidgets('supports different locales (e.g. French)', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          locale: const Locale('fr'),
          labelText: 'Pays',
          initial: Iso3166Country.unitedKingdom,
          onCountryPicked: (_) {},
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Royaume-Uni'), findsOneWidget);
      expect(find.text('Pays'), findsOneWidget);
    });
    
    testWidgets('typing or changing text opens suggestions view via onChanged', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          labelText: 'Country',
          onCountryPicked: (_) {},
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(CountryPickerFormField.countrySearchBarKey), 'Fra');
      await tester.pumpAndSettle();

      expect(find.byType(NationTile), findsWidgets);
    });

  });
}
