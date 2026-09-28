import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_bg.dart';
import 'app_localizations_bn.dart';
import 'app_localizations_ca.dart';
import 'app_localizations_cs.dart';
import 'app_localizations_cy.dart';
import 'app_localizations_da.dart';
import 'app_localizations_de.dart';
import 'app_localizations_el.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fa.dart';
import 'app_localizations_fi.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_he.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_hr.dart';
import 'app_localizations_hu.dart';
import 'app_localizations_id.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_ms.dart';
import 'app_localizations_nb.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ro.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_sk.dart';
import 'app_localizations_sr.dart';
import 'app_localizations_sv.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_th.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_uk.dart';
import 'app_localizations_ur.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of CountryLocalizations
/// returned by `CountryLocalizations.of(context)`.
///
/// Applications need to include `CountryLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: CountryLocalizations.localizationsDelegates,
///   supportedLocales: CountryLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the CountryLocalizations.supportedLocales
/// property.
abstract class CountryLocalizations {
  CountryLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static CountryLocalizations of(BuildContext context) {
    return Localizations.of<CountryLocalizations>(context, CountryLocalizations)!;
  }

  static const LocalizationsDelegate<CountryLocalizations> delegate = _CountryLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('bg'),
    Locale('bn'),
    Locale('ca'),
    Locale('cs'),
    Locale('cy'),
    Locale('da'),
    Locale('de'),
    Locale('el'),
    Locale('en'),
    Locale('en', 'GB'),
    Locale('es'),
    Locale('fa'),
    Locale('fi'),
    Locale('fr'),
    Locale('he'),
    Locale('hi'),
    Locale('hr'),
    Locale('hu'),
    Locale('id'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('ms'),
    Locale('nb'),
    Locale('nl'),
    Locale('pl'),
    Locale('pt'),
    Locale('ro'),
    Locale('ru'),
    Locale('sk'),
    Locale('sr'),
    Locale('sv'),
    Locale('ta'),
    Locale('th'),
    Locale('tr'),
    Locale('uk'),
    Locale('ur'),
    Locale('vi'),
    Locale('zh'),
  ];

  /// Name of Afghanistan
  ///
  /// In en_GB, this message translates to:
  /// **'Afghanistan'**
  String get country_AF;

  /// Name of Åland Islands
  ///
  /// In en_GB, this message translates to:
  /// **'Åland Islands'**
  String get country_AX;

  /// Name of Albania
  ///
  /// In en_GB, this message translates to:
  /// **'Albania'**
  String get country_AL;

  /// Name of Algeria
  ///
  /// In en_GB, this message translates to:
  /// **'Algeria'**
  String get country_DZ;

  /// Name of American Samoa
  ///
  /// In en_GB, this message translates to:
  /// **'American Samoa'**
  String get country_AS;

  /// Name of Andorra
  ///
  /// In en_GB, this message translates to:
  /// **'Andorra'**
  String get country_AD;

  /// Name of Angola
  ///
  /// In en_GB, this message translates to:
  /// **'Angola'**
  String get country_AO;

  /// Name of Anguilla
  ///
  /// In en_GB, this message translates to:
  /// **'Anguilla'**
  String get country_AI;

  /// Name of Antarctica
  ///
  /// In en_GB, this message translates to:
  /// **'Antarctica'**
  String get country_AQ;

  /// Name of Antigua and Barbuda
  ///
  /// In en_GB, this message translates to:
  /// **'Antigua and Barbuda'**
  String get country_AG;

  /// Name of Argentina
  ///
  /// In en_GB, this message translates to:
  /// **'Argentina'**
  String get country_AR;

  /// Name of Armenia
  ///
  /// In en_GB, this message translates to:
  /// **'Armenia'**
  String get country_AM;

  /// Name of Aruba
  ///
  /// In en_GB, this message translates to:
  /// **'Aruba'**
  String get country_AW;

  /// Name of Australia
  ///
  /// In en_GB, this message translates to:
  /// **'Australia'**
  String get country_AU;

  /// Name of Austria
  ///
  /// In en_GB, this message translates to:
  /// **'Austria'**
  String get country_AT;

  /// Name of Azerbaijan
  ///
  /// In en_GB, this message translates to:
  /// **'Azerbaijan'**
  String get country_AZ;

  /// Name of Bahamas
  ///
  /// In en_GB, this message translates to:
  /// **'Bahamas'**
  String get country_BS;

  /// Name of Bahrain
  ///
  /// In en_GB, this message translates to:
  /// **'Bahrain'**
  String get country_BH;

  /// Name of Bangladesh
  ///
  /// In en_GB, this message translates to:
  /// **'Bangladesh'**
  String get country_BD;

  /// Name of Barbados
  ///
  /// In en_GB, this message translates to:
  /// **'Barbados'**
  String get country_BB;

  /// Name of Belarus
  ///
  /// In en_GB, this message translates to:
  /// **'Belarus'**
  String get country_BY;

  /// Name of Belgium
  ///
  /// In en_GB, this message translates to:
  /// **'Belgium'**
  String get country_BE;

