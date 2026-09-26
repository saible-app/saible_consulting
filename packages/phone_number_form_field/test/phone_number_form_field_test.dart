import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:phone_number_form_field/domain/phone_number.dart';
import 'package:phone_number_form_field/presentation/phone_number_form_field.dart';
import 'package:provider/provider.dart';
import 'package:saible_core/domain/iso3166_countries.dart';
import 'package:saible_core/l10n/app_localizations.dart';
import 'package:saible_core/presentation/nation_tile.dart';

void main() {
  Widget buildTestWidget({
    Locale locale = const Locale('en', 'GB'),
    FocusNode? focusNode,
    String? labelText,
    String? errorText,
    int? errorMaxLines,
    PhoneNumberInputs? initialValue,
    ValueChanged<PhoneNumberInputs>? onPhoneNumberChanged,
  }) {
    final saibleLoc = lookupCountryLocalizations(locale);
    return MaterialApp(
      locale: locale,
      supportedLocales: CountryLocalizations.supportedLocales,
      localizationsDelegates: CountryLocalizations.localizationsDelegates,
      builder: (context, child) => Provider<CountryLocalizations>.value(
        value: saibleLoc,
        child: child,
      ),
      home: Scaffold(
        body: Center(
          child: PhoneNumberFormField(
            focusNode: focusNode,
            labelText: labelText,
            errorText: errorText,
            errorMaxLines: errorMaxLines,
            initialValue: initialValue,
            onPhoneNumberChanged: onPhoneNumberChanged,
          ),
        ),
      ),
    );
  }

  group('PhoneNumberField', () {
    testWidgets('renders default state with UK flag, +44, labelText and empty text', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(labelText: 'Mobile Phone'),
      );
      await tester.pumpAndSettle();

      expect(find.text('Mobile Phone'), findsOneWidget);
      expect(find.text('+44'), findsOneWidget);
      expect(find.text(Iso3166Country.unitedKingdom.flagEmoji()), findsOneWidget);
      expect(find.byIcon(Icons.arrow_drop_down), findsOneWidget);

      final searchBarFinder = find.byKey(PhoneNumberFormField.countrySearchBarKey);
      expect(searchBarFinder, findsOneWidget);
      final textFormField = tester.widget<TextFormField>(searchBarFinder);
      expect(textFormField.controller?.text, isEmpty);
    });

    testWidgets('displays errorText and uses focusNode', (tester) async {
      final focusNode = FocusNode();
      await tester.pumpWidget(
        buildTestWidget(
          focusNode: focusNode,
          labelText: 'Phone',
          errorText: 'Invalid phone number',
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Invalid phone number'), findsOneWidget);
      expect(focusNode.hasFocus, isFalse);

      await tester.tap(find.byKey(PhoneNumberFormField.countrySearchBarKey));
      await tester.pump();
      expect(focusNode.hasFocus, isTrue);

      focusNode.dispose();
    });

    testWidgets('renders with initialValue and pre-selects country and formatted text', (tester) async {
      // Official Ofcom reserved drama dummy number: 020 7946 0123 / +442079460123
      const initial = PhoneNumberInputs(
        rawText: '20 7946 0123',
        e164: '+442079460123',
        regionCode: '+44',
      );

      await tester.pumpWidget(
        buildTestWidget(
          labelText: 'Phone Number',
          initialValue: initial,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('+44'), findsOneWidget);
      expect(find.text(Iso3166Country.unitedKingdom.flagEmoji()), findsOneWidget);

      final textFormField = tester.widget<TextFormField>(
        find.byKey(PhoneNumberFormField.countrySearchBarKey),
      );
      expect(textFormField.controller?.text, isNotEmpty);
    });

    testWidgets('renders with foreign initialValue (e.g. US) and selects US country', (tester) async {
      // Standard reserved 555 fictional US number: +12015550123
      const initial = PhoneNumberInputs(
        rawText: '201 555 0123',
        e164: '+12015550123',
        regionCode: '+1',
      );

      await tester.pumpWidget(
        buildTestWidget(
          labelText: 'Phone Number',
          initialValue: initial,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('+1'), findsOneWidget);
      expect(find.text(Iso3166Country.unitedStates.flagEmoji()), findsOneWidget);
    });

    testWidgets('formats as-you-type and notifies onPhoneNumberChanged with valid E164', (tester) async {
      final changedValues = <PhoneNumberInputs>[];

      await tester.pumpWidget(
        buildTestWidget(
          labelText: 'Phone',
          onPhoneNumberChanged: changedValues.add,
        ),
      );
      await tester.pumpAndSettle();

      // Enter official Ofcom drama dummy number: 020 7946 0123
      await tester.enterText(find.byKey(PhoneNumberFormField.countrySearchBarKey), '02079460123');
      await tester.pumpAndSettle();

      expect(changedValues, isNotEmpty);
      final last = changedValues.last;
      expect(last.regionCode, '+44');
      expect(last.e164, isNotNull);
      expect(last.isValid, isTrue);
      expect(last.e164, '+442079460123');
    });

    testWidgets('notifies with null e164 when phone number is incomplete or cleared', (tester) async {
      final changedValues = <PhoneNumberInputs>[];

      await tester.pumpWidget(
        buildTestWidget(
          labelText: 'Phone',
          onPhoneNumberChanged: changedValues.add,
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(PhoneNumberFormField.countrySearchBarKey), '123');
      await tester.pumpAndSettle();

      expect(changedValues.last.e164, isNull);
      expect(changedValues.last.isValid, isFalse);

      await tester.enterText(find.byKey(PhoneNumberFormField.countrySearchBarKey), '');
      await tester.pumpAndSettle();

      expect(changedValues.last.isEmpty, isTrue);
      expect(changedValues.last.e164, isNull);
    });

    testWidgets('tapping prefix opens search view with PhoneCodeTile suggestions', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(labelText: 'Phone'),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('+44'));
      await tester.pumpAndSettle();

      expect(find.byType(PhoneCodeTile), findsWidgets);
    });

    testWidgets('can search country in prefix search view, change country and reset input', (tester) async {
      PhoneNumberInputs? latestValue;

      await tester.pumpWidget(
        buildTestWidget(
          labelText: 'Phone',
          onPhoneNumberChanged: (val) => latestValue = val,
        ),
      );
      await tester.pumpAndSettle();

      // Enter dummy number under UK
      await tester.enterText(find.byKey(PhoneNumberFormField.countrySearchBarKey), '02079460123');
      await tester.pumpAndSettle();
      expect(latestValue?.e164, '+442079460123');

      // Tap prefix to open search view
      await tester.tap(find.text('+44'));
      await tester.pumpAndSettle();

      // Search for France
      await tester.enterText(find.byType(TextField).last, 'France');
      await tester.pumpAndSettle();

      final franceTileKey = PhoneNumberFormField.countrySuggestionKey(Iso3166Country.france);
      expect(find.byKey(franceTileKey), findsOneWidget);

      await tester.tap(find.byKey(franceTileKey));
      await tester.pumpAndSettle();

      // Now France is selected with code +33, controller text is reset
      expect(find.text('+33'), findsOneWidget);
      expect(find.text(Iso3166Country.france.flagEmoji()), findsOneWidget);

      final textFormField = tester.widget<TextFormField>(
        find.byKey(PhoneNumberFormField.countrySearchBarKey),
      );
      expect(textFormField.controller?.text, isEmpty);
      expect(latestValue?.rawText, isEmpty);
      expect(latestValue?.regionCode, '+33');
      expect(latestValue?.e164, isNull);
    });

    testWidgets('can search by dial code prefix in prefix search view', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(labelText: 'Phone'),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('+44'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).last, '33');
      await tester.pumpAndSettle();

      final franceTileKey = PhoneNumberFormField.countrySuggestionKey(Iso3166Country.france);
      expect(find.byKey(franceTileKey), findsOneWidget);
    });

  });
}
