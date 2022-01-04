import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invoicing/components/alert_dialog.dart';
import 'package:invoicing/components/login_text_field.dart';
import 'package:invoicing/components/scafold_items.dart';
import 'package:invoicing/services/custom_facebook_login.dart';
import 'package:invoicing/services/custom_firestore.dart';
import 'package:invoicing/utils/constant.dart';
import 'package:invoicing/utils/generic_functions.dart';
import 'package:invoicing/utils/globals.dart' as globals;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dashboard.dart';

class Register extends StatefulWidget {
  static String id = "Register";

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController _firstNameController = new TextEditingController();
  TextEditingController _lastNameController = new TextEditingController();
  TextEditingController _phoneNumberController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _confirmPasswordController =
      new TextEditingController();
  TextEditingController _companyNameController = new TextEditingController();

  TextEditingController _companyAddressController = new TextEditingController();

  bool _isAgree = false;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  final databaseReference = Firestore.instance;
  final facebookLogin = FacebookLogin();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBarGrey("Sign Up"),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage("images/background.png"))),
            ),
            Container(
              color: Color.fromRGBO(0, 0, 0, 0.7),
            ),
            ModalProgressHUD(
              inAsyncCall: _isLoading,
              child: Container(
                padding:
                    EdgeInsets.only(top: 10, bottom: 20, left: 20, right: 20),
                child: ListView(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(top: 60),
                          child: Text(
                            "INVOICERA",
                            style: GoogleFonts.abel(
                              fontWeight: FontWeight.bold,
                              color: kORANGE_COLOR,
                              height: 0.2,
                              fontSize: 80,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 3),
                          child: Text(
                            "INVOICING SIMPLIFIED",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    LoginTextField(
                      controller: _firstNameController,
                      label: "First Name",
                    ),
                    LoginTextField(
                      controller: _lastNameController,
                      label: "Last Name",
                    ),
                    LoginTextField(
                      controller: _phoneNumberController,
                      label: "Phone Number",
                      keyboardType: TextInputType.phone,
                    ),
                    LoginTextField(
                      controller: _emailController,
                      label: "Email",
                      keyboardType: TextInputType.emailAddress,
                    ),
                    LoginTextField(
                      controller: _passwordController,
                      label: "Password",
                      obscureText: true,
                    ),
                    LoginTextField(
                      controller: _confirmPasswordController,
                      label: "Confirm Password",
                      obscureText: true,
                    ),
                    LoginTextField(
                      controller: _companyNameController,
                      label: "Company Name",
                    ),
                    LoginTextField(
                      controller: _companyAddressController,
                      label: "Company Address",
                    ),
                    SizedBox(
                      height: 2 * kVERTICAL_SPACING,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Checkbox(
                          tristate: false,
                          checkColor: Colors.orange,
                          activeColor: Colors.white,
                          hoverColor: Colors.orange,
                          value: _isAgree,
                          onChanged: (bool value) {
                            setState(() {
                              _isAgree = value;
                            });
                          },
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              height: 20,
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    "Yes, I agree to the",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  FlatButton(
                                    onPressed: () {
                                      launchURL("https://flutter.dev");
                                    },
                                    child: Text(
                                      "Terms of service",
                                      style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: kORANGE_COLOR),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 20,
                              child: Row(children: <Widget>[
                                Text(
                                  "and",
                                  style: TextStyle(color: Colors.white),
                                ),
                                FlatButton(
                                  onPressed: () {
                                    launchURL("https://flutter.dev");
                                  },
                                  child: Text(
                                    "Privacy Polices",
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: kORANGE_COLOR),
                                  ),
                                ),
                              ]),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: kVERTICAL_SPACING,
                    ),
                    RaisedButton(
                      onPressed: _signUp,
                      color: kORANGE_COLOR,
                      child: Text("Create AN ACCOUNT",
                          style: TextStyle(color: Colors.white)),
                    ),
                    SizedBox(
                      height: kVERTICAL_SPACING,
                    ),
                    Text(
                      "OR",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      height: 2 * kVERTICAL_SPACING,
                    ),
                    Center(
                        child: InkWell(
                            highlightColor: Colors.transparent,
                            onTap: _signInFacebook,
                            child: SvgPicture.asset(
                              "images/facebook.svg",
                              height: 30,
                            ))),
                    SizedBox(
                      height: kVERTICAL_SPACING,
                    ),
                    Center(
                        child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Already a member?",
                          style: TextStyle(color: Colors.white),
                        ),
                        FlatButton(
                          onPressed: _signIn,
                          child: Text(
                            "Login here",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: kORANGE_COLOR),
                          ),
                        ),
                      ],
                    )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row signInWithText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
            child: Divider(
          color: Colors.white,
//                      height: 10,
          thickness: 1,
          indent: 30,
          endIndent: 10,
        )),
        Text(
          "Or Sign in with",
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
        Expanded(
            child: Divider(
          color: Colors.white,
//                      height: 10,
          thickness: 1,
          indent: 10,
          endIndent: 30,
        )),
      ],
    );
  }

  void _signIn() {
    Navigator.pop(context);
  }

  Future<void> _signInFacebook() async {
    setState(() {
      _isLoading = true;
    });
    CustomFacebookLogin facebookLogin = new CustomFacebookLogin(
        rememberMe: true,
        onCall: () {
          setState(() {
            _isLoading = false;
          });
        });
    facebookLogin.signInFacebook(context);
  }

  Future<void> _signUp() async {
    setState(() {
      _isLoading = true;
    });

    bool isValidated = await _signUpValidation();
    if (isValidated) {
      await _auth
          .createUserWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim())
          .then((AuthResult value) async {
        await _createUser();
        setState(() {
          _isLoading = false;
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool("isKeepLoggedIn", true);
        prefs.setString("email", _emailController.text.trim());
        globals.userID = value.user.uid;
        globals.user = await CustomFireStore.getUserData();
        Navigator.pushReplacementNamed(context, Dashboard.id);
      }, onError: (e) {
        setState(() {
          _isLoading = false;
        });
        Alert.showMyDialogOk(
            context: context, title: ERROR_TITLE, description: e.message);
      });
    }
  }

  Future<bool> _signUpValidation() async {
    String errorMessage = "";
    if (_firstNameController.text == "") {
      errorMessage = kREGISTER_FIRST_NAME_NOT_CORRECT;
    } else if (_lastNameController.text == "") {
      errorMessage = kREGISTER_Last_NAME_NOT_CORRECT;
    } else if (_phoneNumberController.text == "") {
      errorMessage = kREGISTER_PHONE_NOT_CORRECT;
    } else if (_passwordController.text == "") {
      errorMessage = kREGISTER_PASSWORD_NOT_CORRECT;
    } else if (_confirmPasswordController.text != _passwordController.text) {
      errorMessage = kREGISTER_PASSWORD_NOT_MATCH;
    } else if (!_isAgree) {
      errorMessage = kREGISTER_NO_AGREEMENT;
    } else if (_companyNameController.text == "") {
      errorMessage = kREGISTER_COMPANY_NAME_NOT_CORRECT;
    } else if (_companyAddressController.text == "") {
      errorMessage = kREGISTER_COMPANY_ADDRESS_NOT_CORRECT;
    } else {
      return true;
    }
    //in case of error
    setState(() {
      _isLoading = false;
    });
    await Alert.showMyDialogOk(
        context: context, title: ERROR_TITLE, description: errorMessage);
    return false;
  }

  _createUser() async {
    await databaseReference
        .collection("users")
        .document(await _auth.currentUser().then((value) => value.uid))
        .setData({
      'first_name': _firstNameController.text.trim(),
      'last_name': _lastNameController.text.trim(),
      'phone_number': _phoneNumberController.text.trim(),
      'email': _emailController.text.trim(),
      'company_name': _companyNameController.text.trim(),
      'company_address': _companyAddressController.text.trim()
    });
  }
}
