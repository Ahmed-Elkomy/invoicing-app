import 'package:flutter/material.dart';
import 'package:invoicing/components/search_text_field.dart';
import 'package:invoicing/utils/constant.dart';

class SearchWidget extends StatefulWidget {
  final TextEditingController controller;
  final Function onPressed;
  final Function onChanged;
  SearchWidget({this.controller, this.onPressed, this.onChanged});
  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      color: kGREY_COLOR,
//      height: 400,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: SearchTextField(
              controller: widget.controller,
              onChanged: widget.onChanged,
              hintText: "Search",
              prefixIcon: Icon(
                Icons.search,
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          FlatButton(
            color: kGREY_DARK_COLOR,
            onPressed: widget.onPressed,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 13),
              child: Text(
                "Go",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
