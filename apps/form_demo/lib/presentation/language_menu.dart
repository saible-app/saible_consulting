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

import 'package:form_demo/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// The locales the demo app ships translations for, paired with each
/// language's endonym as shown in the language switcher menu.
///
/// English is bound to [Locale('en', 'GB')], the app's default language,
/// so the active-language tick appears for the default locale and
/// selecting English restores it.
const List<(Locale, String)> appLanguages = [
  (Locale('en', 'GB'), 'English'),
  (Locale('fr'), 'Français'),
  (Locale('de'), 'Deutsch'),
  (Locale('cy'), 'Cymraeg'),
  (Locale('ja'), '日本語'),
];

/// An app bar icon that opens a menu of the locales in [appLanguages],
/// marking the active one with a tick, and reports the chosen locale to
/// [onLocaleChanged].
class const LanguageSwitcher({super.key, required this.onLocaleChanged}) extends StatelessWidget {
  /// The key assigned to the [PopupMenuButton] trigger in the app bar.
  static const Key switcherButtonKey = Key('languageSwitcher_button');

  /// Creates a menu item key for the given language code.
  static Key menuItemKey(Locale locale) => Key('languageSwitcher_${locale.languageCode}');

  /// Callback invoked when a new [Locale] is selected from the menu.
  final ValueChanged<Locale> onLocaleChanged;

  /// Creates a [LanguageSwitcher] that reports selection changes via [onLocaleChanged].
  this;

  @override
  Widget build(BuildContext context) {
    final activeLocale = Localizations.localeOf(context);
    return PopupMenuButton<Locale>(
      key: switcherButtonKey,
      tooltip: AppLocalizations.of(context).languageMenuTooltip,
      icon: const Icon(Icons.language),
      initialValue: activeLocale,
      onSelected: onLocaleChanged,
      itemBuilder: (context) => [
        for (final (locale, endonym) in appLanguages)
          PopupMenuItem(
            key: menuItemKey(locale),
            value: locale,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 24, child: locale == activeLocale ? const Icon(Icons.check) : null),
                const SizedBox(width: 8),
                Text(endonym),
              ],
            ),
          ),
      ],
    );
  }
}
