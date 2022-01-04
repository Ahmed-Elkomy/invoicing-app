import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invoicing/screens/clients.dart';
import 'package:invoicing/screens/dashboard.dart';
import 'package:invoicing/screens/help.dart';
import 'package:invoicing/screens/invoices.dart';
import 'package:invoicing/screens/items.dart';
import 'package:invoicing/screens/login.dart';
import 'package:invoicing/screens/subscriptions.dart';
import 'package:invoicing/utils/constant.dart';
import 'package:invoicing/utils/globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

class CustomDrawer extends StatelessWidget {
  CustomDrawer();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              color: kORANGE_COLOR,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    globals.user.username,
                    style: GoogleFonts.abel(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  Text(
                    globals.user.companyName,
                    style: GoogleFonts.abel(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text('Dashboard'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, Dashboard.id);
              },
            ),
            ListTile(
              title: Text('Invoices'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, Invoices.id);
              },
            ),
            ListTile(
              title: Text('Clients'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, Clients.id);
              },
            ),
            ListTile(
              title: Text('Items'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, Items.id);
              },
            ),
            ListTile(
              title: Text('Help'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, Help.id);
              },
            ),
            ListTile(
              title: Text('Subscriptions'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, Subscriptions.id);
              },
            ),
            ListTile(
              title: Text('Sign Out'),
              onTap: () async {
                Navigator.pop(context);
                await FirebaseAuth.instance.signOut();
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String email = prefs.getString("email");
                prefs.setBool("isKeepLoggedIn", false);
//              Navigator.pushReplacementNamed(context, Login.id);
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) =>
                            new Login(email: email)));
              },
            ),
          ],
        ),
      ),
    );
  }
}
