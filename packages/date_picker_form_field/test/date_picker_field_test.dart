import 'package:date_picker_form_field/application/date_input_state.dart';
import 'package:date_picker_form_field/presentation/date_picker_form_field.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:material_ui/material_ui.dart';
import 'package:saible_core/domain/date_inputs.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('en-GB');
    await initializeDateFormatting();
  });

  Widget buildTestWidget({
    Locale locale = const Locale('en', 'GB'),
    DateInputState? initial,
    InputDecoration? decoration,
    String? pickerHelpText,
    FocusNode? focusNode,
    void Function(DateTime)? onPickDate,
    void Function(String)? onEditText,
    void Function(String)? onFieldSubmitted,
    void Function()? onEditingComplete,
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
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      home: Scaffold(
        body: Center(
          child: DatePickerFormField(
            initial: initial ?? DateInputState.pure(first, last),
            decoration: decoration ?? const InputDecoration(labelText: 'Date of Birth'),
            pickerHelpText: pickerHelpText,
            focusNode: focusNode,
            onPickDate: onPickDate ?? (_) {},
            onEditText: onEditText ?? (_) {},
            onFieldSubmitted: onFieldSubmitted,
            onEditingComplete: onEditingComplete,
          ),
        ),
      ),
    );
  }

  Future<void> pumpDatePicker(
    WidgetTester tester, {
    Locale locale = const Locale('en', 'GB'),
    DateInputState? initial,
    InputDecoration? decoration,
    String? pickerHelpText,
    FocusNode? focusNode,
    void Function(DateTime)? onPickDate,
    void Function(String)? onEditText,
    void Function(String)? onFieldSubmitted,
    void Function()? onEditingComplete,
  }) async {
    await tester.pumpWidget(
      buildTestWidget(
        locale: locale,
        initial: initial,
        decoration: decoration,
        pickerHelpText: pickerHelpText,
        focusNode: focusNode,
        onPickDate: onPickDate,
        onEditText: onEditText,
        onFieldSubmitted: onFieldSubmitted,
        onEditingComplete: onEditingComplete,
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
    final newText = currentText.substring(0, currentText.length - 1);
    tester.testTextInput.enterText(newText);
    await tester.pump();
    return tester.widget<EditableText>(editableFinder).controller.text;
  }

  group('DatePickerField - Rendering and Initialization', () {
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

      final editable = tester.widget<EditableText>(
        find.descendant(of: find.byKey(DatePickerFormField.textInputKey), matching: find.byType(EditableText)),
      );
      expect(editable.controller.text, isEmpty);
    });

    testWidgets('formats initial current date according to locale en-GB', (tester) async {
      final initial = DateInputState.dirty(
        inputs: DateInputs(
          current: DateTime(1999, 10, 31),
          text: '',
          first: DateTime(1900),
          last: DateTime(2100, 12, 31),
        ),
      );
      await pumpDatePicker(tester, initial: initial);

      final editable = tester.widget<EditableText>(
        find.descendant(of: find.byKey(DatePickerFormField.textInputKey), matching: find.byType(EditableText)),
      );
      expect(editable.controller.text, '31/10/1999');
    });

    testWidgets('formats initial current date according to locale en-US', (tester) async {
      final initial = DateInputState.dirty(
        inputs: DateInputs(
          current: DateTime(1999, 10, 31),
          text: '',
          first: DateTime(1900),
          last: DateTime(2100, 12, 31),
        ),
      );
      await pumpDatePicker(tester, locale: const Locale('en', 'US'), initial: initial);

      final editable = tester.widget<EditableText>(
        find.descendant(of: find.byKey(DatePickerFormField.textInputKey), matching: find.byType(EditableText)),
      );
      expect(editable.controller.text, '10/31/1999');
    });
  });

  group('DatePickerField - Text Input Formatting Across Locales', () {
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

  group('DatePickerField - Backspacing', () {
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

  group('DatePickerField - Callbacks and User Interactions', () {
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
      await pumpDatePicker(
        tester,
        onEditingComplete: () => completed = true,
      );

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
      final initial = DateInputState.dirty(
        inputs: DateInputs(
          current: initialDate,
          text: '',
          first: DateTime(1900),
          last: DateTime(2100, 12, 31),
        ),
      );

      await pumpDatePicker(
        tester,
        initial: initial,
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
  });
}