  /// Name of Belize
  ///
  /// In en_GB, this message translates to:
  /// **'Belize'**
  String get country_BZ;

  /// Name of Benin
  ///
  /// In en_GB, this message translates to:
  /// **'Benin'**
  String get country_BJ;

  /// Name of Bermuda
  ///
  /// In en_GB, this message translates to:
  /// **'Bermuda'**
  String get country_BM;

  /// Name of Bhutan
  ///
  /// In en_GB, this message translates to:
  /// **'Bhutan'**
  String get country_BT;

  /// Name of Bolivia (Plurinational State of)
  ///
  /// In en_GB, this message translates to:
  /// **'Bolivia (Plurinational State of)'**
  String get country_BO;

  /// Name of Bonaire, Sint Eustatius and Saba
  ///
  /// In en_GB, this message translates to:
  /// **'Bonaire, Sint Eustatius and Saba'**
  String get country_BQ;

  /// Name of Bosnia and Herzegovina
  ///
  /// In en_GB, this message translates to:
  /// **'Bosnia and Herzegovina'**
  String get country_BA;

  /// Name of Botswana
  ///
  /// In en_GB, this message translates to:
  /// **'Botswana'**
  String get country_BW;

  /// Name of Bouvet Island
  ///
  /// In en_GB, this message translates to:
  /// **'Bouvet Island'**
  String get country_BV;

  /// Name of Brazil
  ///
  /// In en_GB, this message translates to:
  /// **'Brazil'**
  String get country_BR;

  /// Name of British Indian Ocean Territory
  ///
  /// In en_GB, this message translates to:
  /// **'British Indian Ocean Territory'**
  String get country_IO;

  /// Name of Brunei Darussalam
  ///
  /// In en_GB, this message translates to:
  /// **'Brunei Darussalam'**
  String get country_BN;

  /// Name of Bulgaria
  ///
  /// In en_GB, this message translates to:
  /// **'Bulgaria'**
  String get country_BG;

  /// Name of Burkina Faso
  ///
  /// In en_GB, this message translates to:
  /// **'Burkina Faso'**
  String get country_BF;

  /// Name of Burundi
  ///
  /// In en_GB, this message translates to:
  /// **'Burundi'**
  String get country_BI;

  /// Name of Cabo Verde
  ///
  /// In en_GB, this message translates to:
  /// **'Cabo Verde'**
  String get country_CV;

  /// Name of Cambodia
  ///
  /// In en_GB, this message translates to:
  /// **'Cambodia'**
  String get country_KH;

  /// Name of Cameroon
  ///
  /// In en_GB, this message translates to:
  /// **'Cameroon'**
  String get country_CM;

  /// Name of Canada
  ///
  /// In en_GB, this message translates to:
  /// **'Canada'**
  String get country_CA;

  /// Name of Cayman Islands
  ///
  /// In en_GB, this message translates to:
  /// **'Cayman Islands'**
  String get country_KY;

  /// Name of Central African Republic
  ///
  /// In en_GB, this message translates to:
  /// **'Central African Republic'**
  String get country_CF;

  /// Name of Chad
  ///
  /// In en_GB, this message translates to:
  /// **'Chad'**
  String get country_TD;

  /// Name of Chile
  ///
  /// In en_GB, this message translates to:
  /// **'Chile'**
  String get country_CL;

  /// Name of China
  ///
  /// In en_GB, this message translates to:
  /// **'China'**
  String get country_CN;

  /// Name of Christmas Island
  ///
  /// In en_GB, this message translates to:
  /// **'Christmas Island'**
  String get country_CX;

  /// Name of Cocos (Keeling) Islands
  ///
  /// In en_GB, this message translates to:
  /// **'Cocos (Keeling) Islands'**
  String get country_CC;

  /// Name of Colombia
  ///
  /// In en_GB, this message translates to:
  /// **'Colombia'**
  String get country_CO;

  /// Name of Comoros
  ///
  /// In en_GB, this message translates to:
  /// **'Comoros'**
  String get country_KM;

  /// Name of Congo
  ///
  /// In en_GB, this message translates to:
  /// **'Congo'**
  String get country_CD;

  /// Name of Congo (the Democratic Republic of the)
  ///
  /// In en_GB, this message translates to:
  /// **'Congo (the Democratic Republic of the)'**
  String get country_CG;

  /// Name of Cook Islands
  ///
  /// In en_GB, this message translates to:
  /// **'Cook Islands'**
  String get country_CK;

  /// Name of Costa Rica
  ///
  /// In en_GB, this message translates to:
  /// **'Costa Rica'**
  String get country_CR;

  /// Name of Côte d'Ivoire
  ///
  /// In en_GB, this message translates to:
  /// **'Côte d\'Ivoire'**
  String get country_CI;

  /// Name of Croatia
  ///
  /// In en_GB, this message translates to:
  /// **'Croatia'**
  String get country_HR;

  /// Name of Cuba
  ///
  /// In en_GB, this message translates to:
  /// **'Cuba'**
  String get country_CU;

