import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:invoicing/components/custom_drawer.dart';
import 'package:invoicing/services/custom_in_app_purchase.dart';
import 'package:invoicing/utils/constant.dart';

class Subscriptions extends StatefulWidget {
  static String id = "subscriptions";
  @override
  _SubscriptionsState createState() => _SubscriptionsState();
}

class _SubscriptionsState extends State<Subscriptions> {
  String _plan = "Free";
  bool p1IsPurchased = false;
  bool p2IsPurchased = false;
  bool p3IsPurchased = false;

  CustomInAppPurchase _customInAppPurchase = CustomInAppPurchase();
  bool _purchasePending = false;
  List<PurchaseDetails> _purchases = [];
  StreamSubscription<List<PurchaseDetails>> _subscriptionStream;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializer();
    updateProductStatusAfterPurchase();
  }

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
          "Subscription",
          style: TextStyle(color: kORANGE_COLOR),
        ),
        backgroundColor: Color(0xfff3f3f8),
      ),
      body: _purchasePending
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Container(
                padding: EdgeInsets.all(kVERTICAL_SPACING),
                child: ListView(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(20),
                      color: kGREY_COLOR,
                      child: Text(
                        "Current Plan: $_plan",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: kVERTICAL_SPACING),
                      padding: EdgeInsets.all(20),
                      color: kGREY_COLOR,
                      child: Text(
                        "Choose a plan based on your business needs",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      height: 230,
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Expanded(child: P1Card()),
                            Expanded(child: P2Card())
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 230,
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Expanded(child: P3Card()),
                            Expanded(child: Card())
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    print("lenght of the update is : ${purchaseDetailsList.length}");
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status != PurchaseStatus.error &&
          purchaseDetails.productID != null) {
        _purchasePending = false;
        print(
            "purchaseDetails from the stream, ID: ${purchaseDetails.productID}, status ${purchaseDetails.status}");
        await InAppPurchaseConnection.instance
            .completePurchase(purchaseDetails);
      }
      await _customInAppPurchase.syncPurchasedProduct();
      await updateProductStatusAfterPurchase();
    });
  }

  Future<void> updateProductStatusAfterPurchase() async {
    List<bool> tmp = await _customInAppPurchase.getPurchases();
    setState(() {
      p1IsPurchased = tmp[0];
      p2IsPurchased = tmp[1];
      p3IsPurchased = tmp[2];
      if (p2IsPurchased) {
        _plan = P2_Name;
      } else if (p3IsPurchased) {
        _plan = P3_Name;
      } else if (p1IsPurchased) {
        _plan = P1_Name;
      }
    });
  }

  Future<void> initializer() async {
    Stream purchaseUpdated = _customInAppPurchase.conn.purchaseUpdatedStream;
    _subscriptionStream = purchaseUpdated.listen((purchaseDetailsList) {
      print("pushassssssssssssssssssssssssssssssssssed");
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscriptionStream.cancel();
      print("Donnnnnnnnnnnnnnnnnnnnnnnnnne");
    }, onError: (error) {
      print("Errrrrrrrrrrrrrrrrror");
    });
  }

  Widget P1Card() {
    return Card(
      elevation: 10,
      child: Container(
        padding: EdgeInsets.only(
            top: 2 * kVERTICAL_SPACING,
//            bottom: 4 * kVERTICAL_SPACING,
            left: kVERTICAL_SPACING,
            right: kVERTICAL_SPACING),
        child: Column(
          children: <Widget>[
            Text(
              P1_Name,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
            SizedBox(
              height: kVERTICAL_SPACING,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: AutoSizeText(
                    P1_PRICE_UNITES,
                    style: TextStyle(
                        color: kORANGE_COLOR,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                    maxLines: 1,
                  ),
                ),
                Flexible(
                  flex: 3,
                  child: AutoSizeText(
                    P1_PRICE_VALUE,
                    style: TextStyle(
                        color: kORANGE_COLOR,
                        fontSize: 24,
                        fontWeight: FontWeight.w800),
                    maxLines: 1,
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: AutoSizeText(
                    P1_PRICE_RECURRENCE,
                    style: TextStyle(
                        color: kORANGE_COLOR,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            RaisedButton(
              onPressed: p1IsPurchased
                  ? null
                  : () {
                      purchase(P1_ID);
                    },
              color: kORANGE_COLOR,
              child: Text(
                p1IsPurchased ? P1_Activated : P1_UPGRADE,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(
              height: kVERTICAL_SPACING,
            ),
            Text(
              P1_ACTIVE_CLIENTS,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
//            SizedBox(
//              height: 2 * kVERTICAL_SPACING,
//            ),
          ],
        ),
      ),
    );
  }

  Widget P2Card() {
    return Card(
      elevation: 10,
      child: Container(
        padding: EdgeInsets.only(
            top: 2 * kVERTICAL_SPACING,
//            bottom: 4 * kVERTICAL_SPACING,
            left: kVERTICAL_SPACING,
            right: kVERTICAL_SPACING),
        child: Column(
          children: <Widget>[
            Text(
              P2_Name,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
            SizedBox(
              height: kVERTICAL_SPACING,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: AutoSizeText(
                    P2_PRICE_UNITES,
                    style: TextStyle(
                        color: kORANGE_COLOR,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                    maxLines: 1,
                  ),
                ),
                Flexible(
                  flex: 3,
                  child: AutoSizeText(
                    P2_PRICE_VALUE,
                    style: TextStyle(
                        color: kORANGE_COLOR,
                        fontSize: 24,
                        fontWeight: FontWeight.w800),
                    maxLines: 1,
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: AutoSizeText(
                    P2_PRICE_RECURRENCE,
                    style: TextStyle(
                        color: kORANGE_COLOR,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            RaisedButton(
              onPressed: p2IsPurchased
                  ? null
                  : () {
                      purchase(P2_ID);
                    },
              color: kORANGE_COLOR,
              child: Text(
                p2IsPurchased ? P2_Activated : P2_UPGRADE,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(
              height: kVERTICAL_SPACING,
            ),
            Text(
              P2_ACTIVE_CLIENTS,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget P3Card() {
    return Card(
      elevation: 10,
      child: Container(
        padding: EdgeInsets.only(
            top: 2 * kVERTICAL_SPACING,
//            bottom: 4 * kVERTICAL_SPACING,
            left: kVERTICAL_SPACING,
            right: kVERTICAL_SPACING),
        child: Column(
          children: <Widget>[
            Text(
              P3_Name,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
            SizedBox(
              height: kVERTICAL_SPACING,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: AutoSizeText(
                    P3_PRICE_UNITES,
                    style: TextStyle(
                        color: kORANGE_COLOR,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                    maxLines: 1,
                  ),
                ),
                Flexible(
                  flex: 3,
                  child: AutoSizeText(
                    P3_PRICE_VALUE,
                    style: TextStyle(
                        color: kORANGE_COLOR,
                        fontSize: 24,
                        fontWeight: FontWeight.w800),
                    maxLines: 1,
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: AutoSizeText(
                    P3_PRICE_RECURRENCE,
                    style: TextStyle(
                        color: kORANGE_COLOR,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            RaisedButton(
              onPressed: p3IsPurchased
                  ? null
                  : () {
                      purchase(P3_ID);
                    },
              color: kORANGE_COLOR,
              child: Text(
                p3IsPurchased ? P3_Activated : P3_UPGRADE,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(
              height: kVERTICAL_SPACING,
            ),
            Text(
              P3_ACTIVE_CLIENTS,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
//            SizedBox(
//              height: kVERTICAL_SPACING,
//            ),
          ],
        ),
      ),
    );
  }

  void purchase(String id) {
    _customInAppPurchase.makeSubscription(id);
  }
}
