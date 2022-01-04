import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:invoicing/utils/constant.dart';

class SearchDateTextField extends StatefulWidget {
  final TextEditingController controller;
  final Function onChanged;
  final String hintText;
  final TextInputType keyboardType;
  final prefixIcon;
  SearchDateTextField(
      {this.controller,
      this.hintText,
      this.keyboardType,
      this.prefixIcon,
      this.onChanged});
  @override
  _SearchDateTextFieldState createState() => _SearchDateTextFieldState();
}

class _SearchDateTextFieldState extends State<SearchDateTextField> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
        const String MIN_DATETIME = '2000-01-01';
        const String MAX_DATETIME = '2099-01-01';
        DateFormat formatter = DateFormat('yyyy-MM-dd');
        String INIT_DATETIME = formatter.format(DateTime.now());
        String _format = 'dd-MMMM-yyyy';
        DateTimePickerLocale _locale = DateTimePickerLocale.en_us;
        DateTime _dateTime;
        _dateTime = DateTime.parse(INIT_DATETIME);
        DatePicker.showDatePicker(
          context,
//              onMonthChangeStartWithFirstDate: true,
          pickerTheme: DateTimePickerTheme(
            showTitle: true,
            cancel: Text('Cancel',
                style: TextStyle(color: Colors.red, fontSize: 18)),
            confirm: Text('Select',
                style: TextStyle(color: Color(0xff32BBD0), fontSize: 18)),
          ),
          minDateTime: DateTime.parse(MIN_DATETIME),
          maxDateTime: DateTime.parse(MAX_DATETIME),
          initialDateTime: DateTime.now(),
          dateFormat: _format,
          locale: _locale,
//              onClose: () => print("----- onClose -----"),
//              onCancel: () => print('onCancel'),
          onConfirm: (dateTime, List<int> index) {
            print("----- onConfirm -----");
            setState(() {
              widget.controller.text = invoiceDateFormatter.format(dateTime);
            });
          },
        );
//            print("clicked");
      },
      child: AbsorbPointer(
        absorbing: true,
        child: TextField(
          controller: widget.controller,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
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
        ),
      ),
    );
  }
}