  /// Name of Curaçao
  ///
  /// In en_GB, this message translates to:
  /// **'Curaçao'**
  String get country_CW;

  /// Name of Cyprus
  ///
  /// In en_GB, this message translates to:
  /// **'Cyprus'**
  String get country_CY;

  /// Name of Czechia
  ///
  /// In en_GB, this message translates to:
  /// **'Czechia'**
  String get country_CZ;

  /// Name of Denmark
  ///
  /// In en_GB, this message translates to:
  /// **'Denmark'**
  String get country_DK;

  /// Name of Djibouti
  ///
  /// In en_GB, this message translates to:
  /// **'Djibouti'**
  String get country_DJ;

  /// Name of Dominica
  ///
  /// In en_GB, this message translates to:
  /// **'Dominica'**
  String get country_DM;

  /// Name of Dominican Republic
  ///
  /// In en_GB, this message translates to:
  /// **'Dominican Republic'**
  String get country_DO;

  /// Name of Ecuador
  ///
  /// In en_GB, this message translates to:
  /// **'Ecuador'**
  String get country_EC;

  /// Name of Egypt
  ///
  /// In en_GB, this message translates to:
  /// **'Egypt'**
  String get country_EG;

  /// Name of El Salvador
  ///
  /// In en_GB, this message translates to:
  /// **'El Salvador'**
  String get country_SV;

  /// Name of Equatorial Guinea
  ///
  /// In en_GB, this message translates to:
  /// **'Equatorial Guinea'**
  String get country_GQ;

  /// Name of Eritrea
  ///
  /// In en_GB, this message translates to:
  /// **'Eritrea'**
  String get country_ER;

  /// Name of Estonia
  ///
  /// In en_GB, this message translates to:
  /// **'Estonia'**
  String get country_EE;

  /// Name of Eswatini
  ///
  /// In en_GB, this message translates to:
  /// **'Eswatini'**
  String get country_SZ;

  /// Name of Ethiopia
  ///
  /// In en_GB, this message translates to:
  /// **'Ethiopia'**
  String get country_ET;

  /// Name of Falkland Islands [Malvinas]
  ///
  /// In en_GB, this message translates to:
  /// **'Falkland Islands [Malvinas]'**
  String get country_FK;

  /// Name of Faroe Islands
  ///
  /// In en_GB, this message translates to:
  /// **'Faroe Islands'**
  String get country_FO;

  /// Name of Fiji
  ///
  /// In en_GB, this message translates to:
  /// **'Fiji'**
  String get country_FJ;

  /// Name of Finland
  ///
  /// In en_GB, this message translates to:
  /// **'Finland'**
  String get country_FI;

  /// Name of France
  ///
  /// In en_GB, this message translates to:
  /// **'France'**
  String get country_FR;

  /// Name of French Guiana
  ///
  /// In en_GB, this message translates to:
  /// **'French Guiana'**
  String get country_GF;

  /// Name of French Polynesia
  ///
  /// In en_GB, this message translates to:
  /// **'French Polynesia'**
  String get country_PF;

  /// Name of French Southern Territories
  ///
  /// In en_GB, this message translates to:
  /// **'French Southern Territories'**
  String get country_TF;

  /// Name of Gabon
  ///
  /// In en_GB, this message translates to:
  /// **'Gabon'**
  String get country_GA;

  /// Name of Gambia
  ///
  /// In en_GB, this message translates to:
  /// **'Gambia'**
  String get country_GM;

  /// Name of Georgia
  ///
  /// In en_GB, this message translates to:
  /// **'Georgia'**
  String get country_GE;

  /// Name of Germany
  ///
  /// In en_GB, this message translates to:
  /// **'Germany'**
  String get country_DE;

  /// Name of Ghana
  ///
  /// In en_GB, this message translates to:
  /// **'Ghana'**
  String get country_GH;

  /// Name of Gibraltar
  ///
  /// In en_GB, this message translates to:
  /// **'Gibraltar'**
  String get country_GI;

  /// Name of Greece
  ///
  /// In en_GB, this message translates to:
  /// **'Greece'**
  String get country_GR;

  /// Name of Greenland
  ///
  /// In en_GB, this message translates to:
  /// **'Greenland'**
  String get country_GL;

  /// Name of Grenada
  ///
  /// In en_GB, this message translates to:
  /// **'Grenada'**
  String get country_GD;

  /// Name of Guadeloupe
  ///
  /// In en_GB, this message translates to:
  /// **'Guadeloupe'**
  String get country_GP;

  /// Name of Guam
  ///
  /// In en_GB, this message translates to:
  /// **'Guam'**
  String get country_GU;

  /// Name of Guatemala
  ///
  /// In en_GB, this message translates to:
  /// **'Guatemala'**
  String get country_GT;

  /// Name of Guernsey
  ///
  /// In en_GB, this message translates to:
  /// **'Guernsey'**
  String get country_GG;

  /// Name of Guinea
  ///
  /// In en_GB, this message translates to:
  /// **'Guinea'**
  String get country_GN;

