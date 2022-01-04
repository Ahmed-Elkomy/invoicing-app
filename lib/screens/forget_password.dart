import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invoicing/components/alert_dialog.dart';
import 'package:invoicing/components/login_text_field.dart';
import 'package:invoicing/screens/register.dart';
import 'package:invoicing/screens/dashboard.dart';
import 'package:invoicing/services/custom_facebook_login.dart';
import 'package:invoicing/utils/constant.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ForgetPassword extends StatefulWidget {
  static String id = "ForgetPAssword";
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  bool _rememberMe = false;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: kORANGE_COLOR),
        title: Text(
          "Forget Password",
          style: TextStyle(color: kORANGE_COLOR),
        ),
        backgroundColor: Colors.white,
      ),
      body: Stack(
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
//                        style: GoogleFonts.oswald(
                          style: GoogleFonts.abel(
//                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: kORANGE_COLOR,
                            height: 0.2,
                            fontSize: 80,
//                  fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 3),
                        child: Text(
                          "INVOICING SIMPLIFIED",
//                      style: GoogleFonts.abel(
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
                    height: 3 * kVERTICAL_SPACING,
                  ),
                  RaisedButton(
                    onPressed: _forgetPassword,
                    color: kORANGE_COLOR,
                    child: Text(
                      "SUBMIT",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _forgetPassword() async {
    setState(() {
      _isLoading = true;
    });
    await _auth.sendPasswordResetEmail(email: _emailController.text).then(
        (value) => Alert.showMyDialogOk(
            context: context,
            title: ERROR_TITLE,
            description: kFORGETPASSWORDSUCCESSFUL.replaceAll(
                "_email", _emailController.text)), onError: (e) {
      setState(() {
        _isLoading = false;
      });
      Alert.showMyDialogOk(
          context: context, title: ERROR_TITLE, description: e.message);
    });
    setState(() {
      _isLoading = false;
    });
  }
}
