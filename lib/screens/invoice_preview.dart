import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:invoicing/modules/Invoice.dart';
import 'package:invoicing/modules/item.dart';
import 'package:invoicing/screens/add_edit_invoice.dart';
import 'package:invoicing/screens/invoice_pdf.dart';
import 'package:invoicing/services/custom_firestore.dart';
import 'package:invoicing/utils/app_icons_icons.dart';
import 'package:invoicing/utils/constant.dart';
import 'package:invoicing/utils/enums.dart';
import 'package:invoicing/utils/globals.dart' as globals;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class InvoicePreview extends StatefulWidget {
  final String id = "InvoicePreview";
  final Invoice invoice;
  InvoicePreview({this.invoice});

  @override
  _InvoicePreviewState createState() => _InvoicePreviewState();
}

class _InvoicePreviewState extends State<InvoicePreview> {
  bool _isLoading = false;
  Invoice invoice;
  List<pw.TableRow> itemsList;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    invoice = widget.invoice;
    _initializeItemList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: kORANGE_COLOR),
        title: Text(
          "Invoice Preview",
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
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                          child: Text(
                        invoice.clientName,
                        style: kBLACK_18_BOLD,
                      )),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                  "ISSUE DATE :",
                                  style: kBLACK_16_BOLD,
                                ),
                                Text(
                                  invoice.invoiceDate,
                                  style: kBLACK_16,
                                )
                              ],
                            ),
                            if (invoice.dueDate!=null)
                            Row(
                              children: <Widget>[
                                Text(
                                  "DUE DATE :",
                                  style: kBLACK_16_BOLD,
                                ),
                                Text(
                                  invoice.dueDate ?? "   xx-xx-xxxx",
                                  style: kBLACK_16,
                                )
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        invoice.currency,
                        style: kORANGE_16_BOLD,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        invoice.getGrossTotalAfterTaxs(),
                        style: kORANGE_24_BOLD,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Divider(
                  thickness: 2,
                ),
                _buildItemsList(),
                CustomListTileWithNoTrailing(
                    leading: "SUB TOTAL", title: invoice.getSubTotal()),
                CustomListTileWithNoTrailing(
                    leading: "Discount", title: invoice.getTotalDiscount()),
                CustomListTileWithNoTrailing(
                    leading: "Additional Charge",
                    title: invoice.getAdditionalCharge()),
                CustomListTileWithNoTrailing(
                    leading: "Net Balance",
                    title: invoice.getNetBalanceAfterAdditionalCharge()),
                CustomListTileWithNoTrailing(
                    leading: "TOTAL Tax",
                    title: (double.parse(invoice.getGrossTotalAfterTaxs()) -
                        double.parse(
                            invoice.getNetBalanceAfterAdditionalCharge()))
                        .toStringAsFixed(2)),
                CustomListTileWithNoTrailing(
                    leading: "Amount Paid", title: "0.00"),
                CustomListTileWithNoTrailing(
                  leading: "BALANCE",
                  title:
                      "${invoice.currency} ${invoice.getGrossTotalAfterTaxs()}",
                  style: kORANGE_18_BOLD,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItemsList() {
    List<Widget> list = List<Widget>();
    for (int i = 0; i < invoice.invoiceItems.length; i++) {
      Item item = invoice.invoiceItems[i];
      list.add(_buildItemWidget(item, i));
    }
    return Column(
      children: list,
    );
  }

  Widget _buildItemWidget(Item item, int index) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        item.name,
                        style: kBLACK_16_W500,
                      ),
                      Text(
                          "${item.unit} @ ${item.cost} = ${(double.parse(item.unit) * double.parse(item.cost)).toStringAsFixed(2)} "),
                    ]),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    "${(double.parse(item.unit) * double.parse(item.cost) - double.parse(item.discount)).toStringAsFixed(2)}",
                    style: kBLACK_16_W500,
                  ),
                  Text(
                      item.discount == "0" ? "" : "Discount: ${item.discount}"),
                ],
              )
            ],
          ),
        ),
        Divider(
          thickness: 2,
        )
      ],
    );
  }

  Future<void> _select(Choice choice) async {
    setState(() {
      _isLoading = true;
    });
    if (choice.invoiceAction == InvoiceAction.createPDF) {
      await createPDF();
    } else if (choice.invoiceAction == InvoiceAction.editInvoice) {
      editInvoice();
    } else {
      await deleteInvoice();
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> editInvoice() async {

    var result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddEditInvoice(
        invoice: invoice,
      );
    }));
    if (result !=null){
      invoice = result;
      _initializeItemList();
      setState(() {});
    }
