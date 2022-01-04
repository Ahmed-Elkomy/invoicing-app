import 'package:flutter/material.dart';
import 'package:invoicing/components/search_text_field.dart';
import 'package:invoicing/utils/constant.dart';

class FilterWidget extends StatefulWidget {
  final TextEditingController controller1;
  final TextEditingController controller2;
  final TextEditingController controller3;
  final Function getFilterResult;
  final Function cancelFilterResult;
  FilterWidget(
      {this.cancelFilterResult,
      this.controller1,
      this.controller2,
      this.controller3,
      this.getFilterResult});

  @override
  _FilterWidgetState createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      color: kGREY_COLOR,
      child: Column(
        children: <Widget>[
          SearchTextField(
            controller: widget.controller1,
            hintText: "Business Name",
          ),
          SizedBox(
            height: kVERTICAL_SPACING,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: SearchTextField(
                  hintText: "Client Name",
                  controller: widget.controller2,
                ),
              ),
              SizedBox(
                width: kVERTICAL_SPACING,
              ),
              Expanded(
                child: SearchTextField(
                  hintText: "Business Email",
                  controller: widget.controller3,
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
            ],
          ),
          SizedBox(
            height: kVERTICAL_SPACING,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: RaisedButton(
                  child: Text("Search"),
                  onPressed: widget.getFilterResult,
                ),
              ),
              SizedBox(
                width: kVERTICAL_SPACING,
              ),
              Expanded(
                child: RaisedButton(
                  child: Text("Cancel"),
                  onPressed: widget.cancelFilterResult,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
