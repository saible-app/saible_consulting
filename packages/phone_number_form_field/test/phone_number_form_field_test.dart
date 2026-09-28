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
import 'package:phone_number_form_field/application/phone_util.dart';
import 'package:phone_number_form_field/domain/phone_number.dart';
import 'package:phone_number_form_field/presentation/phone_number_form_field.dart';
import 'package:provider/provider.dart';
import 'package:saible_consulting_core/saible_consulting_core.dart';

void main() {
  Widget buildTestWidget({
    Locale locale = const Locale('en', 'GB'),
    FocusNode? focusNode,
    String? labelText,
    String? errorText,
    int? errorMaxLines,
    PhoneNumberState? initialValue,
    ValueChanged<PhoneNumberState>? onPhoneNumberChanged,
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
            decoration: InputDecoration(
              labelText: labelText,
              errorText: errorText,
              errorMaxLines: errorMaxLines,
            ),
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
      const initial = PhoneNumberState(
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
      const initial = PhoneNumberState(
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
      final changedValues = <PhoneNumberState>[];

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
      final changedValues = <PhoneNumberState>[];

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
      PhoneNumberState? latestValue;

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

    testWidgets('handles parse error gracefully in formatting', (tester) async {
      final changedValues = <PhoneNumberState>[];

      await tester.pumpWidget(
        buildTestWidget(
          labelText: 'Phone',
          onPhoneNumberChanged: changedValues.add,
        ),
      );
      await tester.pumpAndSettle();

      // Enter text that could trigger parsing exceptions
      await tester.enterText(find.byKey(PhoneNumberFormField.countrySearchBarKey), '+++');
      await tester.pumpAndSettle();

      expect(changedValues.last.e164, isNull);
    });
  });

  group('PhoneNumberState and FormatUtils', () {
    test('PhoneNumberState.empty initializes with default region code and empty rawText', () {
      const state = PhoneNumberState.empty();
      expect(state.rawText, '');
      expect(state.e164, isNull);
      expect(state.regionCode, defaultRegionCode);
      expect(state.isEmpty, isTrue);
      expect(state.isNotEmpty, isFalse);
      expect(state.isValid, isFalse);
    });

    test('PhoneNumberState.fromPhoneNumber creates valid state and FormatUtils formats without trunk', () {
      final parsed = phoneUtil.parse('+442079460123', 'GB');
      final state = PhoneNumberState.fromPhoneNumber(parsed);

      expect(state.rawText, '20 7946 0123');
      expect(state.e164, '+442079460123');
      expect(state.regionCode, '+44');
      expect(state.isEmpty, isFalse);
      expect(state.isNotEmpty, isTrue);
      expect(state.isValid, isTrue);
      expect(parsed.internationalFormatWithoutTrunk(), '20 7946 0123');
    });

  });
}