  /// Name of Guinea-Bissau
  ///
  /// In en_GB, this message translates to:
  /// **'Guinea-Bissau'**
  String get country_GW;

  /// Name of Guyana
  ///
  /// In en_GB, this message translates to:
  /// **'Guyana'**
  String get country_GY;

  /// Name of Haiti
  ///
  /// In en_GB, this message translates to:
  /// **'Haiti'**
  String get country_HT;

  /// Name of Heard Island and McDonald Islands
  ///
  /// In en_GB, this message translates to:
  /// **'Heard Island and McDonald Islands'**
  String get country_HM;

  /// Name of Holy See
  ///
  /// In en_GB, this message translates to:
  /// **'Holy See'**
  String get country_VA;

  /// Name of Honduras
  ///
  /// In en_GB, this message translates to:
  /// **'Honduras'**
  String get country_HN;

  /// Name of Hong Kong
  ///
  /// In en_GB, this message translates to:
  /// **'Hong Kong'**
  String get country_HK;

  /// Name of Hungary
  ///
  /// In en_GB, this message translates to:
  /// **'Hungary'**
  String get country_HU;

  /// Name of Iceland
  ///
  /// In en_GB, this message translates to:
  /// **'Iceland'**
  String get country_IS;

  /// Name of India
  ///
  /// In en_GB, this message translates to:
  /// **'India'**
  String get country_IN;

  /// Name of Indonesia
  ///
  /// In en_GB, this message translates to:
  /// **'Indonesia'**
  String get country_ID;

  /// Name of Iran (Islamic Republic of)
  ///
  /// In en_GB, this message translates to:
  /// **'Iran (Islamic Republic of)'**
  String get country_IR;

  /// Name of Iraq
  ///
  /// In en_GB, this message translates to:
  /// **'Iraq'**
  String get country_IQ;

  /// Name of Ireland
  ///
  /// In en_GB, this message translates to:
  /// **'Ireland'**
  String get country_IE;

  /// Name of Isle of Man
  ///
  /// In en_GB, this message translates to:
  /// **'Isle of Man'**
  String get country_IM;

  /// Name of Israel
  ///
  /// In en_GB, this message translates to:
  /// **'Israel'**
  String get country_IL;

  /// Name of Italy
  ///
  /// In en_GB, this message translates to:
  /// **'Italy'**
  String get country_IT;

  /// Name of Jamaica
  ///
  /// In en_GB, this message translates to:
  /// **'Jamaica'**
  String get country_JM;

  /// Name of Japan
  ///
  /// In en_GB, this message translates to:
  /// **'Japan'**
  String get country_JP;

  /// Name of Jersey
  ///
  /// In en_GB, this message translates to:
  /// **'Jersey'**
  String get country_JE;

  /// Name of Jordan
  ///
  /// In en_GB, this message translates to:
  /// **'Jordan'**
  String get country_JO;

  /// Name of Kazakhstan
  ///
  /// In en_GB, this message translates to:
  /// **'Kazakhstan'**
  String get country_KZ;

  /// Name of Kenya
  ///
  /// In en_GB, this message translates to:
  /// **'Kenya'**
  String get country_KE;

  /// Name of Kiribati
  ///
  /// In en_GB, this message translates to:
  /// **'Kiribati'**
  String get country_KI;

  /// Name of Korea (the Democratic People's Republic of)
  ///
  /// In en_GB, this message translates to:
  /// **'Korea (the Democratic People\'s Republic of)'**
  String get country_KP;

  /// Name of Korea (the Republic of)
  ///
  /// In en_GB, this message translates to:
  /// **'Korea (the Republic of)'**
  String get country_KR;

  /// Name of Kuwait
  ///
  /// In en_GB, this message translates to:
  /// **'Kuwait'**
  String get country_KW;

  /// Name of Kyrgyzstan
  ///
  /// In en_GB, this message translates to:
  /// **'Kyrgyzstan'**
  String get country_KG;

  /// Name of Lao People's Democratic Republic
  ///
  /// In en_GB, this message translates to:
  /// **'Lao People\'s Democratic Republic'**
  String get country_LA;

  /// Name of Latvia
  ///
  /// In en_GB, this message translates to:
  /// **'Latvia'**
  String get country_LV;

  /// Name of Lebanon
  ///
  /// In en_GB, this message translates to:
  /// **'Lebanon'**
  String get country_LB;

  /// Name of Lesotho
  ///
  /// In en_GB, this message translates to:
  /// **'Lesotho'**
  String get country_LS;

  /// Name of Liberia
  ///
  /// In en_GB, this message translates to:
  /// **'Liberia'**
  String get country_LR;

  /// Name of Libya
  ///
  /// In en_GB, this message translates to:
  /// **'Libya'**
  String get country_LY;

  /// Name of Liechtenstein
  ///
  /// In en_GB, this message translates to:
  /// **'Liechtenstein'**
  String get country_LI;

  /// Name of Lithuania
  ///
  /// In en_GB, this message translates to:
  /// **'Lithuania'**
  String get country_LT;

