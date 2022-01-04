import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextPicker extends StatefulWidget {
  final List<String> values;
  final String initialValue;
  final String title;
  final String description;

  const TextPicker(
      {Key key,
      @required this.values,
      this.initialValue,
      this.title,
      this.description})
      : super(key: key);

  @override
  _TextPickerState createState() => _TextPickerState();
}

class _TextPickerState extends State<TextPicker> {
  int selectedIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedIndex = widget.values.indexOf(widget.initialValue) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            widget.title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ),
        Text(
          widget.description,
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 5,
        ),
        Divider(
          thickness: 1,
        ),
        Container(
          height: 150.00,
          child: CupertinoPicker(
            scrollController: FixedExtentScrollController(
                initialItem: widget.values.indexOf(widget.initialValue) ?? 0),
            itemExtent: 30.00,
            // Mapping values to widgets
            children: widget.values.map((v) => Text(v)).toList(),
            onSelectedItemChanged: (newIndex) {
              // Changing current index
              selectedIndex = newIndex;
            },
          ),
        ),
        Row(
//          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                        right: BorderSide(width: 1, color: Colors.black),
                        top: BorderSide(width: 1, color: Colors.black))),
                child: CupertinoButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    // Returning selected value
                    Navigator.of(context).pop(null);
                  },
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
//                        right: BorderSide(width: 1, color: Colors.black),
                        top: BorderSide(width: 1, color: Colors.black))),
                child: CupertinoButton(
                  child: Text('Done'),
                  onPressed: () {
                    // Returning selected value
                    Navigator.of(context).pop(widget.values[selectedIndex]);
                  },
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}
