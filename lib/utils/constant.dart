import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

DateFormat invoiceDateFormatter = DateFormat('dd-MM-yyyy');

const double kVERTICAL_SPACING = 10;
const Color kORANGE_COLOR = Color(0xfffc6200);
const Color kORANGE_LIGHT_COLOR = Color(0xffffbd69); //items unit
const Color kGREY_COLOR = Color(0xfff3f3f8);
const Color kGREY_DARK_COLOR = Color(0xffcccaca);
const Color kGREEN_COLOR = Color(0xff4CD864);

////////////////HELP//////////////////////////////
const String HELP_WORKING_HOURS = "Mon-Fri (6:00 am - 12:00 midnight IST)";
const String HELP_PHONE = "+91-9350204839";
const String HELP_PHONE_URL = "tel:+91-9350204839";
const String HELP_SALES_EMAL = "sales@invoicera2.com";
const String HELP_SALES_EMAL_URL =
    "mailto:sales@invoicera2.com?subject=Invoice&body=Hello";
const String HELP_PARNERSHIP_EMAL = "partnership@invoicera2.com";
const String HELP_PARNERSHIP_EMAL_URL =
    "mailto:partnership@invoicera2.com?subject=Invoice&body=Hello";
const String HELP_SUPPORT_EMAL = "support@invoicera2.com";
const String HELP_SUPPORT_EMAL_URL =
    "mailto:support@invoicera2.com?subject=Invoice&body=Hello";
const String HELP_FACEBOOK = "http://www.facebook.com/invoicera";
const String HELP_TWITTER = "http://www.twitter.com/invoicera";

///////////////Subscription///////////////////////////
const String Free_ID = "Free";
const String P1_Name = "Pro";
const String P1_ID = "invoiceme.pro";
const String P1_PRICE_UNITES = "USD ";
const String P1_PRICE_VALUE = "14.99";
const String P1_PRICE_RECURRENCE = "/Month";
const String P1_UPGRADE = "Upgrade";
const String P1_Activated = "Activated";
const int P1_ACTIVE_CLIENTS_NUMBER = 100;
const String P1_ACTIVE_CLIENTS = "100-active clients";
const String P1_STAFF = "1-staff members(s)";
const String P1_API = "API access";

const String P2_Name = "Infinite";
const String P2_ID = "invoice.infinite";
const String P2_PRICE_UNITES = "USD";
const String P2_PRICE_VALUE = "144.99";
const String P2_PRICE_RECURRENCE = "/Month";
const String P2_UPGRADE = "Upgrade";
const String P2_Activated = "Activated";
const int P2_ACTIVE_CLIENTS_NUMBER = 100000000;
const String P2_ACTIVE_CLIENTS = "Unlimited-active clients";
const String P2_STAFF = "Unlimited-staff members(s)";
const String P2_API = "API access";

const String P3_Name = "Business";
const String P3_ID = "invoiceme.business";
const String P3_PRICE_UNITES = "USD";
const String P3_PRICE_VALUE = "28.99";
const String P3_PRICE_RECURRENCE = "/Month";
const String P3_UPGRADE = "Upgrade";
const String P3_Activated = "Activated";
const int P3_ACTIVE_CLIENTS_NUMBER = 1000;
const String P3_ACTIVE_CLIENTS = "1000-active clients";
const String P3_STAFF = "10-staff members(s)";
const String P3_API = "API access";

/////////////////////Notifications/////////////////////
const String ERROR_TITLE = "Error";
const String kREGISTER_NO_AGREEMENT =
    "Please agree first to the terms and condition";

const String kREGISTER_FIRST_NAME_NOT_CORRECT =
    "Please enter a valid name in the first name field";
const String kREGISTER_Last_NAME_NOT_CORRECT =
    "Please enter a valid name in the last name field";
const String kREGISTER_PASSWORD_NOT_CORRECT =
    "Please enter a valid password not less than 6 digits";
const String kREGISTER_PASSWORD_NOT_MATCH = "Password are not matched";
const String kREGISTER_PHONE_NOT_CORRECT = "Please enter a valid phone number";

const String kFORGETPASSWORDSUCCESSFUL = "Password reset email send to _email";

const String kCLIENT_NUMBER_MAX_REACHED =
    "Please upgrade your subscription, as you already reached to the max number of clients";