  /// Name of Luxembourg
  ///
  /// In en_GB, this message translates to:
  /// **'Luxembourg'**
  String get country_LU;

  /// Name of Macao
  ///
  /// In en_GB, this message translates to:
  /// **'Macao'**
  String get country_MO;

  /// Name of Madagascar
  ///
  /// In en_GB, this message translates to:
  /// **'Madagascar'**
  String get country_MG;

  /// Name of Malawi
  ///
  /// In en_GB, this message translates to:
  /// **'Malawi'**
  String get country_MW;

  /// Name of Malaysia
  ///
  /// In en_GB, this message translates to:
  /// **'Malaysia'**
  String get country_MY;

  /// Name of Maldives
  ///
  /// In en_GB, this message translates to:
  /// **'Maldives'**
  String get country_MV;

  /// Name of Mali
  ///
  /// In en_GB, this message translates to:
  /// **'Mali'**
  String get country_ML;

  /// Name of Malta
  ///
  /// In en_GB, this message translates to:
  /// **'Malta'**
  String get country_MT;

  /// Name of Marshall Islands
  ///
  /// In en_GB, this message translates to:
  /// **'Marshall Islands'**
  String get country_MH;

  /// Name of Martinique
  ///
  /// In en_GB, this message translates to:
  /// **'Martinique'**
  String get country_MQ;

  /// Name of Mauritania
  ///
  /// In en_GB, this message translates to:
  /// **'Mauritania'**
  String get country_MR;

  /// Name of Mauritius
  ///
  /// In en_GB, this message translates to:
  /// **'Mauritius'**
  String get country_MU;

  /// Name of Mayotte
  ///
  /// In en_GB, this message translates to:
  /// **'Mayotte'**
  String get country_YT;

  /// Name of Mexico
  ///
  /// In en_GB, this message translates to:
  /// **'Mexico'**
  String get country_MX;

  /// Name of Micronesia (Federated States of)
  ///
  /// In en_GB, this message translates to:
  /// **'Micronesia (Federated States of)'**
  String get country_FM;

  /// Name of Moldova (the Republic of)
  ///
  /// In en_GB, this message translates to:
  /// **'Moldova (the Republic of)'**
  String get country_MD;

  /// Name of Monaco
  ///
  /// In en_GB, this message translates to:
  /// **'Monaco'**
  String get country_MC;

  /// Name of Mongolia
  ///
  /// In en_GB, this message translates to:
  /// **'Mongolia'**
  String get country_MN;

  /// Name of Montenegro
  ///
  /// In en_GB, this message translates to:
  /// **'Montenegro'**
  String get country_ME;

  /// Name of Montserrat
  ///
  /// In en_GB, this message translates to:
  /// **'Montserrat'**
  String get country_MS;

  /// Name of Morocco
  ///
  /// In en_GB, this message translates to:
  /// **'Morocco'**
  String get country_MA;

  /// Name of Mozambique
  ///
  /// In en_GB, this message translates to:
  /// **'Mozambique'**
  String get country_MZ;

  /// Name of Myanmar
  ///
  /// In en_GB, this message translates to:
  /// **'Myanmar'**
  String get country_MM;

  /// Name of Namibia
  ///
  /// In en_GB, this message translates to:
  /// **'Namibia'**
  String get country_NA;

  /// Name of Nauru
  ///
  /// In en_GB, this message translates to:
  /// **'Nauru'**
  String get country_NR;

  /// Name of Nepal
  ///
  /// In en_GB, this message translates to:
  /// **'Nepal'**
  String get country_NP;

  /// Name of Netherlands
  ///
  /// In en_GB, this message translates to:
  /// **'Netherlands'**
  String get country_NL;

  /// Name of New Caledonia
  ///
  /// In en_GB, this message translates to:
  /// **'New Caledonia'**
  String get country_NC;

  /// Name of New Zealand
  ///
  /// In en_GB, this message translates to:
  /// **'New Zealand'**
  String get country_NZ;

  /// Name of Nicaragua
  ///
  /// In en_GB, this message translates to:
  /// **'Nicaragua'**
  String get country_NI;

  /// Name of Niger
  ///
  /// In en_GB, this message translates to:
  /// **'Niger'**
  String get country_NE;

  /// Name of Nigeria
  ///
  /// In en_GB, this message translates to:
  /// **'Nigeria'**
  String get country_NG;

  /// Name of Niue
  ///
  /// In en_GB, this message translates to:
  /// **'Niue'**
  String get country_NU;

  /// Name of Norfolk Island
  ///
  /// In en_GB, this message translates to:
  /// **'Norfolk Island'**
  String get country_NF;

  /// Name of North Macedonia
  ///
  /// In en_GB, this message translates to:
  /// **'North Macedonia'**
  String get country_MK;

  /// Name of Northern Mariana Islands
  ///
  /// In en_GB, this message translates to:
  /// **'Northern Mariana Islands'**
  String get country_MP;

  /// Name of Norway
  ///
  /// In en_GB, this message translates to:
  /// **'Norway'**
  String get country_NO;

