import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invoicing/components/alert_dialog.dart';
import 'package:invoicing/components/login_text_field.dart';
import 'package:invoicing/screens/dashboard.dart';
import 'package:invoicing/screens/forget_password.dart';
import 'package:invoicing/screens/register.dart';
import 'package:invoicing/services/custom_facebook_login.dart';
import 'package:invoicing/services/custom_firestore.dart';
import 'package:invoicing/utils/constant.dart';
import 'package:invoicing/utils/globals.dart' as globals;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  static String id = "Login";
  final String email;
  Login({this.email});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  bool _rememberMe = false;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    _emailController.text = widget.email;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
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
            Container(
              padding:
                  EdgeInsets.only(top: 60, bottom: 40, left: 20, right: 20),
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
                    height: 40,
                  ),
                  LoginTextField(
                    controller: _emailController,
                    label: "Email",
                  ),
                  SizedBox(
                    height: kVERTICAL_SPACING,
                  ),
                  LoginTextField(
                    controller: _passwordController,
                    label: "Password",
                    obscureText: true,
                  ),
                  SizedBox(
                    height: kVERTICAL_SPACING,
                  ),
                  Row(
                    children: <Widget>[
                      Checkbox(
                        tristate: false,
                        checkColor: Colors.orange,
                        activeColor: Colors.white,
                        hoverColor: Colors.orange,
                        value: _rememberMe,
                        onChanged: (bool value) {
                          setState(() {
                            _rememberMe = value;
                          });
                        },
                      ),
                      Text(
                        "Remember Me",
                        style: TextStyle(color: Colors.white),
                      ),
                      Expanded(
                        child: SizedBox(),
                      ),
                      FlatButton(
                        onPressed: _forgetPassword,
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: kORANGE_COLOR),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: kVERTICAL_SPACING,
                  ),
                  RaisedButton(
                    onPressed: _signIn,
                    color: kORANGE_COLOR,
                    child: Text(
                      "Sign In",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: kVERTICAL_SPACING,
                  ),
                  signInWithText(),
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
                    height: 2 * kVERTICAL_SPACING,
                  ),
                  Center(
                    child: Text(
                      "Are you a New User?",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Center(
                    child: FlatButton(
                      onPressed: _signUp,
                      child: Text(
                        "Sign up for free",
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: kORANGE_COLOR),
                      ),
                    ),
                  ),
                ],
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

  void _forgetPassword() {
    Navigator.pushNamed(context, ForgetPassword.id);
  }

  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
    });
    _auth
        .signInWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim())
        .then((AuthResult value) async {
      setState(() {
        _isLoading = false;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (_rememberMe) {
        prefs.setBool("isKeepLoggedIn", true);
        prefs.setString("email", _emailController.text.trim());
      } else {
        prefs.setString("email", "");
      }
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

  Future<void> _signInFacebook() async {
    setState(() {
      _isLoading = true;
    });
    CustomFacebookLogin facebookLogin = new CustomFacebookLogin(
        rememberMe: _rememberMe,
        onCall: () {
          setState(() {
            _isLoading = false;
          });
        });
    facebookLogin.signInFacebook(context);
  }

  void _signUp() {
    Navigator.pushNamed(context, Register.id);
  }
}
