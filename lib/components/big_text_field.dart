import 'package:flutter/material.dart';
import 'package:invoicing/components/scafold_items.dart';
import 'package:invoicing/utils/constant.dart';

class BigTextField extends StatefulWidget {
  final String title;
  final Function onPressed;
  final String text;

  BigTextField({this.title, this.onPressed, this.text});
  @override
  _BigTextFieldState createState() => _BigTextFieldState();
}

class _BigTextFieldState extends State<BigTextField> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.text = widget.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBarWhite(widget.title),
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            TextField(
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5))),
              ),
              maxLines: 10,
            ),
            SizedBox(
              height: 10,
            ),
            RaisedButton(
              color: kORANGE_COLOR,
              child: Text(
                "Save",
                style: kWHITE_16_BOLD,
              ),
              onPressed: () {
                widget.onPressed(controller.text);
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
