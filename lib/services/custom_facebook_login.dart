import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:invoicing/components/alert_dialog.dart';
import 'package:invoicing/screens/dashboard.dart';
import 'package:invoicing/utils/constant.dart';
import 'package:invoicing/utils/globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

import 'custom_firestore.dart';

class CustomFacebookLogin {
  final bool rememberMe;
  final Function onCall;
  CustomFacebookLogin({this.rememberMe, this.onCall});
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  final databaseReference = Firestore.instance;
  final facebookLogin = FacebookLogin();

  Future<void> signInFacebook(BuildContext context) async {
    final result = await facebookLogin.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;
        final AuthCredential credential = FacebookAuthProvider.getCredential(
            accessToken: result.accessToken.token);
        try {
          final FirebaseUser user =
              (await _auth.signInWithCredential(credential)).user;
          print(
              "Token: ${accessToken.token},User id: ${accessToken.userId},Expires: ${accessToken.expires},Permissions: ${accessToken.permissions},Declined permissions: ${accessToken.declinedPermissions},");
          await _createUserIfNotExist(user);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          if (rememberMe) {
            prefs.setBool("isKeepLoggedIn", true);
          } else {
            prefs.setString("email", "");
          }
          onCall();
          globals.userID = user.uid;
          globals.user = await CustomFireStore.getUserData();
          Navigator.pushReplacementNamed(context, Dashboard.id);
        } catch (e) {
          onCall();
          Alert.showMyDialogOk(
              context: context, title: ERROR_TITLE, description: e.message);
        }
        //keep the status of the user as logged in

        break;
      case FacebookLoginStatus.cancelledByUser:
        onCall();
//        _showCancelledMessage();
        break;
      case FacebookLoginStatus.error:
        onCall();
        Alert.showMyDialogOk(
            context: context,
            title: ERROR_TITLE,
            description: result.errorMessage);
//        _showErrorOnUI(result.errorMessage);
        break;
    }
  }

  _createUserIfNotExist(FirebaseUser user) async {
    QuerySnapshot querySnapshot = await databaseReference
        .collection("users")
        .where('email', isEqualTo: user.email)
        .getDocuments();
    if (querySnapshot.documents.length == 0) {
      await databaseReference
          .collection("users")
          .document(await _auth.currentUser().then((value) => value.uid))
          .setData({
        'first_name': user.displayName,
        'last_name': "",
        'phone_number': user.phoneNumber,
        'email': user.email
      });
    }
  }
}
