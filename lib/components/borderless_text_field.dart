import 'package:flutter/material.dart';
import 'package:invoicing/utils/constant.dart';

class BorderlessTextField extends StatefulWidget {
  final String label;
  final TextCapitalization textCapitalization;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final IconButton suffixIcon;
  final Function onChanged;

  const BorderlessTextField(
      {this.label,
      this.textCapitalization,
      this.keyboardType,
      this.controller,
      this.suffixIcon,
      this.onChanged});

  @override
  _BorderlessTextFieldState createState() => _BorderlessTextFieldState();
}

class _BorderlessTextFieldState extends State<BorderlessTextField> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerRight,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: ListTile(
              leading: Text(
            widget.label,
            style: TextStyle(fontSize: 16, color: kITEMS_TEXT_COLOR),
          )),
        ),
        Row(
//          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: TextField(
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                controller: widget.controller,
                decoration: InputDecoration(
//                border: OutlineInputBorder(
//                    borderRadius: BorderRadius.all(Radius.zero)),
//            border: OutlineInputBorder(),
                  border: InputBorder.none,
//              labelText: widget.label,
                  prefixText: "                              ",
                ),
                keyboardType: widget.keyboardType ?? TextInputType.text,
                textCapitalization:
                    widget.textCapitalization ?? TextCapitalization.none,
                onChanged: widget.onChanged,
              ),
            ),
            widget.suffixIcon != null ? widget.suffixIcon : Container()
          ],
        ),
      ],
    );
  }
}
