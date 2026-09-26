import 'package:country_picker_form_field/country_picker_form_field.dart';
import 'package:date_picker_form_field/date_picker_form_field.dart';
import 'package:material_ui/material_ui.dart';
import 'package:phone_number_form_field/phone_number_form_field.dart';
import 'package:provider/provider.dart';
import 'package:saible_core/application/date_utils.dart';
import 'package:saible_core/domain/iso3166_countries.dart';
import 'package:saible_core/l10n/app_localizations.dart';

void main() {
  runApp(const DemoApp());
}

class const DemoApp({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Saible Form Demo',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E3A8A)),
      useMaterial3: true,
    ),
    supportedLocales: CountryLocalizations.supportedLocales,
    localizationsDelegates: const [
      ...CountryLocalizations.localizationsDelegates,
      ...GlobalMaterialLocalizations.delegates,
    ],
    builder: (context, child) => Provider<CountryLocalizations>.value(
      value: lookupCountryLocalizations(Localizations.maybeLocaleOf(context) ?? const Locale('en', 'GB')),
      child: child,
    ),
    home: const RegistrationFormScreen(),
  );
}

class const RegistrationFormScreen({super.key}) extends StatefulWidget {
  @override
  State<RegistrationFormScreen> createState() => _RegistrationFormScreenState();
}

class _RegistrationFormScreenState() extends State<RegistrationFormScreen> {
  final _formKey = GlobalKey<FormState>();

  DateTime? _selectedDateOfBirth;
  Iso3166Country? _selectedNationality;
  String? _enteredPhoneNumber;

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Form Validated!\n'
            'DoB: ${_selectedDateOfBirth?.toIso8601String().split('T').first}\n'
            'Nationality: ${_selectedNationality?.name}\n'
            'Phone: $_enteredPhoneNumber',
          ),
          backgroundColor: Colors.green[800],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Registration Demo'),
      elevation: 2,
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Privacy Reassurance Banner
            Card(
              color: Colors.blue[50],
              elevation: 0,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.blue[200]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.shield_outlined, color: Colors.blue[800]),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Privacy Notice: This is a demonstration app. '
                        'None of the information entered here is stored, '
                        'transmitted, or shared.',
                        style: TextStyle(
                          color: Colors.blue[900],
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Date of Birth Field
            DatePickerFormField(
              initial: DateInputState.pure(DateTime(1900), DateTime.now().dateOnly().addYears(-18)),
              decoration: const InputDecoration(labelText: 'Date of Birth'),
              onPickDate: (date) {
                setState(() => _selectedDateOfBirth = date);
              },
            ),
            const SizedBox(height: 16),

            // Nationality Field
            CountryPickerFormField(
              labelText: 'Nationality',
              onCountryPicked: (country) {
                setState(() => _selectedNationality = country);
              },
            ),
            const SizedBox(height: 16),

            // Phone Number Field
            PhoneNumberFormField(
              labelText: 'Phone Number',
              onPhoneNumberChanged: (phoneInput) {
                setState(() => _enteredPhoneNumber = phoneInput.e164);
              },
            ),
            const SizedBox(height: 32),

            // Submit Button
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                backgroundColor: const Color(0xFF1E3A8A),
                foregroundColor: Colors.white,
              ),
              child: const Text('Submit Demo Form'),
            ),
          ],
        ),
      ),
    ),
  );
}
