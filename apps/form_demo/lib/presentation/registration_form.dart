import 'package:country_picker_form_field/presentation/country_picker_form_field.dart';
import 'package:date_picker_form_field/presentation/date_picker_form_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_demo/application/country_input_state.dart';
import 'package:form_demo/application/date_input_state.dart';
import 'package:form_demo/application/phone_number_input_state.dart';
import 'package:form_demo/application/registration_form_bloc.dart';
import 'package:form_demo/application/registration_form_event.dart';
import 'package:form_demo/application/registration_form_state.dart';
import 'package:form_demo/l10n/app_localizations.dart';
import 'package:form_demo/presentation/language_menu.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:phone_number_form_field/presentation/phone_number_form_field.dart';
import 'package:saible_consulting_core/saible_consulting_core.dart';

/// The main registration form screen of the demo application.
///
/// Collects user information including date of birth, nationality,
/// and phone number, and exposes an app bar with language selection.
class const RegistrationForm({super.key, required this.onLocaleChanged}) extends StatefulWidget {
  /// Callback invoked when the user selects a new locale from the language switcher.
  final ValueChanged<Locale> onLocaleChanged;

  /// Creates a [RegistrationForm].
  this;

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class const _DateOfBirthField() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    final dateFormat = DateFormat.yMd(locale.toLanguageTag());
    return BlocSelector<RegistrationFormBloc, RegistrationFormState, DateInputState>(
      selector: (state) => state.dateOfBirth,
      builder: (context, dateOfBirth) {
        final first = dateOfBirth.first;
        final last = dateOfBirth.last;
        return DatePickerFormField(
          firstDate: dateOfBirth.first(),
          lastDate: dateOfBirth.last(),
          decoration: InputDecoration(
            labelText: l10n.dateOfBirthLabel,
            errorText: switch (dateOfBirth.error) {
              null => null,
              _ when dateOfBirth.isPure => null,
              DateInputStateErrorRequired() => l10n.dateOfBirthErrorRequired,
              DateInputStateErrorInvalid() => l10n.dateOfBirthErrorInvalid,
              DateInputStateErrorTooEarly(first: final f) => l10n.dateOfBirthErrorTooEarly(dateFormat.format(f)),
              DateInputStateErrorTooLate(last: final l) => l10n.dateOfBirthErrorTooLate(dateFormat.format(l))
            }
          ),
          onDateChanged: (input) {
            context.read<RegistrationFormBloc>().add(
              DateOfBirthChanged(first: first, last: last, value: input)
            );
          },
        );
      },
    );
  }
}

class const _NationalityField() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocSelector<RegistrationFormBloc, RegistrationFormState, CountryInputState>(
      selector: (state) => state.nationality,
      builder: (context, nationality) => CountryPickerFormField(
        decoration: InputDecoration(
          labelText: l10n.nationalityLabel,
          errorText: switch (nationality.error) {
            null => null,
            _ when nationality.isPure => null,
            CountryValidationError.empty => l10n.nationalityErrorRequired,
          }
        ),
        onCountryPicked: (input) {
          context.read<RegistrationFormBloc>().add(
            NationalityChanged(value: input)
          );
        },
      ),
    );
  }
}

class const _PhoneNumberField() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocSelector<RegistrationFormBloc, RegistrationFormState, PhoneNumberInputState>(
      selector: (state) => state.phoneNumber,
      builder: (context, phoneNumber) => PhoneNumberFormField(
        decoration: InputDecoration(
          labelText: l10n.phoneNumberLabel,
          errorText: switch (phoneNumber.error) {
            null => null,
            _ when phoneNumber.isPure => null,
            PhoneNumberInputStateError.required => l10n.phoneNumberErrorRequired,
            PhoneNumberInputStateError.invalid => l10n.phoneNumberErrorInvalid,
          }
        ),
        onPhoneNumberChanged: (input) {
          context.read<RegistrationFormBloc>().add(
            PhoneNumberChanged(value: input)
          );
        },
      ),
    );
  }
}

class const _Actions() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final countryL10n = CountryLocalizations.of(context);
    return BlocBuilder<RegistrationFormBloc, RegistrationFormState>(
      builder: (context, state) {
        void submitForm() {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${l10n.formValidated}\n'
                '${l10n.dateOfBirthPrefix}: ${state.dateOfBirth.value.rawText}\n'
                '${l10n.nationalityPrefix}: ${state.nationality.value?.tr(countryL10n)}\n'
                '${l10n.phonePrefix}: ${state.phoneNumber.value.regionCode} ${state.phoneNumber.value.rawText}',
              ),
            ),
          );
        }
        return FilledButton(
          onPressed: state.isValid ? submitForm : null,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(16),
          ),
          child: Text(l10n.submitButton),
        );
      },
    );
  }
}

class const _PrivacyBanner() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.shield_outlined),
            const SizedBox(width: 12),
            Expanded(
              child: Text(l10n.privacyNotice, style: const TextStyle(fontSize: 13)),
            ),
          ],
        ),
      ),
    );
  }
}

class const _Form() extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const Form(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _PrivacyBanner(),
        SizedBox(height: 24),
        _DateOfBirthField(),
        SizedBox(height: 16),
        _NationalityField(),
        SizedBox(height: 16),
        _PhoneNumberField(),
        SizedBox(height: 32),
        _Actions(),
      ],
    ),
  );
}

class _RegistrationFormState() extends State<RegistrationForm> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        elevation: 2,
        actions: [LanguageSwitcher(onLocaleChanged: widget.onLocaleChanged)],
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: _Form(),
        ),
      ),
    );
  }
}
