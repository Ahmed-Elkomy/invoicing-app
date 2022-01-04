import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'constant.dart';

void launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

String getLocalCurrency(BuildContext context) {
  Locale locale = Localizations.localeOf(context);
  var format = NumberFormat.simpleCurrency(locale: locale.toString());
  return format.currencyName ?? "";
}

String getLocalCountry(BuildContext context) {
  Locale locale = Localizations.localeOf(context);
  var countryName =
      kCLIENT_ISO_CODE_MAPPING_TO_Country_NAME[locale.countryCode];
  return countryName;
}
