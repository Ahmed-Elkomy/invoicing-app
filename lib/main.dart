import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:invoicing/screens/add_edit_client.dart';
import 'package:invoicing/screens/add_edit_invoice.dart';
import 'package:invoicing/screens/clients.dart';
import 'package:invoicing/screens/dashboard.dart';
import 'package:invoicing/screens/forget_password.dart';
import 'package:invoicing/screens/help.dart';
import 'package:invoicing/screens/invoice_pdf.dart';
import 'package:invoicing/screens/invoice_select_client.dart';
import 'package:invoicing/screens/invoices.dart';
import 'package:invoicing/screens/items.dart';
import 'package:invoicing/screens/login.dart';
import 'package:invoicing/screens/register.dart';
import 'package:invoicing/screens/startup_view.dart';
import 'package:invoicing/screens/subscriptions.dart';
import 'package:invoicing/utils/constant.dart';

void main() {
  InAppPurchaseConnection.enablePendingPurchases();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Invoicing Demo",
      theme: ThemeData(
        primaryColor: kORANGE_COLOR,
//          floatingActionButtonTheme: ThemeData.dark()

//        unselectedWidgetColor: kORANGE_COLOR,
      ),
      initialRoute: StartupView.id,
      routes: {
        StartupView.id: (context) => StartupView(),
        Login.id: (context) => Login(),
        ForgetPassword.id: (context) => ForgetPassword(),
        Register.id: (context) => Register(),
        Dashboard.id: (context) => Dashboard(),
        Help.id: (context) => Help(),
        Subscriptions.id: (context) => Subscriptions(),
//        AddEditItem.id: (context) => AddEditItem(),
        Items.id: (context) => Items(),
        Clients.id: (context) => Clients(),
        AddEditClient.id: (context) => AddEditClient(),
        Invoices.id: (context) => Invoices(),
        InvoiceSelectClient.id: (context) => InvoiceSelectClient(),
        AddEditInvoice.id: (context) => AddEditInvoice(),
        InvoicePDF.id: (context) => InvoicePDF(),
      },
    );
  }
}
