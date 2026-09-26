import 'package:country_picker_form_field/country_picker_form_field.dart';
import 'package:date_picker_form_field/date_picker_form_field.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_demo/main.dart';
import 'package:material_ui/material_ui.dart';
import 'package:phone_number_form_field/phone_number_form_field.dart';
import 'package:saible_core/domain/iso3166_countries.dart';

void main() {
  group('Form Demo App Widget Tests', () {
    testWidgets('renders all primary form fields and UI elements', (tester) async {
      await tester.pumpWidget(const DemoApp());
      await tester.pumpAndSettle();

      // App bar
      expect(find.text('Registration Demo'), findsOneWidget);

      // Privacy Notice Banner
      expect(find.byIcon(Icons.shield_outlined), findsOneWidget);
      expect(find.textContaining('Privacy Notice: This is a demonstration app.'), findsOneWidget);

      // Form fields
      expect(find.text('Date of Birth'), findsOneWidget);
      expect(find.byKey(DatePickerFormField.textInputKey), findsOneWidget);
      expect(find.byKey(DatePickerFormField.launchDatePickerKey), findsOneWidget);

      expect(find.text('Nationality'), findsOneWidget);
      expect(find.byKey(CountryPickerFormField.countrySearchBarKey), findsOneWidget);

      expect(find.text('Phone Number'), findsOneWidget);
      expect(find.byKey(PhoneNumberFormField.countrySearchBarKey), findsOneWidget);
      expect(find.text('+44'), findsOneWidget);

      // Submit Button
      expect(find.widgetWithText(ElevatedButton, 'Submit Demo Form'), findsOneWidget);
    });

    testWidgets('submitting form with default empty state displays SnackBar with null values', (tester) async {
      await tester.pumpWidget(const DemoApp());
      await tester.pumpAndSettle();

      // Tap Submit
      await tester.tap(find.widgetWithText(ElevatedButton, 'Submit Demo Form'));
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(
        find.text('Form Validated!\nDoB: null\nNationality: null\nPhone: null'),
        findsOneWidget,
      );
      final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
      expect(snackBar.backgroundColor, Colors.green[800]);
    });

    testWidgets('selecting date of birth updates DoB in submission SnackBar', (tester) async {
      await tester.pumpWidget(const DemoApp());
      await tester.pumpAndSettle();

      // Open DatePickerDialog
      await tester.tap(find.byKey(DatePickerFormField.launchDatePickerKey));
      await tester.pumpAndSettle();
      expect(find.byType(DatePickerDialog), findsOneWidget);

      // Select day 15 in the calendar
      await tester.tap(find.text('15').first);
      await tester.pumpAndSettle();

      // Confirm selected date by tapping OK button in DatePickerDialog
      final okButton = find.widgetWithText(TextButton, 'OK');
      await tester.tap(okButton);
      await tester.pumpAndSettle();

      expect(find.byType(DatePickerDialog), findsNothing);

      // Submit form
      await tester.tap(find.widgetWithText(ElevatedButton, 'Submit Demo Form'));
      await tester.pumpAndSettle();

      // Date of Birth is populated (year-month-day)
      expect(find.textContaining('-15'), findsOneWidget);
      expect(find.textContaining('Nationality: null'), findsOneWidget);
      expect(find.textContaining('Phone: null'), findsOneWidget);
    });
    testWidgets('selecting nationality updates Nationality in submission SnackBar', (tester) async {
      await tester.pumpWidget(const DemoApp());
      await tester.pumpAndSettle();

      // Tap Nationality search bar
      await tester.tap(find.byKey(CountryPickerFormField.countrySearchBarKey));
      await tester.pumpAndSettle();

      // Search for Franceß
      await tester.enterText(find.byType(TextField).last, 'France');
      await tester.pumpAndSettle();

      final franceTileKey = Key('countryPicker_country_${Iso3166Country.france.alpha2}');
      expect(find.byKey(franceTileKey), findsOneWidget);
      await tester.tap(find.byKey(franceTileKey));
      await tester.pumpAndSettle();

      // Submit form
      await tester.tap(find.widgetWithText(ElevatedButton, 'Submit Demo Form'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Nationality: france'), findsOneWidget);
    });

    testWidgets('entering valid phone number updates Phone in submission SnackBar', (tester) async {
      await tester.pumpWidget(const DemoApp());
      await tester.pumpAndSettle();

      // Enter valid UK dummy number into phone field
      await tester.enterText(find.byKey(PhoneNumberFormField.countrySearchBarKey), '02079460123');
      await tester.pumpAndSettle();

      // Submit form
      await tester.tap(find.widgetWithText(ElevatedButton, 'Submit Demo Form'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Phone: +442079460123'), findsOneWidget);
    });

    testWidgets('changing country code in phone field formats number with new prefix in submission SnackBar',
        (tester) async {
      await tester.pumpWidget(const DemoApp());
      await tester.pumpAndSettle();

      // Tap country dial code prefix (+44) to open country selector
      await tester.tap(find.text('+44'));
      await tester.pumpAndSettle();

      // Search for France
      await tester.enterText(find.byType(TextField).last, 'France');
      await tester.pumpAndSettle();

      final francePhoneTileKey = PhoneNumberFormField.countrySuggestionKey(Iso3166Country.france);
      expect(find.byKey(francePhoneTileKey), findsOneWidget);
      await tester.tap(find.byKey(francePhoneTileKey));
      await tester.pumpAndSettle();

      // Enter French telephone number: 01 23 45 67 89
      await tester.enterText(find.byKey(PhoneNumberFormField.countrySearchBarKey), '0123456789');
      await tester.pumpAndSettle();

      // Submit form
      await tester.tap(find.widgetWithText(ElevatedButton, 'Submit Demo Form'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Phone: +33123456789'), findsOneWidget);
    });

    testWidgets('complete form submission with all fields populated', (tester) async {
      await tester.pumpWidget(const DemoApp());
      await tester.pumpAndSettle();

      // 1. Pick DoB via date picker dialog
      await tester.tap(find.byKey(DatePickerFormField.launchDatePickerKey));
      await tester.pumpAndSettle();
      await tester.tap(find.text('15').first);
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(TextButton, 'OK'));
      await tester.pumpAndSettle();

      // 2. Pick Nationality (Germany)
      await tester.tap(find.byKey(CountryPickerFormField.countrySearchBarKey));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).last, 'Germany');
      await tester.pumpAndSettle();
      final germanyTileKey = Key('countryPicker_country_${Iso3166Country.germany.alpha2}');
      await tester.tap(find.byKey(germanyTileKey));
      await tester.pumpAndSettle();

      // 3. Enter Phone Number
      await tester.enterText(find.byKey(PhoneNumberFormField.countrySearchBarKey), '02079460123');
      await tester.pumpAndSettle();

      // 4. Submit Form
      await tester.tap(find.widgetWithText(ElevatedButton, 'Submit Demo Form'));
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.textContaining('Form Validated!'), findsOneWidget);
      expect(find.textContaining('-15'), findsOneWidget);
      expect(find.textContaining('Nationality: germany'), findsOneWidget);
      expect(find.textContaining('Phone: +442079460123'), findsOneWidget);
    });
  });
}
