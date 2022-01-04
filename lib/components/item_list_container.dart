import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:invoicing/modules/item.dart';
import 'package:invoicing/screens/add_edit_item.dart';
import 'package:invoicing/services/custom_firestore.dart';
import 'package:invoicing/utils/constant.dart';
import 'package:invoicing/utils/enums.dart';

class ItemListContainer extends StatelessWidget {
  final Item item;
  final Function onPressed;

  ItemListContainer({this.item, this.onPressed});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.5,
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: 'Delete',
            color: Colors.red,
            icon: Icons.delete_forever,
            onTap: () => _deleteItem(),
          ),
        ],
        child: Column(
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(
                          item.name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 16),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                              item.timestamp.toDate().toString().split(" ")[0]),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              item.currency,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              item.cost,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 18),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: EdgeInsets.all(5),
                          color: kORANGE_LIGHT_COLOR,
                          child: Text(
                            '${item.type == ItemType.service ? "Unite: " : "Quantity: "} ${item.unit}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            Divider(),
          ],
        ),
      ),
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
          return AddEditItem(
            itemOperation: item.type == ItemType.product
                ? ItemOperation.editProduct
                : ItemOperation.editService,
            item: item,
            onPressed: onPressed,
          );
        }));
//        if (onPressed != null) {
//          Navigator.pop(context);
//        }
      },
    );
  }

  void _deleteItem() {
    CustomFireStore.deleteItem(item);
  }
}