  /// Name of Oman
  ///
  /// In en_GB, this message translates to:
  /// **'Oman'**
  String get country_OM;

  /// Name of Pakistan
  ///
  /// In en_GB, this message translates to:
  /// **'Pakistan'**
  String get country_PK;

  /// Name of Palau
  ///
  /// In en_GB, this message translates to:
  /// **'Palau'**
  String get country_PW;

  /// Name of Palestine, State of
  ///
  /// In en_GB, this message translates to:
  /// **'Palestine, State of'**
  String get country_PS;

  /// Name of Panama
  ///
  /// In en_GB, this message translates to:
  /// **'Panama'**
  String get country_PA;

  /// Name of Papua New Guinea
  ///
  /// In en_GB, this message translates to:
  /// **'Papua New Guinea'**
  String get country_PG;

  /// Name of Paraguay
  ///
  /// In en_GB, this message translates to:
  /// **'Paraguay'**
  String get country_PY;

  /// Name of Peru
  ///
  /// In en_GB, this message translates to:
  /// **'Peru'**
  String get country_PE;

  /// Name of Philippines
  ///
  /// In en_GB, this message translates to:
  /// **'Philippines'**
  String get country_PH;

  /// Name of Pitcairn
  ///
  /// In en_GB, this message translates to:
  /// **'Pitcairn'**
  String get country_PN;

  /// Name of Poland
  ///
  /// In en_GB, this message translates to:
  /// **'Poland'**
  String get country_PL;

  /// Name of Portugal
  ///
  /// In en_GB, this message translates to:
  /// **'Portugal'**
  String get country_PT;

  /// Name of Puerto Rico
  ///
  /// In en_GB, this message translates to:
  /// **'Puerto Rico'**
  String get country_PR;

  /// Name of Qatar
  ///
  /// In en_GB, this message translates to:
  /// **'Qatar'**
  String get country_QA;

  /// Name of Réunion
  ///
  /// In en_GB, this message translates to:
  /// **'Réunion'**
  String get country_RE;

  /// Name of Romania
  ///
  /// In en_GB, this message translates to:
  /// **'Romania'**
  String get country_RO;

  /// Name of Russian Federation
  ///
  /// In en_GB, this message translates to:
  /// **'Russian Federation'**
  String get country_RU;

  /// Name of Rwanda
  ///
  /// In en_GB, this message translates to:
  /// **'Rwanda'**
  String get country_RW;

  /// Name of Saint Barthélemy
  ///
  /// In en_GB, this message translates to:
  /// **'Saint Barthélemy'**
  String get country_BL;

  /// Name of Saint Helena, Ascension and Tristan da Cunha
  ///
  /// In en_GB, this message translates to:
  /// **'Saint Helena, Ascension and Tristan da Cunha'**
  String get country_SH;

  /// Name of Saint Kitts and Nevis
  ///
  /// In en_GB, this message translates to:
  /// **'Saint Kitts and Nevis'**
  String get country_KN;

  /// Name of Saint Lucia
  ///
  /// In en_GB, this message translates to:
  /// **'Saint Lucia'**
  String get country_LC;

  /// Name of Saint Martin (French part)
  ///
  /// In en_GB, this message translates to:
  /// **'Saint Martin (French part)'**
  String get country_MF;

  /// Name of Saint Pierre and Miquelon
  ///
  /// In en_GB, this message translates to:
  /// **'Saint Pierre and Miquelon'**
  String get country_PM;

  /// Name of Saint Vincent and the Grenadines
  ///
  /// In en_GB, this message translates to:
  /// **'Saint Vincent and the Grenadines'**
  String get country_VC;

  /// Name of Samoa
  ///
  /// In en_GB, this message translates to:
  /// **'Samoa'**
  String get country_WS;

  /// Name of San Marino
  ///
  /// In en_GB, this message translates to:
  /// **'San Marino'**
  String get country_SM;

  /// Name of Sao Tome and Principe
  ///
  /// In en_GB, this message translates to:
  /// **'Sao Tome and Principe'**
  String get country_ST;

  /// Name of Saudi Arabia
  ///
  /// In en_GB, this message translates to:
  /// **'Saudi Arabia'**
  String get country_SA;

  /// Name of Senegal
  ///
  /// In en_GB, this message translates to:
  /// **'Senegal'**
  String get country_SN;

  /// Name of Serbia
  ///
  /// In en_GB, this message translates to:
  /// **'Serbia'**
  String get country_RS;

  /// Name of Seychelles
  ///
  /// In en_GB, this message translates to:
  /// **'Seychelles'**
  String get country_SC;

  /// Name of Sierra Leone
  ///
  /// In en_GB, this message translates to:
  /// **'Sierra Leone'**
  String get country_SL;

  /// Name of Singapore
  ///
  /// In en_GB, this message translates to:
  /// **'Singapore'**
  String get country_SG;

  /// Name of Sint Maarten (Dutch part)
  ///
  /// In en_GB, this message translates to:
  /// **'Sint Maarten (Dutch part)'**
  String get country_SX;