//    Navigator.pop(context);
  }

  Future<void> deleteInvoice() async {
    await CustomFireStore.deleteInvoice(widget.invoice);
    Navigator.pop(context);
  }

  Future<void> createPDF() async {
    final pw.Document doc = createPDFBody();
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/Invoice ${invoice.invoiceNo}.pdf");
    await file.writeAsBytes(doc.save());
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return InvoicePDF(
        path: file.path,
        invoice: invoice,
        doc: doc,
      );
    }));
  }

  pw.Document createPDFBody() {
    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) => pw.Column(children: <pw.Widget>[
          pw.Center(
              child: pw.Text(invoice.title ?? "",
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
          pw.Divider(thickness: 2, color: PdfColor.fromHex("fc6200")),
          pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Expanded(
                child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                  pw.Text(invoice.username ?? ""),
                  pw.Text(globals.user.companyName ?? ""),
                  pw.Text(globals.user.companyAddress ?? ""),
                  pw.SizedBox(height: 10),
                ])),
//            pw.Expanded(child:pw.Container()),
//            pw.Expanded(
//                child:
                pw.Column(

                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                  pw.Text("Bill To: ${invoice.clientName ?? ""}",
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text(
                    invoice.clientCountrey,
                  ),
                  pdfHeaderWidget("Invoice", invoice.invoiceNo),
                  pdfHeaderWidget("Purchase No.", invoice.pONo),
                  pdfHeaderWidget("Date", invoice.invoiceDate),
                  pdfHeaderWidget("Due Date", invoice.dueDate),
                  pdfHeaderWidget("Amount", invoice.getGrossTotalAfterTaxs()),
                  pw.SizedBox(height: 10),
                ])
//            )
          ]),
          pw.Table(
              border: pw.TableBorder(color: PdfColor.fromHex("cccaca")),
              tableWidth: pw.TableWidth.max,
              children: itemsList),
          pw.SizedBox(height: 10),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Flexible(
                flex: 1,
                  child:
                  pw.Text("Terms: ${invoice.termsAndConditions}",
                      ),
              ),
              pw.Flexible(
                flex: 2,
                child:
                pw.Column(
                    children: [
                      pdfTrailerWidget("Subtotal", invoice.getSubTotal()),
                      invoice.getTotalDiscount() != "0.00"
                          ? pdfTrailerWidget("Discount", invoice.getTotalDiscount())
                          : pw.Container(),
                      invoice.getAdditionalCharge() != "0.00"
                          ? pdfTrailerWidget(
                          "Additional Charge", invoice.getAdditionalCharge())
                          : pw.Container(),
                      pdfTrailerWidget("Net Balance (${invoice.currency})",
                          invoice.getNetBalanceAfterAdditionalCharge()),
                      pdfTrailerWidget("Total Tax", (double.parse(invoice.getGrossTotalAfterTaxs()) -
                          double.parse(
                              invoice.getNetBalanceAfterAdditionalCharge()))
                          .toStringAsFixed(2)),
                      pdfTrailerWidget("Total Paid", "0"),
                      pdfTrailerWidget("Outstanding", invoice.getGrossTotalAfterTaxs()),
                    ]
                ),
              )

             ]
          ),
          pw.Divider(thickness: 2, color: PdfColor.fromHex("fc6200")),
        ]),
      ),
    );
    return doc;
  }

  void _initializeItemList() {
    itemsList = invoice.invoiceItems
        .map((Item item) => pw.TableRow(
                verticalAlignment: pw.TableCellVerticalAlignment.middle,
                children: [
                  pw.Text(item.name ?? "", textAlign: pw.TextAlign.center),
                  pw.Text(item.description ?? ""),
                  pw.Text(item.cost ?? ""),
                  pw.Text(item.unit ?? ""),
                  pw.Text(item.discount ?? ""),
                  pw.Text((double.parse(item.cost) * double.parse(item.unit) -
                          double.parse(item.discount))
                      .toStringAsFixed(2))
                ]))
        .toList();
    itemsList.insert(
      0,
      pw.TableRow(
          verticalAlignment: pw.TableCellVerticalAlignment.middle,
          decoration: pw.BoxDecoration(color: PdfColor.fromHex("fc6200")),
          children: [
            pw.Text("Product/Service",
                style: pw.TextStyle(color: PdfColor(1, 1, 1))),
            pw.Text("Description",
                style: pw.TextStyle(color: PdfColor(1, 1, 1))),
            pw.Text("Unit Cost", style: pw.TextStyle(color: PdfColor(1, 1, 1))),
            pw.Text("Quantity", style: pw.TextStyle(color: PdfColor(1, 1, 1))),
            pw.Text("Discount", style: pw.TextStyle(color: PdfColor(1, 1, 1))),
            pw.Text("Price", style: pw.TextStyle(color: PdfColor(1, 1, 1)))
          ]),
    );
  }
}

pw.Widget pdfHeaderWidget(title, string) {
  return pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
    pw.Text("$title:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
    pw.SizedBox(width: 10),
    pw.Text(string ?? "")
  ]);
}

pw.Widget pdfTrailerWidget(title, string) {
  return pw.Row(children: [
    pw.Expanded(child: pw.Container()),
    pw.Expanded(
        child: pw.Column(children: [
      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
        pw.Text("$title:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.Text(string)
      ]),
      pw.Divider(color: PdfColor.fromHex("cccaca"))
    ]))
  ]);
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
              leading ?? "",
              style: kBLACK_16_BOLD,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              title ?? "",
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
  final TextStyle style;
  const CustomListTileWithNoTrailing({this.title, this.leading, this.style});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Text(
              leading ?? "",
              style: style ?? kBLACK_16,
            ),
          ),
          Expanded(
            flex: 5,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text(":"),
                Expanded(
                  child: Text(
                    title ?? "",
                    textAlign: TextAlign.right,
                    style: style ?? kBLACK_16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Choice {
  const Choice({this.title, this.icon, this.invoiceAction});
  final String title;
  final IconData icon;
  final InvoiceAction invoiceAction;
//  final Function onPressed;
}

const List<Choice> choices = const <Choice>[
  const Choice(
      title: 'Delete Invoice',
      icon: Icons.delete_forever,
      invoiceAction: InvoiceAction.deleteInvoice),
  const Choice(
      title: 'Edit Invoice',
      icon: Icons.mode_edit,
      invoiceAction: InvoiceAction.editInvoice),
  const Choice(
      title: 'Create PDF',
      icon: AppIcons.i_pdf2,
      invoiceAction: InvoiceAction.createPDF),
];
