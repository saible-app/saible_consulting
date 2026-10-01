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

import 'package:date_picker_form_field/presentation/adaptive_date_picker_provider.dart';
import 'package:material_ui/material_ui.dart';

/// Shows a date picker using the Material UI library. This is primarily for Android and web platforms
/// (other than Safari or a native iOS browser)
final class MaterialDatePickerProvider() extends AdaptiveDatePickerProvider {

  /// Creates a [MaterialDatePickerProvider]
  this;

  @override
  Future<DateTime?> show({
    required BuildContext context, 
    String? helpText, 
    DateTime? initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
  }) => showDatePicker(
    context: context,
    helpText: helpText,
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
  );
}
