import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invoicing/components/custom_drawer.dart';
import 'package:invoicing/utils/constant.dart';
import 'package:invoicing/utils/generic_functions.dart';

class Help extends StatefulWidget {
  static String id = "help";
  @override
  _HelpState createState() => _HelpState();
}

class _HelpState extends State<Help> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        iconTheme: IconThemeData(color: kORANGE_COLOR),
        title: Text(
          "Help",
          style: TextStyle(color: kORANGE_COLOR),
        ),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(kVERTICAL_SPACING),
          child: ListView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(kVERTICAL_SPACING),
                margin: EdgeInsets.symmetric(vertical: kVERTICAL_SPACING),
                color: kORANGE_COLOR,
                child: Text(
                  "Let us know if we can help ...",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: kVERTICAL_SPACING),
                child: Text(
                  "Call or Email Us",
                  style: TextStyle(
                      color: kORANGE_COLOR,
                      fontSize: 20,
                      fontWeight: FontWeight.normal),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: kVERTICAL_SPACING),
                child: Text(
                  HELP_WORKING_HOURS,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.normal),
                ),
              ),
              ListTile(
                onTap: () {
                  launchURL(HELP_PHONE_URL);
                },
                leading: Icon(
                  FontAwesomeIcons.phone,
                  color: kORANGE_COLOR,
                ),
                title: Text(
                  HELP_PHONE,
                  style: TextStyle(
                      color: kORANGE_COLOR,
                      fontSize: 16,
                      fontWeight: FontWeight.normal),
                ),
              ),
              ListTile(
                onTap: () {
                  launchURL(HELP_SALES_EMAL_URL);
                },
                leading: Icon(
                  FontAwesomeIcons.envelope,
                  color: kORANGE_COLOR,
                ),
                title: Text(
                  "For Sales & Custom Requerement",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.normal),
                ),
                subtitle: Text(
                  HELP_SALES_EMAL,
                  style: TextStyle(
                      color: kORANGE_COLOR,
                      fontSize: 16,
                      fontWeight: FontWeight.normal),
                ),
              ),
              ListTile(
                onTap: () {
                  launchURL(HELP_PARNERSHIP_EMAL_URL);
                },
                leading: Icon(
                  FontAwesomeIcons.envelope,
                  color: kORANGE_COLOR,
                ),
                title: Text(
                  "For partnership Enquiries",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.normal),
                ),
                subtitle: Text(
                  HELP_PARNERSHIP_EMAL,
                  style: TextStyle(
                      color: kORANGE_COLOR,
                      fontSize: 16,
                      fontWeight: FontWeight.normal),
                ),
              ),
              ListTile(
                onTap: () {
                  launchURL(HELP_SUPPORT_EMAL_URL);
                },
                leading: Icon(
                  FontAwesomeIcons.envelope,
                  color: kORANGE_COLOR,
                ),
                title: Text(
                  "For Support",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.normal),
                ),
                subtitle: Text(
                  HELP_SUPPORT_EMAL,
                  style: TextStyle(
                      color: kORANGE_COLOR,
                      fontSize: 16,
                      fontWeight: FontWeight.normal),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: kVERTICAL_SPACING),
                child: Text(
                  "Connect with us at",
                  style: TextStyle(
                      color: kORANGE_COLOR,
                      fontSize: 20,
                      fontWeight: FontWeight.normal),
                ),
              ),
              ListTile(
                onTap: () {
                  launchURL(HELP_FACEBOOK);
                },
                leading: Icon(
                  FontAwesomeIcons.facebook,
                  color: kORANGE_COLOR,
                ),
                title: Text(
                  "Facebook",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.normal),
                ),
                subtitle: Text(
                  HELP_FACEBOOK,
                  style: TextStyle(
                      color: kORANGE_COLOR,
                      fontSize: 16,
                      fontWeight: FontWeight.normal),
                ),
              ),
              ListTile(
                onTap: () {
                  launchURL(HELP_TWITTER);
                },
                leading: Icon(
                  FontAwesomeIcons.twitter,
                  color: kORANGE_COLOR,
                ),
                title: Text(
                  "Twitter",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.normal),
                ),
                subtitle: Text(
                  HELP_TWITTER,
                  style: TextStyle(
                      color: kORANGE_COLOR,
                      fontSize: 16,
                      fontWeight: FontWeight.normal),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