const String kREGISTER_COMPANY_NAME_NOT_CORRECT =
    "Please enter a valid company name";
const String kREGISTER_COMPANY_ADDRESS_NOT_CORRECT =
    "Please enter a valid company address";
///////////////////Dashboard////////////////////////////
const String kDASHBOARD_WELCOME = "Welcome to Invoicera";
const double kDASHBOARD_WELCOME_SIZE = 25;
const double kDASHBOARD_ITEMS_EXTERNAL_MARGIN = 20;
const double kDASHBOARD_ITEMS_INTERNAL_PADDING = 40;
const double kDASHBOARD_ITEMS_BORDER_WIDTH = 1;
const double kDASHBOARD_ITEMS_ICON_SIZE = 60;
const double kDASHBOARD_ITEMS_FONT_SIZE = 16;
const Color kDASHBOARD_ITEMS_BORDER_COLOR = Color(0xffaaaaaa);

///////////////Items///////////////////////////////////
const String kCURRENCY_TEXT_PICKER_TITLE = "Currency";
const String kCURRENCY_TEXT_PICKER_DESCRIPTION =
    "Please choose a row and press 'Done' or 'Cancel'";

const String kSERVICE_UNIT_TEXT_PICKER_TITLE = "Unit";
const String kSERVICE_UNIT_TEXT_PICKER_DESCRIPTION =
    "Please choose a row and press 'Done' or 'Cancel'";
const Color kITEMS_BORDER_COLOR = Color(0xff9b9b9b);
const Color kITEMS_TEXT_COLOR = Color(0xff555555);
const List<String> kITEMS_SERVICE_UNIT = [
  'Minutes',
  'Hour',
  'Day',
  'Month',
  'Year',
  'Basic'
];

const List<String> kITEMS_CURRENCY = [
  'AED',
  'AFN',
  'ALL',
  'AMD',
  'ANG',
  'AOA',
  'ARS',
  'AUD',
  'AWG',
  'AZN',
  'BAM',
  'BBD',
  'BDT',
  'BGN',
  'BHD',
  'BIF',
  'BMD',
  'BND',
  'BOB',
  'BOV',
  'BRL',
  'BSD',
  'BTN',
  'BWP',
  'BYN',
  'BZD',
  'CAD',
  'CDF',
  'CHE',
  'CHF',
  'CHW',
  'CLF',
  'CLP',
  'CNY',
  'COP',
  'COU',
  'CRC',
  'CUC',
  'CUP',
  'CVE',
  'CZK',
  'DJF',
  'DKK',
  'DOP',
  'DZD',
  'EGP',
  'ERN',
  'ETB',
  'EUR',
  'FJD',
  'FKP',
  'GBP',
  'GEL',
  'GHS',
  'GIP',
  'GMD',
  'GNF',
  'GTQ',
  'GYD',
  'HKD',
  'HNL',
  'HRK',
  'HTG',
  'HUF',
  'IDR',
  'ILS',
  'INR',
  'IQD',
  'IRR',
  'ISK',
  'JMD',
  'JOD',
  'JPY',
  'KES',
  'KGS',
  'KHR',
  'KMF',
  'KPW',
  'KRW',
  'KWD',
  'KYD',
  'KZT',
  'LAK',
  'LBP',
  'LKR',
  'LRD',
  'LSL',
  'LYD',
  'MAD',
  'MDL',
  'MGA',
  'MKD',
  'MMK',
  'MNT',
  'MOP',
  'MRU',
  'MUR',
  'MVR',
  'MWK',
  'MXN',
  'MXV',
  'MYR',
  'MZN',
  'NAD',
  'NGN',
  'NIO',
  'NOK',
  'NPR',
  'NZD',
  'OMR',
  'PAB',
  'PEN',
  'PGK',
  'PHP',
  'PKR',
  'PLN',
  'PYG',
  'QAR',
  'RON',
  'RSD',
  'RUB',
  'RWF',
  'SAR',
  'SBD',
  'SCR',
  'SDG',
  'SEK',
  'SGD',
  'SHP',
  'SLL',
  'SOS',
  'SRD',
  'SSP',
  'STN',
  'SVC',
  'SYP',
  'SZL',
  'THB',
  'TJS',
  'TMT',
  'TND',
  'TOP',
  'TRY',
  'TTD',
  'TWD',
  'TZS',
  'UAH',
  'UGX',
  'USD',
  'USN',
  'UYI',
  'UYU',
  'UZS',
  'VEF',
  'VND',
  'VUV',
  'WST',
  'XAF',
  'XCD',
  'XDR',
  'XOF',
  'XPF',
  'XSU',
  'XUA',
  'YER',
  'ZAR',
  'ZMW',
  'ZWL'
];

