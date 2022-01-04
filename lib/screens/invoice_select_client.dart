import 'package:flutter/material.dart';
import 'package:invoicing/components/scafold_items.dart';
import 'package:invoicing/modules/client.dart';
import 'package:invoicing/screens/clients.dart';

import 'add_edit_invoice.dart';

class InvoiceSelectClient extends StatefulWidget {
  static final id = "InvoiceSelectClient";
  @override
  _InvoiceSelectClientState createState() => _InvoiceSelectClientState();
}

class _InvoiceSelectClientState extends State<InvoiceSelectClient> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBarWhite("Create Invoice"),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(top: 20, right: 10, left: 10),
          child: GestureDetector(
            child: ListTile(
              title: Text("Select Client"),
              trailing: Icon(
                Icons.navigate_next,
                color: Colors.green,
              ),
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Clients(
                  onPressed: (Client client) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return AddEditInvoice(
                        client: client,
                      );
                    }));
                  },
                );
              }));
            },
          ),
        ),
      ),
    );
  }
}
