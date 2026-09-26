import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:saible_core/domain/iso3166_countries.dart';
import 'package:saible_core/l10n/app_localizations.dart';

class const FlagIcon.forIso3166({super.key, required this.country}) extends StatelessWidget {
  final Iso3166Country country;
  this;
  @override
  Widget build(BuildContext context) => Text(country.flagEmoji(), style: Theme.of(context).textTheme.headlineSmall);
}

class const NationTile({super.key, required this.country, this.onTap}) extends StatelessWidget {
  final void Function()? onTap;
  final Iso3166Country country;

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

class const PhoneCodeTile({super.key, required this.country, this.onTap}) extends StatelessWidget {
  final void Function()? onTap;
  final Iso3166Country country;

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
