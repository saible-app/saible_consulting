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

import 'package:date_picker_form_field/date_picker_form_field.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:material_ui/material_ui.dart';

/// Runs the `date_picker_form_field` example application.
///
/// Date formatting data is initialized before the first frame so that typed
/// input is parsed with the pattern of the active locale.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();
  runApp(const DatePickerExampleApp());
}

/// Root widget of the example.
class const DatePickerExampleApp({super.key}) extends StatelessWidget {
  /// Creates a [DatePickerExampleApp].
  this;

  @override
  Widget build(BuildContext context) =>
      const MaterialApp(home: DatePickerExamplePage());
}

/// A form page that captures a date of birth.
class const DatePickerExamplePage({super.key}) extends StatefulWidget {
  /// Creates a [DatePickerExamplePage].
  this;

  @override
  State<DatePickerExamplePage> createState() => _DatePickerExamplePageState();
}

class _DatePickerExamplePageState() extends State<DatePickerExamplePage> {
  DateTime? _dateOfBirth;

  @override
  Widget build(BuildContext context) {
    final DateTime? dateOfBirth = _dateOfBirth;
    return Scaffold(
      appBar: AppBar(title: const Text('date_picker_form_field')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DatePickerFormField(
              initialDate: DateTime(1995, 6, 15),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
              decoration: const InputDecoration(
                labelText: 'Date of birth',
                border: OutlineInputBorder(),
              ),
              onDateChanged: (DateInputValue value) =>
                  setState(() => _dateOfBirth = value.parsedDate),
            ),
            const SizedBox(height: 24),
            Text(
              dateOfBirth == null
                  ? 'Type a complete date, or use the calendar button.'
                  : 'Parsed date: ${_formatDate(dateOfBirth)}',
            ),
          ],
        ),
      ),
    );
  }

  /// Formats [date] as an ISO-8601 calendar date, e.g. `2026-09-28`.
  String _formatDate(DateTime date) =>
      date.toIso8601String().substring(0, 10);
}
