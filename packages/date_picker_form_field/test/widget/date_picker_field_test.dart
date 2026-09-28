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

import 'package:date_picker_form_field/presentation/date_picker_form_field.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:material_ui/material_ui.dart';
import 'package:saible_consulting_core/saible_consulting_core.dart';

const usLocale = Locale('en', 'US');

void main() {
  setUpAll(() async {
    await initializeDateFormatting('en-GB');
    await initializeDateFormatting();
  });

  Widget buildTestWidget({
    Locale locale = const Locale('en', 'GB'),
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    InputDecoration? decoration,
    String? pickerHelpText,
    FocusNode? focusNode,
    void Function(DateTime)? onPickDate,
    void Function(DateInputValue)? onDateChanged,
    void Function(String)? onEditText,
    void Function(String)? onFieldSubmitted,
    void Function()? onEditingComplete,
    bool passFirstLast = true,
    GlobalKey<FormState>? formKey,
    String? Function(DateTime? date)? validator,
    void Function(DateTime? date)? onSaved,
  }) {
    final first = DateTime(1900);
    final last = DateTime(2100, 12, 31);
    return MaterialApp(
      locale: locale,
      supportedLocales: const [
        Locale('en', 'GB'),
        Locale('en', 'US'),
        Locale('de', 'DE'),
        Locale('fr', 'FR'),
        Locale('es', 'ES'),
        Locale('ja', 'JP'),
        Locale('zh', 'CN'),
        Locale('pt', 'BR'),
        Locale('ru', 'RU'),
      ],
      localizationsDelegates: SaibleLocalizations.localizationsDelegates,
      home: Scaffold(
        body: Center(
          child: Form(
            key: formKey,
            child: DatePickerFormField(
              initialDate: initialDate,
              firstDate: passFirstLast ? (firstDate ?? first) : null,
              lastDate: passFirstLast ? (lastDate ?? last) : null,
              decoration: decoration ?? const InputDecoration(labelText: 'Date of Birth'),
              pickerHelpText: pickerHelpText,
              focusNode: focusNode,
              onPickDate: onPickDate ?? (_) {},
              onDateChanged: onDateChanged,
              onEditText: onEditText ?? (_) {},
              onFieldSubmitted: onFieldSubmitted,
              onEditingComplete: onEditingComplete,
              validator: validator,
              onSaved: onSaved,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> pumpDatePicker(
    WidgetTester tester, {
    Locale locale = const Locale('en', 'GB'),
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    InputDecoration? decoration,
    String? pickerHelpText,
    FocusNode? focusNode,
    void Function(DateTime)? onPickDate,
    void Function(DateInputValue)? onDateChanged,
    void Function(String)? onEditText,
    void Function(String)? onFieldSubmitted,
    void Function()? onEditingComplete,
    bool passFirstLast = true,
  }) async {
    await tester.pumpWidget(
      buildTestWidget(
        locale: locale,
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate,
        decoration: decoration,
        pickerHelpText: pickerHelpText,
        focusNode: focusNode,
        onPickDate: onPickDate,
        onDateChanged: onDateChanged,
        onEditText: onEditText,
        onFieldSubmitted: onFieldSubmitted,
        onEditingComplete: onEditingComplete,
        passFirstLast: passFirstLast,
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<String> typeIntoDateField(WidgetTester tester, String text) async {
    final fieldFinder = find.byKey(DatePickerFormField.textInputKey);
    final editableFinder = find.descendant(of: fieldFinder, matching: find.byType(EditableText));
    await tester.tap(fieldFinder);
    await tester.pump();
    for (final char in text.split('')) {
      final currentText = tester.widget<EditableText>(editableFinder).controller.text;
      tester.testTextInput.enterText('$currentText$char');
      await tester.pump();
    }
    return tester.widget<EditableText>(editableFinder).controller.text;
  }

  Future<String> backspaceInDateField(WidgetTester tester) async {
    final editableFinder = find.descendant(
      of: find.byKey(DatePickerFormField.textInputKey),
      matching: find.byType(EditableText),
    );
    final currentText = tester.widget<EditableText>(editableFinder).controller.text;
    if (currentText.isEmpty) return '';
    final newText = currentText.substring(0, currentText.length - 1);
    tester.testTextInput.enterText(newText);
    await tester.pump();
    return tester.widget<EditableText>(editableFinder).controller.text;
  }

  void verifyEditableText(WidgetTester tester, String expected) {
    final editableText = tester.widget<EditableText>(
      find.descendant(of: find.byKey(DatePickerFormField.textInputKey), matching: find.byType(EditableText)),
    );
    expect(editableText.controller.text, expected);
  }

  group('DatePickerFormField - Rendering and Initialization', () {
    testWidgets('renders TextFormField with decoration, hint, and calendar icon button', (tester) async {
      await pumpDatePicker(
        tester,
        decoration: const InputDecoration(
          labelText: 'Date of Birth',
          errorText: 'Some error',
          errorMaxLines: 2,
        ),
      );

      expect(find.byKey(DatePickerFormField.textInputKey), findsOneWidget);
      expect(find.byKey(DatePickerFormField.launchDatePickerKey), findsOneWidget);
      expect(find.text('Date of Birth'), findsOneWidget);
      expect(find.text('Some error'), findsOneWidget);
      expect(find.text('DD/MM/YYYY'), findsOneWidget);
    });

    testWidgets('initializes empty when current date is null', (tester) async {
      await pumpDatePicker(tester);
      verifyEditableText(tester, '');
    });

    testWidgets('formats initial current date according to locale en-GB', (tester) async {
      await pumpDatePicker(tester, initialDate: DateTime(1999, 10, 31));
      verifyEditableText(tester, '31/10/1999');
    });

    testWidgets('formats initial current date according to locale en-US', (tester) async {
      await pumpDatePicker(tester, locale: usLocale, initialDate: DateTime(1999, 10, 31));
      verifyEditableText(tester, '10/31/1999');
    });

    testWidgets('re-formats the current date when the locale changes from en-GB to de', (tester) async {
      await pumpDatePicker(tester, initialDate: DateTime(2008, 9, 3));
      verifyEditableText(tester, '03/09/2008');

      // Switch the ambient locale from en-GB to German; the same field state
      // is kept alive (same element tree position) so only dependencies
      // re-resolve, and didChangeDependencies re-derives the display text.
      await pumpDatePicker(tester, locale: const Locale('de', 'DE'), initialDate: DateTime(2008, 9, 3));
      verifyEditableText(tester, '3.9.2008');
    });
  });

  group('DatePickerFormField - Text Input Formatting Across Locales', () {
    final formatTestCases = <Map<String, dynamic>>[
      {'locale': const Locale('en', 'GB'), 'digits': '31101999', 'expected': '31/10/1999'},
      {'locale': const Locale('en', 'US'), 'digits': '10311999', 'expected': '10/31/1999'},
      {'locale': const Locale('de', 'DE'), 'digits': '31101999', 'expected': '31.10.1999'},
      {'locale': const Locale('fr', 'FR'), 'digits': '31101999', 'expected': '31/10/1999'},
      {'locale': const Locale('es', 'ES'), 'digits': '31101999', 'expected': '31/10/1999'},
      {'locale': const Locale('ja', 'JP'), 'digits': '19991031', 'expected': '1999/10/31'},
      {'locale': const Locale('zh', 'CN'), 'digits': '19991031', 'expected': '1999/10/31'},
      {'locale': const Locale('pt', 'BR'), 'digits': '31101999', 'expected': '31/10/1999'},
      {'locale': const Locale('ru', 'RU'), 'digits': '31101999', 'expected': '31.10.1999'},
    ];

    for (final testCase in formatTestCases) {
      final locale = testCase['locale'] as Locale;
      final digits = testCase['digits'] as String;
      final expected = testCase['expected'] as String;
      final localeTag = locale.toLanguageTag();

      testWidgets('formats typed digits correctly for $localeTag', (tester) async {
        await pumpDatePicker(tester, locale: locale);
        final displayedText = await typeIntoDateField(tester, digits);
        expect(displayedText, expected);
      });
    }
  });

  group('DatePickerFormField - Backspacing', () {
    final backspaceTestCases = <Map<String, dynamic>>[
      {
        'locale': const Locale('en', 'GB'),
        'digits': '31101999',
        'afterDigit': '31/10/199',
        'separatorDigits': '31101',
        'separatorDate': '31/10/1',
        'afterSeparator': '31/10',
      },
      {
        'locale': const Locale('de', 'DE'),
        'digits': '31101999',
        'afterDigit': '31.10.199',
        'separatorDigits': '31101',
        'separatorDate': '31.10.1',
        'afterSeparator': '31.10',
      },
    ];

    for (final tc in backspaceTestCases) {
      final locale = tc['locale'] as Locale;
      final localeTag = locale.toLanguageTag();

      testWidgets('backspace over digit $localeTag', (tester) async {
        await pumpDatePicker(tester, locale: locale);
        await typeIntoDateField(tester, tc['digits'] as String);
        final result = await backspaceInDateField(tester);
        expect(result, tc['afterDigit']);
      });

      testWidgets('backspace over separator $localeTag', (tester) async {
        await pumpDatePicker(tester, locale: locale);
        await typeIntoDateField(tester, tc['separatorDigits'] as String);
        final result = await backspaceInDateField(tester);
        expect(result, tc['afterSeparator']);
      });
    }
  });

  group('DatePickerFormField - Callbacks and User Interactions', () {
    testWidgets('calls onEditText when user types text', (tester) async {
      final edits = <String>[];
      await pumpDatePicker(
        tester,
        onEditText: edits.add,
      );

      await typeIntoDateField(tester, '15');
      expect(edits, isNotEmpty);
      expect(edits.last, '15');
    });

    testWidgets('calls onFieldSubmitted when text field is submitted', (tester) async {
      String? submittedText;
      await pumpDatePicker(
        tester,
        onFieldSubmitted: (val) => submittedText = val,
      );

      await tester.showKeyboard(find.byKey(DatePickerFormField.textInputKey));
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      expect(submittedText, isNotNull);
    });

    testWidgets('calls onEditingComplete when editing completes', (tester) async {
      var completed = false;
      await pumpDatePicker(tester, onEditingComplete: () => completed = true);
      await tester.showKeyboard(find.byKey(DatePickerFormField.textInputKey));
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      expect(completed, isTrue);
    });

    testWidgets('opens date picker dialog when calendar icon is tapped and cancels without selecting', (tester) async {
      DateTime? pickedDate;
      await pumpDatePicker(
        tester,
        pickerHelpText: 'Select birth date',
        onPickDate: (date) => pickedDate = date,
      );

      await tester.tap(find.byKey(DatePickerFormField.launchDatePickerKey));
      await tester.pumpAndSettle();

      expect(find.byType(DatePickerDialog), findsOneWidget);
      expect(find.text('Select birth date'), findsOneWidget);

      final cancelButton = find.byType(TextButton).first;
      await tester.tap(cancelButton);
      await tester.pumpAndSettle();

      expect(find.byType(DatePickerDialog), findsNothing);
      expect(pickedDate, isNull);
    });

    testWidgets('opens date picker dialog, confirms date, updates text and triggers onPickDate', (tester) async {
      DateTime? pickedDate;
      final initialDate = DateTime(1999, 10, 31);
      await pumpDatePicker(
        tester,
        initialDate: initialDate,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100, 12, 31),
        onPickDate: (date) => pickedDate = date,
      );

      await tester.tap(find.byKey(DatePickerFormField.launchDatePickerKey));
      await tester.pumpAndSettle();

      expect(find.byType(DatePickerDialog), findsOneWidget);
      expect(find.byKey(DatePickerFormField.switchToEntryModeKey), findsOneWidget);

      final okButton = find.byType(TextButton).last;
      await tester.tap(okButton);
      await tester.pumpAndSettle();

      expect(find.byType(DatePickerDialog), findsNothing);
      expect(pickedDate, initialDate);

      final editable = tester.widget<EditableText>(
        find.descendant(of: find.byKey(DatePickerFormField.textInputKey), matching: find.byType(EditableText)),
      );
      expect(editable.controller.text, '31/10/1999');
    });

    testWidgets('uses provided focusNode', (tester) async {
      final focusNode = FocusNode();
      await pumpDatePicker(tester, focusNode: focusNode);
      expect(focusNode.hasFocus, isFalse);
      await tester.tap(find.byKey(DatePickerFormField.textInputKey));
      await tester.pump();
      expect(focusNode.hasFocus, isTrue);
      focusNode.dispose();
    });

    testWidgets('uses defaultFirstDate and defaultLastDate when not provided', (tester) async {
      expect(defaultFirstDate, DateTime(1900));
      expect(defaultLastDate, DateTime(2099, 12, 31));

      await pumpDatePicker(
        tester,
        passFirstLast: false,
      );
      await tester.tap(find.byKey(DatePickerFormField.launchDatePickerKey));
      await tester.pumpAndSettle();

      expect(find.byType(DatePickerDialog), findsOneWidget);
      final cancelButton = find.byType(TextButton).first;
      await tester.tap(cancelButton);
      await tester.pumpAndSettle();
    });

    testWidgets('clamps initial date when before firstDate or after lastDate', (tester) async {
      // Proposed date is before firstDate -> clamps to firstDate
      await pumpDatePicker(
        tester,
        initialDate: DateTime(1990),
        firstDate: DateTime(2000),
        lastDate: DateTime(2010),
      );
      await tester.tap(find.byKey(DatePickerFormField.launchDatePickerKey));
      await tester.pumpAndSettle();

      expect(find.byType(DatePickerDialog), findsOneWidget);
      var cancelButton = find.byType(TextButton).first;
      await tester.tap(cancelButton);
      await tester.pumpAndSettle();

      // Proposed date is after lastDate -> clamps to lastDate
      await pumpDatePicker(
        tester,
        initialDate: DateTime(2025),
        firstDate: DateTime(2000),
        lastDate: DateTime(2010),
      );
      await tester.tap(find.byKey(DatePickerFormField.launchDatePickerKey));
      await tester.pumpAndSettle();

      expect(find.byType(DatePickerDialog), findsOneWidget);
      cancelButton = find.byType(TextButton).first;
      await tester.tap(cancelButton);
      await tester.pumpAndSettle();
    });
    testWidgets('calls onDateChanged with parsed date when valid and null when invalid/incomplete', (tester) async {
      final changedDates = <DateInputValue>[];
      await pumpDatePicker(
        tester,
        firstDate: DateTime(1900),
        lastDate: DateTime(2099, 12, 31),
        onDateChanged: changedDates.add,
      );

      // Incomplete text typing
      await typeIntoDateField(tester, '31');
      expect(changedDates.last.parsedDate, isNull);

      await typeIntoDateField(tester, '10');
      expect(changedDates.last.parsedDate, isNull);

      // Complete valid date 31/10/1999
      await typeIntoDateField(tester, '1999');
      expect(changedDates.last.parsedDate, DateTime(1999, 10, 31));

      // Invalid date (e.g. backspace and type an invalid year or month)
      // Backspace 4 times over year
      for (int i = 0; i < 4; i++) {
        await backspaceInDateField(tester);
      }
      expect(changedDates.last.parsedDate, isNull);

      // Date parsed even when before firstDate (e.g. year 1899)
      await typeIntoDateField(tester, '1899');
      expect(changedDates.last.parsedDate, DateTime(1899, 10, 31));

      // Date parsed even when after lastDate (e.g. year 2100)
      for (int i = 0; i < 4; i++) {
        await backspaceInDateField(tester);
      }
      await typeIntoDateField(tester, '2100');
      expect(changedDates.last.parsedDate, DateTime(2100, 10, 31));

      // Invalid date format/digits: 31/02/2026 (triggers catch on parseStrict)
      for (int i = 0; i < 10; i++) {
        await backspaceInDateField(tester);
      }
      await typeIntoDateField(tester, '31022026');
      expect(changedDates.last.parsedDate, isNull);

    });

    testWidgets('calls onDateChanged when date is selected from calendar picker', (tester) async {
      DateInputValue changedDate = (parsedDate: null, rawText: '');
      final selectedDate = DateTime(1999, 10, 31);
      await pumpDatePicker(
        tester,
        initialDate: selectedDate,
        firstDate: DateTime(1900),
        lastDate: DateTime(2099, 12, 31),
        onDateChanged: (date) => changedDate = date,
      );

      await tester.tap(find.byKey(DatePickerFormField.launchDatePickerKey));
      await tester.pumpAndSettle();

      final okButton = find.byType(TextButton).last;
      await tester.tap(okButton);
      await tester.pumpAndSettle();

      expect(changedDate.parsedDate, selectedDate);
    });

    testWidgets('validator and onSaved integrate with the enclosing Form', (tester) async {
      final formKey = GlobalKey<FormState>();
      DateTime? savedDate;

      await tester.pumpWidget(
        buildTestWidget(
          formKey: formKey,
          validator: (date) => date == null ? 'Enter a valid date' : null,
          onSaved: (date) => savedDate = date,
        ),
      );
      await tester.pumpAndSettle();

      // An empty field fails validation and surfaces the validator's message.
      expect(formKey.currentState!.validate(), isFalse);
      await tester.pumpAndSettle();
      expect(find.text('Enter a valid date'), findsOneWidget);

      // 15/11/1995 in the field's en-GB format.
      await typeIntoDateField(tester, '15111995');
      await tester.pumpAndSettle();

      expect(formKey.currentState!.validate(), isTrue);
      await tester.pumpAndSettle();
      expect(find.text('Enter a valid date'), findsNothing);

      // Saving the form hands the parsed DateTime, not the raw text, to onSaved.
      formKey.currentState!.save();
      expect(savedDate, DateTime(1995, 11, 15));
    });

    testWidgets('validator receives null for a syntactically invalid date', (tester) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        buildTestWidget(
          formKey: formKey,
          validator: (date) => date == null ? 'Enter a valid date' : null,
        ),
      );
      await tester.pumpAndSettle();

      // 31/02/1999 is complete but not a real date.
      await typeIntoDateField(tester, '31021999');
      await tester.pumpAndSettle();

      expect(formKey.currentState!.validate(), isFalse);
      await tester.pumpAndSettle();
      expect(find.text('Enter a valid date'), findsOneWidget);
    });

  });
}
