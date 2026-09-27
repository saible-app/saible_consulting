import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:saible_core/domain/iso3166_countries.dart';
import 'package:saible_core/l10n/app_localizations.dart';

/// Renders a flag icon using emoji text for a given country.
class const FlagIcon.forIso3166({super.key, required this.country}) extends StatelessWidget {
  /// The country whose flag is rendered.
  final Iso3166Country country;

  /// Creates a flag icon for the given [country].
  this;

  @override
  Widget build(BuildContext context) => Text(country.flagEmoji(), style: Theme.of(context).textTheme.headlineSmall);
}

/// A list tile displaying a country's flag and localized name.
class const NationTile({super.key, required this.country, this.onTap}) extends StatelessWidget {
  /// Called when the tile is tapped.
  final void Function()? onTap;

  /// The country displayed in this tile.
  final Iso3166Country country;

  /// Creates a [NationTile] displaying [country] with optional [onTap] handler.
  this;

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<CountryLocalizations>();
    return ListTile(
      leading: FlagIcon.forIso3166(country: country),
      title: Text(country.tr(locale)),
      onTap: onTap,
    );
  }
}

/// A list tile displaying a country's flag, localized name, and phone calling code.
class const PhoneCodeTile({super.key, required this.country, this.onTap}) extends StatelessWidget {
  /// Called when the tile is tapped.
  final void Function()? onTap;

  /// The country displayed in this tile.
  final Iso3166Country country;

  /// Creates a [PhoneCodeTile] displaying [country] with optional [onTap] handler.
  this;

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<CountryLocalizations>();
    return ListTile(
      leading: FlagIcon.forIso3166(country: country),
      title: Text(country.tr(locale)),
      subtitle: Text('+${country.phoneCode}'),
      onTap: onTap,
    );
  }
}
