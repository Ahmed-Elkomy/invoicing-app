import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:invoicing/utils/constant.dart';
import 'package:invoicing/utils/globals.dart' as globals;

class CustomInAppPurchase {
  bool available;
  final conn = InAppPurchaseConnection.instance;

  CustomInAppPurchase() {
    initializer();
  }

  Future<void> initializer() async {
    available = await conn.isAvailable();
  }

  void makeSubscription(String productID) async {
    Set<String> _kIds = {productID};

    final ProductDetailsResponse response =
        await conn.queryProductDetails(_kIds);
    if (!response.notFoundIDs.isEmpty) {
      print("This  product ID $productID is not found}");
    } else {
      print("This  product ID $productID is found}");
      List<ProductDetails> products = response.productDetails;
      final ProductDetails productDetails = products[0];
      final PurchaseParam purchaseParam =
          PurchaseParam(productDetails: productDetails);
      bool result = await conn.buyNonConsumable(purchaseParam: purchaseParam);
      print(result);
    }
  }

  Future<List<bool>> getPurchases() async {
    bool p1IsPurchased = false;
    bool p2IsPurchased = false;
    bool p3IsPurchased = false;

    QueryPurchaseDetailsResponse response2 = await conn.queryPastPurchases();
    for (PurchaseDetails purchase in response2.pastPurchases) {
      print(
          "purchase ${purchase.transactionDate} , ${purchase.productID}, ${purchase.status} ");
      if (purchase.productID == P1_ID &&
          purchase.status == PurchaseStatus.purchased) {
        p1IsPurchased = true;
      }
      if (purchase.productID == P2_ID &&
          purchase.status == PurchaseStatus.purchased) {
        p2IsPurchased = true;
      }
      if (purchase.productID == P3_ID &&
          purchase.status == PurchaseStatus.purchased) {
        p3IsPurchased = true;
      }
    }
    return [p1IsPurchased, p2IsPurchased, p3IsPurchased];
  }

  Future<void> syncPurchasedProduct() async {
    bool p1IsPurchased = false;
    bool p2IsPurchased = false;
    bool p3IsPurchased = false;

    QueryPurchaseDetailsResponse response2 = await conn.queryPastPurchases();
    for (PurchaseDetails purchase in response2.pastPurchases) {
      if (purchase.productID == P1_ID &&
          purchase.status == PurchaseStatus.purchased) {
        p1IsPurchased = true;
      }
      if (purchase.productID == P2_ID &&
          purchase.status == PurchaseStatus.purchased) {
        p2IsPurchased = true;
      }
      if (purchase.productID == P3_ID &&
          purchase.status == PurchaseStatus.purchased) {
        p3IsPurchased = true;
      }
    }
    if (p2IsPurchased) {
      globals.subscriptionID = P2_ID;
      globals.clientNumber = P2_ACTIVE_CLIENTS_NUMBER;
    } else if (p3IsPurchased) {
      globals.subscriptionID = P3_ID;
      globals.clientNumber = P3_ACTIVE_CLIENTS_NUMBER;
    } else if (p1IsPurchased) {
      globals.subscriptionID = P1_ID;
      globals.clientNumber = P1_ACTIVE_CLIENTS_NUMBER;
    }
    print(globals.subscriptionID);
  }

}
