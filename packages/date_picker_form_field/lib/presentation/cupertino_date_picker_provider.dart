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

import 'dart:async';

import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:date_picker_form_field/presentation/adaptive_date_picker_provider.dart';

/// Shows a date picker using the Cupertino UI library. This is primarily for Apple-supported platforms,
/// confirming to their native UI date-picking implementation.
final class CupertinoDatePickerProvider() extends AdaptiveDatePickerProvider {

  /// Creates a [CupertinoDatePickerProvider]
  this;
  
  @override
  Future<DateTime?> show({
    required BuildContext context, 
    String? helpText, 
    DateTime? initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
  }) async {
    DateTime? dateTime;
    await showCupertinoModalPopup(
      context: context, 
      builder: (context) => SafeArea(
        top: false,
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.date,
          initialDateTime: initialDate,
          minimumDate: firstDate,
          maximumDate: lastDate,
          onDateTimeChanged: (d) => dateTime = d,
        ),
      ),
    );
    return dateTime;
  }
}