  /// Name of Slovakia
  ///
  /// In en_GB, this message translates to:
  /// **'Slovakia'**
  String get country_SK;

  /// Name of Slovenia
  ///
  /// In en_GB, this message translates to:
  /// **'Slovenia'**
  String get country_SI;

  /// Name of Solomon Islands
  ///
  /// In en_GB, this message translates to:
  /// **'Solomon Islands'**
  String get country_SB;

  /// Name of Somalia
  ///
  /// In en_GB, this message translates to:
  /// **'Somalia'**
  String get country_SO;

  /// Name of South Africa
  ///
  /// In en_GB, this message translates to:
  /// **'South Africa'**
  String get country_ZA;

  /// Name of South Georgia
  ///
  /// In en_GB, this message translates to:
  /// **'South Georgia'**
  String get country_GS;

  /// Name of South Sudan
  ///
  /// In en_GB, this message translates to:
  /// **'South Sudan'**
  String get country_SS;

  /// Name of Spain
  ///
  /// In en_GB, this message translates to:
  /// **'Spain'**
  String get country_ES;

  /// Name of Sri Lanka
  ///
  /// In en_GB, this message translates to:
  /// **'Sri Lanka'**
  String get country_LK;

  /// Name of Sudan
  ///
  /// In en_GB, this message translates to:
  /// **'Sudan'**
  String get country_SD;

  /// Name of Suriname
  ///
  /// In en_GB, this message translates to:
  /// **'Suriname'**
  String get country_SR;

  /// Name of Svalbard and Jan Mayen
  ///
  /// In en_GB, this message translates to:
  /// **'Svalbard and Jan Mayen'**
  String get country_SJ;

  /// Name of Sweden
  ///
  /// In en_GB, this message translates to:
  /// **'Sweden'**
  String get country_SE;

  /// Name of Switzerland
  ///
  /// In en_GB, this message translates to:
  /// **'Switzerland'**
  String get country_CH;

  /// Name of Syrian Arab Republic
  ///
  /// In en_GB, this message translates to:
  /// **'Syrian Arab Republic'**
  String get country_SY;

  /// Name of Taiwan (Province of China)
  ///
  /// In en_GB, this message translates to:
  /// **'Taiwan (Province of China)'**
  String get country_TW;

  /// Name of Tajikistan
  ///
  /// In en_GB, this message translates to:
  /// **'Tajikistan'**
  String get country_TJ;

  /// Name of Tanzania, the United Republic of
  ///
  /// In en_GB, this message translates to:
  /// **'Tanzania, the United Republic of'**
  String get country_TZ;

  /// Name of Thailand
  ///
  /// In en_GB, this message translates to:
  /// **'Thailand'**
  String get country_TH;

  /// Name of Timor-Leste
  ///
  /// In en_GB, this message translates to:
  /// **'Timor-Leste'**
  String get country_TL;

  /// Name of Togo
  ///
  /// In en_GB, this message translates to:
  /// **'Togo'**
  String get country_TG;

  /// Name of Tokelau
  ///
  /// In en_GB, this message translates to:
  /// **'Tokelau'**
  String get country_TK;

  /// Name of Tonga
  ///
  /// In en_GB, this message translates to:
  /// **'Tonga'**
  String get country_TO;

  /// Name of Trinidad and Tobago
  ///
  /// In en_GB, this message translates to:
  /// **'Trinidad and Tobago'**
  String get country_TT;

  /// Name of Tunisia
  ///
  /// In en_GB, this message translates to:
  /// **'Tunisia'**
  String get country_TN;

  /// Name of Türkiye
  ///
  /// In en_GB, this message translates to:
  /// **'Türkiye'**
  String get country_TR;

  /// Name of Turkmenistan
  ///
  /// In en_GB, this message translates to:
  /// **'Turkmenistan'**
  String get country_TM;

  /// Name of Turks and Caicos Islands
  ///
  /// In en_GB, this message translates to:
  /// **'Turks and Caicos Islands'**
  String get country_TC;

  /// Name of Tuvalu
  ///
  /// In en_GB, this message translates to:
  /// **'Tuvalu'**
  String get country_TV;

  /// Name of Uganda
  ///
  /// In en_GB, this message translates to:
  /// **'Uganda'**
  String get country_UG;

  /// Name of Ukraine
  ///
  /// In en_GB, this message translates to:
  /// **'Ukraine'**
  String get country_UA;

  /// Name of United Arab Emirates
  ///
  /// In en_GB, this message translates to:
  /// **'United Arab Emirates'**
  String get country_AE;

  /// Name of United Kingdom
  ///
  /// In en_GB, this message translates to:
  /// **'United Kingdom'**
  String get country_GB;

  /// Name of United States
  ///
  /// In en_GB, this message translates to:
  /// **'United States'**
  String get country_US;

  /// Name of US Minor Outlying Islands
  ///
  /// In en_GB, this message translates to:
  /// **'US Minor Outlying Islands'**
  String get country_UM;

