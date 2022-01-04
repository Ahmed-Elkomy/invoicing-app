import 'package:flutter/material.dart';
import 'package:invoicing/components/text_picker.dart';
import 'package:invoicing/utils/constant.dart';
import 'package:invoicing/utils/generic_functions.dart';

class CountryWidget extends StatefulWidget {
  final BuildContext context;
  final String country;
  final Function onTap;
  CountryWidget({Key key, this.context, this.country, this.onTap})
      : super(key: key);
  @override
  CountryWidgetState createState() => CountryWidgetState();
}

class CountryWidgetState extends State<CountryWidget> {
  String _country;
  String get country => _country;
  @override
  void initState() {
    super.initState();
    _country = widget.country;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5, bottom: 5, right: 10, left: 10),
      decoration: BoxDecoration(
          border: Border.all(
        color: kITEMS_BORDER_COLOR,
      )),
      child: ListTile(
          title: Text(_country),
          trailing: Icon(Icons.arrow_drop_down_circle),
          leading: Text(
            'Country:        ',
            style: TextStyle(fontSize: 16, color: kITEMS_TEXT_COLOR),
          ),
          onTap: () async {
            FocusScope.of(context).requestFocus(new FocusNode());
            final data = await showModalBottomSheet<String>(
              context: context,
              builder: (context) {
                return TextPicker(
                  values: kCLIENTS_Country,
                  initialValue: _country,
                  title: kCOUNTRY_TEXT_PICKER_TITLE,
                  description: kCOUNTRY_TEXT_PICKER_DESCRIPTION,
                );
              },
            );
            setState(() {
              _country = data ?? _country;
            });
            widget.onTap();
          }),
    );
  }
}
