import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:invoicing/modules/Invoice.dart';
import 'package:invoicing/screens/invoice_preview.dart';
import 'package:invoicing/services/custom_firestore.dart';
import 'package:invoicing/utils/app_icons_icons.dart';
import 'package:invoicing/utils/constant.dart';
import 'package:invoicing/screens/invoices.dart';
class InvoiceListContainer extends StatelessWidget {
  final Invoice invoice;

  InvoiceListContainer({
    this.invoice,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
          return InvoicePreview(
            invoice: invoice,
          );
        }));
        Navigator.pushReplacementNamed(context, Invoices.id);
      },
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.5,
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: 'Delete',
            color: Colors.red,
            icon: Icons.delete_forever,
            onTap: () => _deleteInvoice(),
          ),
        ],
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(invoice.clientName, style: kBLACK_18_BOLD),
                        Container(
                          padding: EdgeInsets.all(5),
                          child: Row(
                            children: <Widget>[
                              Icon(AppIcons.i010_invoices),
                              Text(invoice.invoiceNo, style: kBLACK_16),
                            ],
                          ),
                        ),
                        Text(invoice.invoiceDate, style: kBLACK_16),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(invoice.currency, style: kORANGE_16),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(invoice.getGrossTotalAfterTaxs(), style: kBLACK_20_BOLD),
                ],
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteInvoice() {
    CustomFireStore.deleteInvoice(invoice);
  }
}
