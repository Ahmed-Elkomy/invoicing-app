import 'package:flutter/material.dart';
import 'package:invoicing/utils/constant.dart';

class SearchTextField extends StatefulWidget {
  final TextEditingController controller;
  final Function onChanged;
  final String hintText;
  final TextInputType keyboardType;
  final prefixIcon;
  SearchTextField(
      {this.controller,
      this.hintText,
      this.keyboardType,
      this.prefixIcon,
      this.onChanged});
  @override
  _SearchTextFieldState createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.zero),
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.zero),
            borderSide: BorderSide(color: kORANGE_LIGHT_COLOR)),
        hintText: widget.hintText,
        prefixIcon: widget.prefixIcon,
      ),
      keyboardType: widget.keyboardType ?? TextInputType.text,
      textCapitalization: TextCapitalization.none,
      onChanged: widget.onChanged,
    );
  }
}
