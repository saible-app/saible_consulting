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

  /// The [Key] for the cancel button in the Cupertino date picker toolbar.
  static const cancelButtonKey = Key('cupertinoDatePicker_cancelButton');

  /// The [Key] for the done button in the Cupertino date picker toolbar.
  static const doneButtonKey = Key('cupertinoDatePicker_doneButton');
  
  @override
  Future<DateTime?> show({
    required BuildContext context, 
    String? helpText, 
    DateTime? initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
  }) async {
    DateTime? dateTime;
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (popupContext) {
        final backgroundColor = CupertinoColors.systemBackground.resolveFrom(popupContext);
        final cupertinoLocalizations = Localizations.of<CupertinoLocalizations>(popupContext, CupertinoLocalizations);
        final cancelText = cupertinoLocalizations?.cancelButtonLabel ?? 'Cancel';
        return ColoredBox(
          color: backgroundColor,
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: CupertinoColors.secondarySystemBackground.resolveFrom(popupContext),
                    border: Border(
                      bottom: BorderSide(
                        color: CupertinoColors.separator.resolveFrom(popupContext),
                        width: 0,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CupertinoButton(
                        key: cancelButtonKey,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        onPressed: () {
                          dateTime = null;
                          Navigator.of(popupContext).pop();
                        },
                        child: Text(cancelText),
                      ),
                      if (helpText != null && helpText.isNotEmpty)
                        Expanded(
                          child: Text(
                            helpText,
                            textAlign: TextAlign.center,
                            style: CupertinoTheme.of(popupContext).textTheme.navTitleTextStyle,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      CupertinoButton(
                        key: doneButtonKey,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        onPressed: () {
                          dateTime ??= initialDate ?? DateTime.now();
                          Navigator.of(popupContext).pop();
                        },
                        child: const Text('Done'),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 216,
                  child: CupertinoDatePicker(
                    backgroundColor: backgroundColor,
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: initialDate,
                    minimumDate: firstDate,
                    maximumDate: lastDate,
                    onDateTimeChanged: (d) => dateTime = d,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    return dateTime;
  }
}
