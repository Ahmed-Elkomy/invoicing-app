import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginTextField extends StatefulWidget {
  const LoginTextField(
      {this.controller, this.label, this.obscureText, this.keyboardType});

  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final TextInputType keyboardType;

  @override
  _LoginTextFieldState createState() => _LoginTextFieldState();
}

class _LoginTextFieldState extends State<LoginTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: widget.keyboardType ?? TextInputType.text,
      obscureText: widget.obscureText ?? false,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
          labelText: widget.label,
          labelStyle:
              TextStyle(color: Colors.white, decorationColor: Colors.white),
          alignLabelWithHint: false),
      controller: widget.controller,
      onSubmitted: (value) {
      },
    );
  }
}
