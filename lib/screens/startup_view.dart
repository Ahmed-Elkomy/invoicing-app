import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:invoicing/screens/dashboard.dart';
import 'package:invoicing/services/custom_firestore.dart';
import 'package:invoicing/utils/globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

class StartupView extends StatefulWidget {
  static String id = "StartupView";

  @override
  _StartupViewState createState() => _StartupViewState();
}

class _StartupViewState extends State<StartupView> {
  Future<bool> futrue;
  String _email = "";
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    futrue = _isUserLoggedIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: futrue,
      builder: (context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data != null) {
            if (snapshot.data) {
              return Dashboard();
            } else {
              print("User is not Logged in");
              return Login(
                email: _email,
              );
            }
          }
        }
        return Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Future<bool> _isUserLoggedIn() async {
    var user = await _auth.currentUser();
    if (user != null) {
      globals.userID = user.uid;
      globals.user = await CustomFireStore.getUserData();
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _email = prefs.getString("email");
    if (prefs.getBool("isKeepLoggedIn") ?? false) {
      return user != null;
    } else {
      print("Don't remember me");
      return false;
    }
  }
}
