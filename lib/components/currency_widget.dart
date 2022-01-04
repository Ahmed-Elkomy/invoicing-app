import 'package:flutter/material.dart';
import 'package:invoicing/components/text_picker.dart';
import 'package:invoicing/utils/constant.dart';
import 'package:invoicing/utils/generic_functions.dart';

class CurrencyWidget extends StatefulWidget {
  final BuildContext context;
  final String currency;
  final Function onTap;
  CurrencyWidget({Key key, this.context, this.currency, this.onTap})
      : super(key: key);
  @override
  CurrencyWidgetState createState() => CurrencyWidgetState();
}

class CurrencyWidgetState extends State<CurrencyWidget> {
  String _currency;
  String get currency => _currency;
  @override
  void initState() {
    super.initState();
    _currency = widget.currency;
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
          title: Text(_currency),
          trailing: Icon(Icons.arrow_drop_down_circle),
          leading: Text(
            'Currency:        ',
            style: TextStyle(fontSize: 16, color: kITEMS_TEXT_COLOR),
          ),
          onTap: () async {
            FocusScope.of(context).requestFocus(new FocusNode());
            final data = await showModalBottomSheet<String>(
              context: context,
              builder: (context) {
                return TextPicker(
                  values: kITEMS_CURRENCY,
                  initialValue: _currency,
                  title: kCURRENCY_TEXT_PICKER_TITLE,
                  description: kCURRENCY_TEXT_PICKER_DESCRIPTION,
                );
              },
            );
            setState(() {
              _currency = data ?? _currency;
            });
            widget.onTap();
          }),
    );
  }
}
