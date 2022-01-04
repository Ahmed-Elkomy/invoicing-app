import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:invoicing/modules/Invoice.dart';
import 'package:invoicing/utils/constant.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'package:printing/printing.dart';

class InvoicePDF extends StatefulWidget {
  static final String id = "InvoicePdf";
  final Invoice invoice;
  final String path;
  final pw.Document doc;
  InvoicePDF({this.invoice, this.path, this.doc});

  @override
  _InvoicePDFState createState() => _InvoicePDFState();
}

class _InvoicePDFState extends State<InvoicePDF> {
  bool _isLoading = false;
  Invoice invoice;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    File(widget.path).delete();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    invoice = widget.invoice;
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
          IconButton(
            icon: Icon(Icons.screen_share),
            onPressed: sharePDF,
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: _isLoading,
          child: Container(
            height: double.infinity,
            padding: EdgeInsets.symmetric(vertical: kVERTICAL_SPACING),
            child: PdfViewer(
              filePath: widget.path,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> sharePDF() async {
    await Printing.sharePdf(
        bytes: widget.doc.save(), filename: 'Invoice ${invoice.invoiceNo}.pdf');
  }
}