const String kCOUNTRY_TEXT_PICKER_TITLE = "Country";
const String kCOUNTRY_TEXT_PICKER_DESCRIPTION =
    "Please choose a row and press 'Done' or 'Cancel'";

const Map<String, String> kCLIENT_ISO_CODE_MAPPING_TO_Country_NAME = {
  'AF': 'Afghanistan',
  'AL': 'Albania',
  'DZ': 'Algeria',
  'AS': 'American Samoa',
  'AD': 'Andorra',
  'AO': 'Angola',
  'AI': 'Anguilla',
  'AQ': 'Antarctica',
  'AG': 'Antigua and Barbuda',
  'AR': 'Argentina',
  'AM': 'Armenia',
  'AW': 'Aruba',
  'AU': 'Australia',
  'AT': 'Austria',
  'AZ': 'Azerbaijan',
  'BS': 'Bahamas',
  'BH': 'Bahrain',
  'BD': 'Bangladesh',
  'BB': 'Barbados',
  'BY': 'Belarus',
  'BE': 'Belgium',
  'BZ': 'Belize',
  'BJ': 'Benin',
  'BM': 'Bermuda',
  'BT': 'Bhutan',
  'BO': 'Bolivia',
  'BA': 'Bosnia and Herzegovina',
  'BW': 'Botswana',
  'BR': 'Brazil',
  'IO': 'British Indian Ocean Territory',
  'VG': 'British Virgin Islands',
  'BN': 'Brunei',
  'BG': 'Bulgaria',
  'BF': 'Burkina Faso',
  'BI': 'Burundi',
  'KH': 'Cambodia',
  'CM': 'Cameroon',
  'CA': 'Canada',
  'CV': 'Cape Verde',
  'KY': 'Cayman Islands',
  'CF': 'Central African Republic',
  'TD': 'Chad',
  'CL': 'Chile',
  'CN': 'China',
  'CX': 'Christmas Island',
  'CC': 'Cocos Islands',
  'CO': 'Colombia',
  'KM': 'Comoros',
  'CK': 'Cook Islands',
  'CR': 'Costa Rica',
  'HR': 'Croatia',
  'CU': 'Cuba',
  'CW': 'Curacao',
  'CY': 'Cyprus',
  'CZ': 'Czech Republic',
  'CD': 'Democratic Republic of the Congo',
  'DK': 'Denmark',
  'DJ': 'Djibouti',
  'DM': 'Dominica',
  'DO': 'Dominican Republic',
  'TL': 'East Timor',
  'EC': 'Ecuador',
  'EG': 'Egypt',
  'SV': 'El Salvador',
  'GQ': 'Equatorial Guinea',
  'ER': 'Eritrea',
  'EE': 'Estonia',
  'ET': 'Ethiopia',
  'FK': 'Falkland Islands',
  'FO': 'Faroe Islands',
  'FJ': 'Fiji',
  'FI': 'Finland',
  'FR': 'France',
  'PF': 'French Polynesia',
  'GA': 'Gabon',
  'GM': 'Gambia',
  'GE': 'Georgia',
  'DE': 'Germany',
  'GH': 'Ghana',
  'GI': 'Gibraltar',
  'GR': 'Greece',
  'GL': 'Greenland',
  'GD': 'Grenada',
  'GU': 'Guam',
  'GT': 'Guatemala',
  'GG': 'Guernsey',
  'GN': 'Guinea',
  'GW': 'Guinea-Bissau',
  'GY': 'Guyana',
  'HT': 'Haiti',
  'HN': 'Honduras',
  'HK': 'Hong Kong',
  'HU': 'Hungary',
  'IS': 'Iceland',
  'IN': 'India',
  'ID': 'Indonesia',
  'IR': 'Iran',
  'IQ': 'Iraq',
  'IE': 'Ireland',
  'IM': 'Isle of Man',
  'IL': 'Israel',
  'IT': 'Italy',
  'CI': 'Ivory Coast',
  'JM': 'Jamaica',
  'JP': 'Japan',
  'JE': 'Jersey',
  'JO': 'Jordan',
  'KZ': 'Kazakhstan',
  'KE': 'Kenya',
  'KI': 'Kiribati',
  'XK': 'Kosovo',
  'KW': 'Kuwait',
  'KG': 'Kyrgyzstan',
  'LA': 'Laos',
  'LV': 'Latvia',
  'LB': 'Lebanon',
  'LS': 'Lesotho',
  'LR': 'Liberia',
  'LY': 'Libya',
  'LI': 'Liechtenstein',
  'LT': 'Lithuania',
  'LU': 'Luxembourg',
  'MO': 'Macau',
  'MK': 'Macedonia',
  'MG': 'Madagascar',
  'MW': 'Malawi',
  'MY': 'Malaysia',
  'MV': 'Maldives',
  'ML': 'Mali',
  'MT': 'Malta',
  'MH': 'Marshall Islands',
  'MR': 'Mauritania',
  'MU': 'Mauritius',
  'YT': 'Mayotte',
  'MX': 'Mexico',
  'FM': 'Micronesia',
  'MD': 'Moldova',
  'MC': 'Monaco',
  'MN': 'Mongolia',
  'ME': 'Montenegro',
  'MS': 'Montserrat',
  'MA': 'Morocco',
  'MZ': 'Mozambique',
  'MM': 'Myanmar',
  'NA': 'Namibia',
  'NR': 'Nauru',
  'NP': 'Nepal',
  'NL': 'Netherlands',
  'AN': 'Netherlands Antilles',
  'NC': 'New Caledonia',
  'NZ': 'New Zealand',
  'NI': 'Nicaragua',
  'NE': 'Niger',
  'NG': 'Nigeria',
  'NU': 'Niue',
  'KP': 'North Korea',
  'MP': 'Northern Mariana Islands',
  'NO': 'Norway',
  'OM': 'Oman',
  'PK': 'Pakistan',
  'PW': 'Palau',
  'PS': 'Palestine',
  'PA': 'Panama',
  'PG': 'Papua New Guinea',
  'PY': 'Paraguay',
  'PE': 'Peru',
  'PH': 'Philippines',
  'PN': 'Pitcairn',
  'PL': 'Poland',
  'PT': 'Portugal',
  'PR': 'Puerto Rico',
  'QA': 'Qatar',
  'CG': 'Republic of the Congo',
  'RE': 'Reunion',
  'RO': 'Romania',
  'RU': 'Russia',
  'RW': 'Rwanda',
  'BL': 'Saint Barthelemy',
  'SH': 'Saint Helena',
  'KN': 'Saint Kitts and Nevis',
  'LC': 'Saint Lucia',
  'MF': 'Saint Martin',
  'PM': 'Saint Pierre and Miquelon',
  'VC': 'Saint Vincent and the Grenadines',
  'WS': 'Samoa',
  'SM': 'San Marino',
  'ST': 'Sao Tome and Principe',
  'SA': 'Saudi Arabia',
  'SN': 'Senegal',
  'RS': 'Serbia',
  'SC': 'Seychelles',
  'SL': 'Sierra Leone',
  'SG': 'Singapore',
  'SX': 'Sint Maarten',
  'SK': 'Slovakia',
  'SI': 'Slovenia',
  'SB': 'Solomon Islands',
  'SO': 'Somalia',
  'ZA': 'South Africa',
  'KR': 'South Korea',
  'SS': 'South Sudan',
  'ES': 'Spain',
  'LK': 'Sri Lanka',
  'SD': 'Sudan',
  'SR': 'Suriname',
  'SJ': 'Svalbard and Jan Mayen',
  'SZ': 'Swaziland',
  'SE': 'Sweden',
  'CH': 'Switzerland',
  'SY': 'Syria',
  'TW': 'Taiwan',
  'TJ': 'Tajikistan',
  'TZ': 'Tanzania',
  'TH': 'Thailand',
  'TG': 'Togo',
  'TK': 'Tokelau',
  'TO': 'Tonga',
  'TT': 'Trinidad and Tobago',
  'TN': 'Tunisia',
  'TR': 'Turkey',
  'TM': 'Turkmenistan',
  'TC': 'Turks and Caicos Islands',
  'TV': 'Tuvalu',
  'VI': 'U.S. Virgin Islands',
  'UG': 'Uganda',
  'UA': 'Ukraine',
  'AE': 'United Arab Emirates',
  'GB': 'United Kingdom',
  'US': 'United States',
  'UY': 'Uruguay',
  'UZ': 'Uzbekistan',
  'VU': 'Vanuatu',
  'VA': 'Vatican',
  'VE': 'Venezuela',
  'VN': 'Vietnam',
  'WF': 'Wallis and Futuna',
  'EH': 'Western Sahara',
  'YE': 'Yemen',
  'ZM': 'Zambia',
  'ZW': 'Zimbabwe'
};
const List<String> kCLIENTS_Country = [
  'Afghanistan',
  'Albania',
  'Algeria',
  'American Samoa',
  'Andorra',
  'Angola',
  'Anguilla',
  'Antarctica',
  'Antigua and Barbuda',
  'Argentina',
  'Armenia',
  'Aruba',
  'Australia',
  'Austria',
  'Azerbaijan',
  'Bahamas',
  'Bahrain',
  'Bangladesh',
  'Barbados',
  'Belarus',
  'Belgium',
  'Belize',
  'Benin',
  'Bermuda',
  'Bhutan',
  'Bolivia',
  'Bosnia and Herzegovina',
  'Botswana',
  'Brazil',
  'British Indian Ocean Territory',
  'British Virgin Islands',
  'Brunei',
  'Bulgaria',
  'Burkina Faso',
  'Burundi',
  'Cambodia',
  'Cameroon',
  'Canada',
  'Cape Verde',
  'Cayman Islands',
  'Central African Republic',
  'Chad',
  'Chile',
  'China',
  'Christmas Island',
  'Cocos Islands',
  'Colombia',
  'Comoros',
  'Cook Islands',
  'Costa Rica',
  'Croatia',
  'Cuba',
  'Curacao',
  'Cyprus',
  'Czech Republic',
  'Democratic Republic of the Congo',
  'Denmark',
  'Djibouti',
  'Dominica',
  'Dominican Republic',
  'East Timor',
  'Ecuador',
  'Egypt',
  'El Salvador',
  'Equatorial Guinea',
  'Eritrea',
  'Estonia',
  'Ethiopia',
  'Falkland Islands',
  'Faroe Islands',
  'Fiji',
  'Finland',
  'France',
  'French Polynesia',
  'Gabon',
  'Gambia',
  'Georgia',
  'Germany',
  'Ghana',
  'Gibraltar',
  'Greece',
  'Greenland',
  'Grenada',
  'Guam',
  'Guatemala',
  'Guernsey',
  'Guinea',
  'Guinea-Bissau',
  'Guyana',
  'Haiti',
  'Honduras',
  'Hong Kong',
  'Hungary',
  'Iceland',
  'India',
  'Indonesia',
  'Iran',
  'Iraq',
  'Ireland',
  'Isle of Man',
  'Israel',
  'Italy',
  'Ivory Coast',
  'Jamaica',
  'Japan',
  'Jersey',
  'Jordan',
  'Kazakhstan',
  'Kenya',
  'Kiribati',
  'Kosovo',
  'Kuwait',
  'Kyrgyzstan',
  'Laos',
  'Latvia',
  'Lebanon',
  'Lesotho',
  'Liberia',
  'Libya',
  'Liechtenstein',
  'Lithuania',
  'Luxembourg',
  'Macau',
  'Macedonia',
  'Madagascar',
  'Malawi',
  'Malaysia',
  'Maldives',
  'Mali',
  'Malta',
  'Marshall Islands',
  'Mauritania',
  'Mauritius',
  'Mayotte',
  'Mexico',
  'Micronesia',
  'Moldova',
  'Monaco',
  'Mongolia',
  'Montenegro',
  'Montserrat',
  'Morocco',
  'Mozambique',
  'Myanmar',
  'Namibia',
  'Nauru',
  'Nepal',
  'Netherlands',
  'Netherlands Antilles',
  'New Caledonia',
  'New Zealand',
  'Nicaragua',
  'Niger',
  'Nigeria',
  'Niue',
  'North Korea',
  'Northern Mariana Islands',
  'Norway',
  'Oman',
  'Pakistan',
  'Palau',
  'Palestine',
  'Panama',
  'Papua New Guinea',
  'Paraguay',
  'Peru',
  'Philippines',
  'Pitcairn',
  'Poland',
  'Portugal',
  'Puerto Rico',
  'Qatar',
  'Republic of the Congo',
  'Reunion',
  'Romania',
  'Russia',
  'Rwanda',
  'Saint Barthelemy',
  'Saint Helena',
  'Saint Kitts and Nevis',
  'Saint Lucia',
  'Saint Martin',
  'Saint Pierre and Miquelon',
  'Saint Vincent and the Grenadines',
  'Samoa',
  'San Marino',
  'Sao Tome and Principe',
  'Saudi Arabia',
  'Senegal',
  'Serbia',
  'Seychelles',
  'Sierra Leone',
  'Singapore',
  'Sint Maarten',
  'Slovakia',
  'Slovenia',
  'Solomon Islands',
  'Somalia',
  'South Africa',
  'South Korea',
  'South Sudan',
  'Spain',
  'Sri Lanka',
  'Sudan',
  'Suriname',
  'Svalbard and Jan Mayen',
  'Swaziland',
  'Sweden',
  'Switzerland',
  'Syria',
  'Taiwan',
  'Tajikistan',
  'Tanzania',
  'Thailand',
  'Togo',
  'Tokelau',
  'Tonga',
  'Trinidad and Tobago',
  'Tunisia',
  'Turkey',
  'Turkmenistan',
  'Turks and Caicos Islands',
  'Tuvalu',
  'U.S. Virgin Islands',
  'Uganda',
  'Ukraine',
  'United Arab Emirates',
  'United Kingdom',
  'United States',
  'Uruguay',
  'Uzbekistan',
  'Vanuatu',
  'Vatican',
  'Venezuela',
  'Vietnam',
  'Wallis and Futuna',
  'Western Sahara',
  'Yemen',
  'Zambia',
  'Zimbabwe'
];

