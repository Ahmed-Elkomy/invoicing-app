import 'package:flutter/material.dart';
import 'package:invoicing/components/add_credit.dart';
import 'package:invoicing/modules/client.dart';
import 'package:invoicing/services/custom_firestore.dart';
import 'package:invoicing/utils/constant.dart';
import 'package:invoicing/utils/enums.dart';
import 'package:invoicing/utils/generic_functions.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'add_edit_client.dart';
import 'add_edit_invoice.dart';

class ClientPreview extends StatefulWidget {
  final String id = "ClientPreview";
  final Client client;
  ClientPreview({this.client});

  @override
  _ClientPreviewState createState() => _ClientPreviewState();
}

class _ClientPreviewState extends State<ClientPreview> {
  bool _isLoading = false;
  String _credit;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _credit = widget.client.credit;
  }

  @override
  Widget build(BuildContext context) {
    Client client = widget.client;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: kORANGE_COLOR),
        title: Text(
          "Client Preview",
          style: TextStyle(color: kORANGE_COLOR),
        ),
        backgroundColor: Colors.white,
        actions: <Widget>[
          PopupMenuButton<Choice>(
            onSelected: _select,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            itemBuilder: (BuildContext context) {
              return choices.map((Choice choice) {
                return PopupMenuItem<Choice>(
                  value: choice,
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Icon(
                            choice.icon,
                            color: kORANGE_COLOR,
                          ),
                          Text(
                            choice.title,
                            style: TextStyle(color: kORANGE_COLOR),
                          ),
                        ],
                      ),
                      Divider()
                    ],
                  ),
                );
              }).toList();
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: _isLoading,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: kVERTICAL_SPACING),
            child: ListView(
              children: <Widget>[
                Text(
                  client.businessName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.all(10),
                  color: kORANGE_COLOR,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        "Outstanding:",
                        style: kWHITE_16,
                      ),
                      Expanded(child: Container()),
                      Text(
                        client.currency,
                        style: kWHITE_16,
                      ),
                      Text(
                        _outstanding(client),
                        style: kWHITE_20_BOLD,
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  padding: EdgeInsets.all(10),
                  color: kORANGE_COLOR,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        "Credit:",
                        style: kWHITE_16,
                      ),
                      Expanded(child: Container()),
                      Text(
                        client.currency,
                        style: kWHITE_16,
                      ),
                      Text(
                        _credit,
                        style: kWHITE_20_BOLD,
                      )
                    ],
                  ),
                ),
                CustomListTileWithNoTrailing(
                    leading: "Owner:", title: client.clientName),
                CustomListTileWithTrailingIcon(
                    leading: "Phone:",
                    title: client.phoneNumber,
                    iconData: Icons.phone,
                    onPressed: () {
                      launchURL("tel:${client.phoneNumber}");
                    }),
                CustomListTileWithTrailingIcon(
                    leading: "Email:",
                    title: client.businessEmail,
                    iconData: Icons.email,
                    onPressed: () {
                      launchURL(
                          "mailto:${client.businessEmail}?subject=Invoice&body=Dear ${client.clientName},\n\n");
                    }),
                CustomListTileWithNoTrailing(
                    leading: "Address:", title: client.billingAddress),
                Container(
                  padding: EdgeInsets.all(50),
                  child: RaisedButton(
                    onPressed: _addInvoice,
                    color: kORANGE_COLOR,
                    child: Text(
                      "+ Invoice",
                      style: kWHITE_20_BOLD,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _addInvoice() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddEditInvoice(
        client: widget.client,
      );
    }));
  }

  Future<void> _select(Choice choice) async {
    setState(() {
      _isLoading = true;
    });
    if (choice.clientAction == ClientAction.addCredit) {
      await addCredit();
    } else if (choice.clientAction == ClientAction.editClient) {
      editClient();
    } else {
      await deleteClient();
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> editClient() async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddEditClient(
        client: widget.client,
        clientOperation: ClientOperation.editClient,
      );
    }));
    Navigator.pop(context);
  }

  Future<void> deleteClient() async {
    await CustomFireStore.deleteClient(widget.client);
    Navigator.pop(context);
  }

  Future<void> addCredit() async {
    String credit = await addCreditPopupMenu(context);
    if (credit != "") {
      Client client = widget.client;
      double totalCredit = double.parse(_credit) + double.parse(credit);
      client.credit = totalCredit.toStringAsFixed(2);
      await CustomFireStore.editClient(client);
      setState(() {
        _credit = totalCredit.toStringAsFixed(2);
      });
    }
  }

  String _outstanding(Client client) {
    double outstanding = 0;
    client.invoices.forEach((key, value) {
      outstanding += double.parse(value);
    });
    return outstanding.toStringAsFixed(2);
  }
}

class CustomListTileWithTrailingIcon extends StatelessWidget {
  final String leading;
  final String title;
  final Function onPressed;
  final IconData iconData;
  const CustomListTileWithTrailingIcon(
      {this.iconData, this.title, this.leading, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Text(
              leading,
              style: kBLACK_16_BOLD,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              title,
              style: kBLACK_16,
            ),
          ),
          IconButton(
            icon: Icon(
              iconData,
              color: kORANGE_COLOR,
            ),
            onPressed: onPressed,
          )
        ],
      ),
    );
  }
}

class CustomListTileWithNoTrailing extends StatelessWidget {
  final String leading;
  final String title;
  const CustomListTileWithNoTrailing({this.title, this.leading});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Text(
              leading,
              style: kBLACK_16_BOLD,
            ),
          ),
          Expanded(
            flex: 10,
            child: Text(
              title,
              style: kBLACK_16,
            ),
          ),
        ],
      ),
    );
  }
}

class Choice {
  const Choice({this.title, this.icon, this.clientAction});
  final String title;
  final IconData icon;
  final ClientAction clientAction;
//  final Function onPressed;
}

const List<Choice> choices = const <Choice>[
  const Choice(
      title: 'Delete Client',
      icon: Icons.delete_forever,
      clientAction: ClientAction.deleteClient),
  const Choice(
      title: 'Edit Client',
      icon: Icons.mode_edit,
      clientAction: ClientAction.editClient),
  const Choice(
      title: 'Add Credit',
      icon: Icons.add_circle_outline,
      clientAction: ClientAction.addCredit),
];
