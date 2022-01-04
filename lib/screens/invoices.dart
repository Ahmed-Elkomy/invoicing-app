import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:invoicing/components/custom_drawer.dart';
import 'package:invoicing/components/invoice_list_container.dart';
import 'package:invoicing/components/scafold_items.dart';
import 'package:invoicing/components/search_date_text_field.dart';
import 'package:invoicing/components/search_text_field.dart';
import 'package:invoicing/components/search_widget.dart';
import 'package:invoicing/modules/Invoice.dart';
import 'package:invoicing/services/custom_firestore.dart';
import 'package:invoicing/utils/constant.dart';
import 'package:invoicing/utils/globals.dart' as globals;
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'invoice_select_client.dart';

class Invoices extends StatefulWidget {
  static final id = "Invoices";

  @override
  _InvoicesState createState() => _InvoicesState();
}

class _InvoicesState extends State<Invoices> {
  bool _isLoading = false;
  bool _isActiveFilter = false;
  bool _isActiveSearch = false;

  TextEditingController _businessNameController = TextEditingController();
  TextEditingController _dateFromController = TextEditingController();
  TextEditingController _dateToController = TextEditingController();
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      resizeToAvoidBottomPadding: false,
      floatingActionButton: getFloatingActionButton(_addInvoice),
      appBar: getAppBarWhiteWithAction(
          title: 'Invoices', filter: _filter, search: _search),
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _isActiveFilter ? _buildFilterWidget() : Container(),
              _isActiveSearch
                  ? SearchWidget(
                      controller: _searchController,
                      onPressed: _getSearchResult,
                      onChanged: _setState,
                    )
                  : Container(),
              SizedBox(
                height: 2 * kVERTICAL_SPACING,
              ),
              StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection(INVOICES_COLLECTION)
                    .where(USER_ID, isEqualTo: globals.userID)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError)
                    return Expanded(
                        child: Center(
                            child: new Text('Error: ${snapshot.error}')));
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Expanded(
                          child: Center(child: new Text('Loading...')));
                    default:
                      //sorting the snapshot
                      List<DocumentSnapshot> documents =
                          snapshot.data.documents;
                      documents.sort((o1, o2) {
                        Invoice invoice1 = Invoice.fromMap(o1.data);
                        Invoice invoice2 = Invoice.fromMap(o2.data);
                        int num1 = 0;
                        int num2 = 0;
                        try {
                          num1 = int.parse(invoice1.invoiceNo.split("-")[1]);
                          num2 = int.parse(invoice2.invoiceNo.split("-")[1]);
                        } catch (e) {
                          print(
                              "error in the sorting the invoices, some of them didn't include \"-\"");
                        }
                        return num1.compareTo(num2);
                      });
                      return Expanded(
                        child: new ListView.builder(
                            shrinkWrap: true,
                            itemCount: documents.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot document = documents[index];
                              Map<String, dynamic> invocie = document.data;
                              invocie[DOCUMENT_ID] = document.documentID;
                              if (_matchSearch(Invoice.fromMap(invocie))) {
                                return InvoiceListContainer(
                                  invoice: Invoice.fromMap(invocie),
                                );
                              } else {
                                return Container();
                              }
                            }),
                      );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addInvoice() {
    Navigator.pushNamed(context, InvoiceSelectClient.id);
  }

  void _filter() {
    setState(() {
      _isActiveSearch = false;
      _isActiveFilter = !_isActiveFilter;
    });
  }

  void _search() {
    setState(() {
      _isActiveFilter = false;
      _isActiveSearch = !_isActiveSearch;
    });
  }

  Widget _buildFilterWidget() {
    return Container(
      padding: EdgeInsets.all(10),
      color: kGREY_COLOR,
      child: Column(
        children: <Widget>[
          SearchTextField(
            controller: _businessNameController,
            hintText: "Client Name",
            onChanged: _setState,
          ),
          SizedBox(
            height: kVERTICAL_SPACING,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: SearchDateTextField(
                  hintText: "Date From",
                  controller: _dateFromController,
                  onChanged: _setState,
                ),
              ),
              SizedBox(
                width: kVERTICAL_SPACING,
              ),
              Expanded(
                child: SearchDateTextField(
                  hintText: "Date To",
                  controller: _dateToController,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: _setState,
                ),
              ),
            ],
          ),
          SizedBox(
            height: kVERTICAL_SPACING,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: RaisedButton(
                  child: Text("Search"),
                  onPressed: _getFilterResult,
                ),
              ),
              SizedBox(
                width: kVERTICAL_SPACING,
              ),
              Expanded(
                child: RaisedButton(
                  child: Text("Cancel"),
                  onPressed: _cancelFilterResult,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _getSearchResult() {
    FocusScope.of(context).requestFocus(new FocusNode());
    setState(() {});
  }

  void _getFilterResult() {
    FocusScope.of(context).requestFocus(new FocusNode());
    setState(() {});
  }

  void _cancelFilterResult() {
    FocusScope.of(context).requestFocus(new FocusNode());
    setState(() {
      _isActiveFilter = false;
      _businessNameController.text = "";
      _dateFromController.text = "";
      _dateToController.text = "";
    });
  }

  bool _matchSearch(Invoice invoice) {
    List<String> nameList = [
      invoice.clientName,
      invoice.invoiceNo,
      invoice.invoiceDate
    ];
    if (_isActiveSearch) {
      if (_stringMatch(nameList, _searchController.text)) {
        return true;
      } else {
        return false;
      }
    } else if (_isActiveFilter) {
      DateTime invoiceDate = invoiceDateFormatter.parse(invoice.invoiceDate);
      DateTime dateFrom = DateTime(1900);
      DateTime dateTo = DateTime(3000);
      if (_dateFromController.text != "") {
        dateFrom = invoiceDateFormatter.parse(_dateFromController.text);
      }
      if (_dateToController.text != "") {
        dateTo = invoiceDateFormatter.parse(_dateToController.text);
      }

      if (invoice.clientName
              .toLowerCase()
              .contains(_businessNameController.text.toLowerCase()) &&
          (invoiceDate.isAfter(dateFrom) ||
              invoiceDate.isAtSameMomentAs(dateFrom)) &&
          (invoiceDate.isBefore(dateTo) ||
              invoiceDate.isAtSameMomentAs(dateTo))) {
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }

  _stringMatch(List<String> list, String str) {
    bool match = false;
    list.forEach((element) {
      if (element.toLowerCase().contains(str.toLowerCase())) {
        match = true;
      }
    });

    return match;
  }

  _setState(value) {
    setState(() {});
  }
}
