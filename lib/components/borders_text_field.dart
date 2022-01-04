import 'package:flutter/material.dart';
import 'package:invoicing/utils/constant.dart';

class BordersTextField extends StatefulWidget {
  final String label;
  final TextCapitalization textCapitalization;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final Function onChanged;

  const BordersTextField(
      {this.label,
      this.textCapitalization,
      this.keyboardType,
      this.controller,
      this.onChanged});

  @override
  _BordersTextFieldState createState() => _BordersTextFieldState();
}

class _BordersTextFieldState extends State<BordersTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 5, bottom: 5, right: 10, left: 10),
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: ListTile(
                leading: Text(
              widget.label,
              style: TextStyle(fontSize: 16, color: kITEMS_TEXT_COLOR),
            )),
          ),
          TextField(
            onChanged: widget.onChanged,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
            controller: widget.controller,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.zero)),
//              labelText: widget.label,
                prefixText: "                              "),
            keyboardType: widget.keyboardType ?? TextInputType.text,
            textCapitalization:
                widget.textCapitalization ?? TextCapitalization.none,
          ),
        ],
      ),
    );
  }
}