  /// Name of Uruguay
  ///
  /// In en_GB, this message translates to:
  /// **'Uruguay'**
  String get country_UY;

  /// Name of Uzbekistan
  ///
  /// In en_GB, this message translates to:
  /// **'Uzbekistan'**
  String get country_UZ;

  /// Name of Vanuatu
  ///
  /// In en_GB, this message translates to:
  /// **'Vanuatu'**
  String get country_VU;

  /// Name of Venezuela (Bolivarian Republic of)
  ///
  /// In en_GB, this message translates to:
  /// **'Venezuela (Bolivarian Republic of)'**
  String get country_VE;

  /// Name of Viet Nam
  ///
  /// In en_GB, this message translates to:
  /// **'Viet Nam'**
  String get country_VN;

  /// Name of Virgin Islands (British)
  ///
  /// In en_GB, this message translates to:
  /// **'Virgin Islands (British)'**
  String get country_VG;

  /// Name of Virgin Islands (U.S.)
  ///
  /// In en_GB, this message translates to:
  /// **'Virgin Islands (U.S.)'**
  String get country_VI;

  /// Name of Wallis and Futuna
  ///
  /// In en_GB, this message translates to:
  /// **'Wallis and Futuna'**
  String get country_WF;

  /// Name of Western Sahara
  ///
  /// In en_GB, this message translates to:
  /// **'Western Sahara'**
  String get country_EH;

  /// Name of Yemen
  ///
  /// In en_GB, this message translates to:
  /// **'Yemen'**
  String get country_YE;

  /// Name of Zambia
  ///
  /// In en_GB, this message translates to:
  /// **'Zambia'**
  String get country_ZM;

  /// Name of Zimbabwe
  ///
  /// In en_GB, this message translates to:
  /// **'Zimbabwe'**
  String get country_ZW;
}

class _CountryLocalizationsDelegate extends LocalizationsDelegate<CountryLocalizations> {
  const _CountryLocalizationsDelegate();

  @override
  Future<CountryLocalizations> load(Locale locale) {
    return SynchronousFuture<CountryLocalizations>(lookupCountryLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'bg',
    'bn',
    'ca',
    'cs',
    'cy',
    'da',
    'de',
    'el',
    'en',
    'es',
    'fa',
    'fi',
    'fr',
    'he',
    'hi',
    'hr',
    'hu',
    'id',
    'it',
    'ja',
    'ko',
    'ms',
    'nb',
    'nl',
    'pl',
    'pt',
    'ro',
    'ru',
    'sk',
    'sr',
    'sv',
    'ta',
    'th',
    'tr',
    'uk',
    'ur',
    'vi',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_CountryLocalizationsDelegate old) => false;
}

CountryLocalizations lookupCountryLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'en':
      {
        switch (locale.countryCode) {
          case 'GB':
            return CountryLocalizationsEnGb();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return CountryLocalizationsAr();
    case 'bg':
      return CountryLocalizationsBg();
    case 'bn':
      return CountryLocalizationsBn();
    case 'ca':
      return CountryLocalizationsCa();
    case 'cs':
      return CountryLocalizationsCs();
    case 'cy':
      return CountryLocalizationsCy();
    case 'da':
      return CountryLocalizationsDa();
    case 'de':
      return CountryLocalizationsDe();
    case 'el':
      return CountryLocalizationsEl();
    case 'en':
      return CountryLocalizationsEn();
    case 'es':
      return CountryLocalizationsEs();
    case 'fa':
      return CountryLocalizationsFa();
    case 'fi':
      return CountryLocalizationsFi();
    case 'fr':
      return CountryLocalizationsFr();
    case 'he':
      return CountryLocalizationsHe();
    case 'hi':
      return CountryLocalizationsHi();
    case 'hr':
      return CountryLocalizationsHr();
    case 'hu':
      return CountryLocalizationsHu();
    case 'id':
      return CountryLocalizationsId();
    case 'it':
      return CountryLocalizationsIt();
    case 'ja':
      return CountryLocalizationsJa();
    case 'ko':
      return CountryLocalizationsKo();
    case 'ms':
      return CountryLocalizationsMs();
    case 'nb':
      return CountryLocalizationsNb();
    case 'nl':
      return CountryLocalizationsNl();
    case 'pl':
      return CountryLocalizationsPl();
    case 'pt':
      return CountryLocalizationsPt();
    case 'ro':
      return CountryLocalizationsRo();
    case 'ru':
      return CountryLocalizationsRu();
    case 'sk':
      return CountryLocalizationsSk();
    case 'sr':
      return CountryLocalizationsSr();
    case 'sv':
      return CountryLocalizationsSv();
    case 'ta':
      return CountryLocalizationsTa();
    case 'th':
      return CountryLocalizationsTh();
    case 'tr':
      return CountryLocalizationsTr();
    case 'uk':
      return CountryLocalizationsUk();
    case 'ur':
      return CountryLocalizationsUr();
    case 'vi':
      return CountryLocalizationsVi();
    case 'zh':
      return CountryLocalizationsZh();
  }

  throw FlutterError(
    'CountryLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
