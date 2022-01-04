import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:invoicing/modules/Invoice.dart';
import 'package:invoicing/modules/client.dart';
import 'package:invoicing/modules/item.dart';
import 'package:invoicing/modules/user.dart';

const ITEMS_COLLECTION = "items";
const USERS_COLLECTION = "users";
const CLIENTS_COLLECTION = "clients";
const INVOICES_COLLECTION = "invoices";
const USER_ID = "user_id";
const DOCUMENT_ID = "document_id";
const ITEM_TYPE_PRODUCT = "ItemType.product";
const ITEM_TYPE_SERVICE = "ItemType.service";

class CustomFireStore {
  static final _auth = FirebaseAuth.instance;
  static final dB = Firestore.instance;

  static addItem(Item item) async {
    item.userID = await getUserId();
    Map data = item.toMap();
    DocumentReference ref = await dB.collection(ITEMS_COLLECTION).add(data);
  }

  static editItem(Item item) async {
    item.userID = await getUserId();
    Map data = item.toMap();
    await dB
        .collection(ITEMS_COLLECTION)
        .document(item.documentID)
        .updateData(data);
  }

  static deleteItem(Item item) async {
    await dB.collection(ITEMS_COLLECTION).document(item.documentID).delete();
  }

  static addClient(Client client) async {
    client.userID = await getUserId();
    Map data = client.toMap();
    DocumentReference ref = await dB.collection(CLIENTS_COLLECTION).add(data);
  }

  static editClient(Client client) async {
    print("client.documentID: ${client.documentID}");
    client.userID = await getUserId();
    Map data = client.toMap();
    await dB
        .collection(CLIENTS_COLLECTION)
        .document(client.documentID)
        .updateData(data);
  }

  static deleteClient(Client client) async {
    await dB
        .collection(CLIENTS_COLLECTION)
        .document(client.documentID)
        .delete();
  }

  static Future<int> getClientsNumber() async {
    String userID = await getUserId();
    int clientsNo = 0;
    var respectsQuery =
        dB.collection(CLIENTS_COLLECTION).where(USER_ID, isEqualTo: userID);
    var querySnapshot = await respectsQuery.getDocuments();
    clientsNo = querySnapshot.documents.length;
    return clientsNo;
  }

  static Future<void> addEditInvoiceToClient(
      {String clientID, String invoiceAmount, String invoiceID}) async {
    Client client;
    await dB.collection(CLIENTS_COLLECTION).document(clientID).get().then(
        (DocumentSnapshot documentSnapshot) =>
            client = Client.fromMap(documentSnapshot.data));
    print("clientID: $clientID");
    Map<String, String> invoices = client.invoices;
//    if (client != null &&
//        client.invoices != null &&
//        client.invoices.isNotEmpty) {
//      invoices = client.invoices;
//    } else {
//      invoices = Map<String, String>();
//    }
    invoices[invoiceID] = invoiceAmount;
    print(client);
    print(client.clientName);
    client.invoices = invoices;
    client.documentID = clientID;
    await editClient(client);
  }

  static Future<String> getClientTotalInvoiceAmount(String clientID) async {
    double invoicesAmount = 0;
    var respectsQuery = dB
        .collection(INVOICES_COLLECTION)
        .where('client_id', isEqualTo: clientID);
    var querySnapshot = await respectsQuery.getDocuments();
    List<DocumentSnapshot> snapshots = querySnapshot.documents;
    snapshots.forEach((snapshot) {
      Invoice invoice = Invoice.fromMap(snapshot.data);
      invoicesAmount += double.parse(invoice.getGrossTotalAfterTaxs());
    });
    return invoicesAmount.toStringAsFixed(2);
  }

  static addInvoice(Invoice invoice) async {
    invoice.userID = await getUserId();
    Map data = invoice.toMap();
    DocumentReference ref = await dB.collection(INVOICES_COLLECTION).add(data);
    await addEditInvoiceToClient(
        clientID: invoice.clientID,
        invoiceAmount: invoice.getGrossTotalAfterTaxs(),
        invoiceID: ref.documentID);
  }

  static editInvoice(Invoice invoice) async {
    invoice.userID = await getUserId();
    Map data = invoice.toMap();
    await dB
        .collection(INVOICES_COLLECTION)
        .document(invoice.documentID)
        .updateData(data);
    await addEditInvoiceToClient(
        clientID: invoice.clientID,
        invoiceAmount: invoice.getGrossTotalAfterTaxs(),
        invoiceID: invoice.documentID);
  }

  static Future<String> getLastInvoiceID() async {
    String userID = await getUserId();
    int id = 0;
    print("yes");
    await dB
        .collection(INVOICES_COLLECTION)
        .where(USER_ID, isEqualTo: userID)
        .getDocuments()
        .then((QuerySnapshot querySnapshot) => querySnapshot.documents
                .forEach((DocumentSnapshot documentSnapshot) {
              print("yes");
              if (documentSnapshot.data['invoice_no']
                  .toString()
                  .contains('INV-')) {
                int docID = int.parse(documentSnapshot.data['invoice_no']
                    .toString()
                    .split("-")[1]);
                id = id <= docID ? docID : id;
              }
            }));
    id += 1;
    return "INV-${id.toString()}";
  }

  static deleteInvoice(Invoice invoice) async {
    await dB
        .collection(INVOICES_COLLECTION)
        .document(invoice.documentID)
        .delete();
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    String userID = await getUserId();
    List<Map<String, dynamic>> data = List<Map<String, dynamic>>();
    await dB
        .collection(ITEMS_COLLECTION)
        .where(USER_ID, isEqualTo: userID)
        .getDocuments()
        .then((value) => value.documents.forEach((element) {
              element.data[DOCUMENT_ID] = element.documentID;
              data.add(element.data);
            }));
    return data;
  }

  static Future<String> getUserId() async {
    FirebaseUser user = await _auth.currentUser();
    return user.uid;
  }

  static Future<User> getUserData() async {
    FirebaseUser user = await _auth.currentUser();
    print(user.uid);
    String username = "";
    String companyName = "";
    String companyAddress = "";
    await dB
        .collection(USERS_COLLECTION)
        .document(user.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      print(documentSnapshot.data);
      username =
          "${documentSnapshot.data['first_name']} ${documentSnapshot.data['last_name']}";
      companyName = documentSnapshot.data.containsKey('company_name')
          ? documentSnapshot.data['company_name']
          : "";
      companyAddress = documentSnapshot.data.containsKey('company_address')
          ? documentSnapshot.data['company_address']
          : "";
    });
    User userData = User(
        username: username,
        companyName: companyName,
        companyAddress: companyAddress);
    return userData;
  }
}
