import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:invoicing/services/custom_firestore.dart';

class Client {
  String documentID;
  String userID;

  String clientName;
  String businessName;
  String businessEmail;
  String phoneNumber;
  String billingAddress;
  String shippingAddress;
  String country;
  String currency;
  String notes;
  String outstanding;
  Map<String, String> invoices;
  String credit;
  Timestamp timestamp;
  Client(
      {this.userID,
      this.documentID,
      this.timestamp,
      this.currency,
      this.clientName,
      this.phoneNumber,
      this.billingAddress,
      this.country,
      this.businessEmail,
      this.credit,
      this.outstanding,
      this.invoices,
      this.businessName,
      this.notes,
      this.shippingAddress});
  Map toMap() {
    Map data = Map<String, dynamic>();
    data[USER_ID] = userID;
    data['client_name'] = clientName;
    data['business_name'] = businessName;
    data['business_email'] = businessEmail;
    data['phone_number'] = phoneNumber;
    data['billing_address'] = billingAddress;
    data['shipping_address'] = shippingAddress;
    data['country'] = country;
    data['currency'] = currency;
    data['notes'] = notes;
    data['outstanding'] = outstanding;
    data['invoices'] = invoices;
    data['credit'] = credit;
    data["timestamp"] = timestamp;
    return data;
  }

  Client.fromMap(Map data) {
    userID = data[USER_ID];
    documentID = data[DOCUMENT_ID] ?? "";
    clientName = data['client_name'];
    businessName = data['business_name'];
    businessEmail = data['business_email'];
    phoneNumber = data['phone_number'];
    billingAddress = data['billing_address'];
    shippingAddress = data['shipping_address'];
    country = data['country'];
    currency = data['currency'];
    notes = data['notes'];
    outstanding = data['outstanding'] ?? Map<String, String>();
    invoices = data['invoices'] != null
        ? Map<String, String>.from(data['invoices'])
        : Map<String, String>();
    credit = data['credit'];
    timestamp = data["timestamp"];
  }
}
