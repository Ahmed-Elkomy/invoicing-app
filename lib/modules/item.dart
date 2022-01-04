import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:invoicing/services/custom_firestore.dart';
import 'package:invoicing/utils/enums.dart';

class Item {
  String documentID;
  String userID;
  ItemType type; //product or service
  String name;
  String unit;
  String cost;
  String currency;
  String description;
  String discount;
  Timestamp timestamp;

  Item({
    this.documentID,
    this.userID,
    this.currency,
    this.unit,
    this.cost,
    this.timestamp,
    this.type,
    this.name,
  });

  //documentID will not stored in the DB
  Map toMap() {
    Map data = Map<String, dynamic>();
    data[USER_ID] = userID;
    data["type"] = type.toString();
    data["name"] = name;
    data["unit"] = unit;
    data["cost"] = cost;
    data["currency"] = currency;
    data["timestamp"] = timestamp;
    return data;
  }

  //documentID will be retrieved from the Firestore and stored to the created object
  Item.fromMap(Map data) {
    userID = data[USER_ID];
    documentID = data[DOCUMENT_ID] ?? "";
    type = _convertType(data["type"]);
    name = data["name"];
    unit = data["unit"];
    cost = data["cost"];
    currency = data["currency"];
    timestamp = data["timestamp"];
  }

  ItemType _convertType(String type) {
    if (type == ITEM_TYPE_PRODUCT) {
      return ItemType.product;
    } else if (type == ITEM_TYPE_SERVICE) {
      return ItemType.service;
    }
    //the default value
//    return ItemType.product;
  }
}
