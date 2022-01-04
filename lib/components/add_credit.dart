import 'package:flutter/material.dart';

Future<String> addCreditPopupMenu(BuildContext context) async {
  TextEditingController creditController = TextEditingController();
  String credit = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Add Credit'),
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: creditController,
                keyboardType: TextInputType.number,
              ),
            ),
            Row(
              children: <Widget>[
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context, creditController.text);
                  },
                  child: const Text(
                    'Add Credit',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context, "");
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ],
        );
      });
  print(credit);
  return credit;
}
