import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:invoicing/modules/client.dart';
import 'package:invoicing/screens/client_preview.dart';
import 'package:invoicing/services/custom_firestore.dart';

class ClientsListContainer extends StatelessWidget {
  final Client client;
  final Function onPressed;

  ClientsListContainer({this.client, this.onPressed});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed != null
          ? () {
              onPressed(client);
            }
          : () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ClientPreview(
                  client: client,
                );
              }));
            },
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.5,
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: 'Delete',
            color: Colors.red,
            icon: Icons.delete_forever,
            onTap: () => _deleteClient(),
          ),
        ],
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                client.businessName,
                style: TextStyle(fontSize: 18),
              ),
              Text(client.businessEmail),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(3),
                      child: Text(
                        "A/C BAL: ${client.currency} ${_availableBalanceStr()}",
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                      color: _availableBalanceColor(),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                ],
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }

  String _availableBalanceStr() {
    double credit = double.parse(client.credit);
    double outstanding = 0;
    client.invoices.forEach((key, value) {
      outstanding += double.parse(value);
    });
    double avBalance = credit - outstanding;
    return avBalance.toStringAsFixed(2);
  }

  Color _availableBalanceColor() {
    double credit = double.parse(client.credit);
    double outstanding = 0;
    client.invoices.forEach((key, value) {
      outstanding += double.parse(value);
    });
    double availableBalance = credit - outstanding;
    Color color = availableBalance == 0
        ? Color(0xff636e72)
        : availableBalance < 0 ? Color(0xffd63031) : Color(0xff00b894);
    return color;
  }

  void _deleteClient() {
    CustomFireStore.deleteClient(client);
  }
}
