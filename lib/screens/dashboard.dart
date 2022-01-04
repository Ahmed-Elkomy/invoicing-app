import 'package:flutter/material.dart';
import 'package:invoicing/components/custom_drawer.dart';
import 'package:invoicing/components/dashboard_row.dart';
import 'package:invoicing/screens/add_edit_client.dart';
import 'package:invoicing/screens/clients.dart';
import 'package:invoicing/screens/invoice_select_client.dart';
import 'package:invoicing/screens/invoices.dart';
import 'package:invoicing/screens/items.dart';
import 'package:invoicing/utils/app_icons_icons.dart';
import 'package:invoicing/utils/constant.dart';

import 'help.dart';

class Dashboard extends StatefulWidget {
  static String id = "Dashboard";
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        iconTheme: IconThemeData(color: kORANGE_COLOR),
        title: Text(
          "Dashboard",
          style: TextStyle(color: kORANGE_COLOR),
        ),
        backgroundColor: Color(0xfff3f3f8),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              color: kORANGE_COLOR,
              child: Text(
                kDASHBOARD_WELCOME,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: kDASHBOARD_WELCOME_SIZE),
                textAlign: TextAlign.center,
              ),
            ),
            DashboardRow(
              topMargin: kDASHBOARD_ITEMS_EXTERNAL_MARGIN,
              sideMargin: kDASHBOARD_ITEMS_EXTERNAL_MARGIN,
              leftIcon: AppIcons.i010_invoices,
              leftText: "Create Invoice",
              leftPageId: InvoiceSelectClient.id,
              rightIcon: AppIcons.i002_customer,
              rightText: "Create Clients",
              rightPageId: AddEditClient.id,
              lastRow: false,
            ),
            DashboardRow(
              topMargin: 0,
              sideMargin: kDASHBOARD_ITEMS_EXTERNAL_MARGIN,
              leftIcon: AppIcons.i001_to_do_list,
              leftText: "Create Items",
              leftPageId: Help.id,
              rightIcon: AppIcons.i010_invoices,
              rightText: "Invoices",
              rightPageId: Invoices.id,
              lastRow: false,
            ),
            DashboardRow(
              topMargin: 0,
              sideMargin: kDASHBOARD_ITEMS_EXTERNAL_MARGIN,
              leftIcon: AppIcons.i002_customer,
              leftText: "Clients",
              leftPageId: Clients.id,
              rightIcon: AppIcons.i001_to_do_list,
              rightText: "Items",
              rightPageId: Items.id,
              lastRow: true,
            ),
          ],
        ),
      ),
    );
  }
}
