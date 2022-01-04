import 'package:flutter/material.dart';
import 'package:invoicing/screens/add_edit_item.dart';
import 'package:invoicing/utils/enums.dart';

Future<void> addItemPopupMenu(BuildContext context) async {
  switch (await showDialog<ItemType>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Select item type'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, ItemType.product);
              },
              child: const Text('Add Product'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, ItemType.service);
              },
              child: const Text('Add Service'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        );
      })) {
    case ItemType.product:
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return AddEditItem(
          itemOperation: ItemOperation.addProduct,
        );
      }));
      // Edit Product
//      Navigator.push(context, MaterialPageRoute(builder: (context) {
//        return AddEditItem(
//          itemOperation: ItemOperation.editProduct,
//          item: Item(
//              type: ItemType.product,
//              name: "Test Pro",
//              cost: "200",
//              unit: "Month",
//              currency: "EGP"),
//          itemID: "IFhQlR0ab4rREzuOLYQL",
//        );
//      }));
      break;
    case ItemType.service:
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return AddEditItem(
          itemOperation: ItemOperation.addService,
        );
      }));
      //Edit Service
//      Navigator.push(context, MaterialPageRoute(builder: (context) {
//        return AddEditItem(
//          itemOperation: ItemOperation.editService,
//          currency: "EGP",
//          uniteOrQuantity: "Basic2",
//          cost: "10",
//          name: "S2",
//        );
//      }));
      break;
  }
}