/////////////////////////fontStyle////////

const TextStyle kWHITE_16 = TextStyle(color: Colors.white, fontSize: 16);
const TextStyle kWHITE_16_BOLD =
    TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold);
const TextStyle kWHITE_18 = TextStyle(color: Colors.white, fontSize: 18);
const TextStyle kWHITE_18_BOLD =
    TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold);
const TextStyle kWHITE_20 = TextStyle(
  color: Colors.white,
  fontSize: 20,
);
const TextStyle kWHITE_20_BOLD =
    TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold);

const TextStyle kBLACK_16 = TextStyle(color: Colors.black, fontSize: 16);
const TextStyle kBLACK_16_W500 =
    TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500);
const TextStyle kBLACK_16_BOLD =
    TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold);
const TextStyle kBLACK_18 = TextStyle(color: Colors.black, fontSize: 18);
const TextStyle kBLACK_18_BOLD =
    TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold);
const TextStyle kBLACK_20 = TextStyle(color: Colors.black, fontSize: 20);
const TextStyle kBLACK_20_BOLD =
    TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold);
const TextStyle kORANGE_16 = TextStyle(color: kORANGE_COLOR, fontSize: 16);
const TextStyle kORANGE_16_BOLD =
    TextStyle(color: kORANGE_COLOR, fontSize: 16, fontWeight: FontWeight.bold);
const TextStyle kORANGE_18 = TextStyle(color: kORANGE_COLOR, fontSize: 18);
const TextStyle kORANGE_18_BOLD =
    TextStyle(color: kORANGE_COLOR, fontSize: 18, fontWeight: FontWeight.bold);
const TextStyle kORANGE_20 = TextStyle(color: kORANGE_COLOR, fontSize: 20);
const TextStyle kORANGE_20_BOLD =
    TextStyle(color: kORANGE_COLOR, fontSize: 20, fontWeight: FontWeight.bold);

const TextStyle kORANGE_24_BOLD =
    TextStyle(color: kORANGE_COLOR, fontSize: 24, fontWeight: FontWeight.bold);
