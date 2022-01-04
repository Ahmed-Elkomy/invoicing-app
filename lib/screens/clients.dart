import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:invoicing/components/alert_dialog.dart';
import 'package:invoicing/components/client_list_container.dart';
import 'package:invoicing/components/custom_drawer.dart';
import 'package:invoicing/components/scafold_items.dart';
import 'package:invoicing/components/search_text_field.dart';
import 'package:invoicing/components/search_widget.dart';
import 'package:invoicing/modules/client.dart';
import 'package:invoicing/screens/add_edit_client.dart';
import 'package:invoicing/services/custom_firestore.dart';
import 'package:invoicing/utils/constant.dart';
import 'package:invoicing/utils/globals.dart' as globals;
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Clients extends StatefulWidget {
  static final id = "Clients";
  final Function onPressed;
  Clients({this.onPressed});

  @override
  _ClientsState createState() => _ClientsState();
}

class _ClientsState extends State<Clients> {
  bool _isLoading = false;
  bool _isProduct = true;
  bool _isActiveFilter = false;
  bool _isActiveSearch = false;
  int _clientNumber = 0;

  TextEditingController _businessNameController = TextEditingController();
  TextEditingController _clientNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      resizeToAvoidBottomPadding: false,
      floatingActionButton: getFloatingActionButton(_addClient),
      appBar: getAppBarWhiteWithAction(
          title: 'Clients', filter: _filter, search: _search),
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
                    .collection(CLIENTS_COLLECTION)
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
                      return Expanded(
                        child: new ListView.builder(
                            shrinkWrap: true,
//                            itemCount: snapshot.data.documents.length,
                            itemCount:
                                getClientNumber(snapshot.data.documents.length),
                            itemBuilder: (context, index) {
                              DocumentSnapshot document =
                                  snapshot.data.documents[index];
                              Map<String, dynamic> client = document.data;
                              client[DOCUMENT_ID] = document.documentID;
                              String x = "";
                              if (_matchSearch(Client.fromMap(client))) {
                                return ClientsListContainer(
                                  client: Client.fromMap(client),
                                  onPressed: widget.onPressed,
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

  void _addClient() {
    if (_clientNumber >= globals.clientNumber) {
      Alert.showMyDialogOk(
          context: context,
          title: ERROR_TITLE,
          description: kCLIENT_NUMBER_MAX_REACHED);
    } else {
      Navigator.pushNamed(context, AddEditClient.id);
    }
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
            hintText: "Business Name",
            onChanged: _setState,
          ),
          SizedBox(
            height: kVERTICAL_SPACING,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: SearchTextField(
                  hintText: "Client Name",
                  controller: _clientNameController,
                  onChanged: _setState,
                ),
              ),
              SizedBox(
                width: kVERTICAL_SPACING,
              ),
              Expanded(
                child: SearchTextField(
                  hintText: "Business Email",
                  controller: _emailController,
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
      _clientNameController.text = "";
      _emailController.text = "";
    });
  }

  bool _matchSearch(Client client) {
    List<String> nameList = [
      client.businessEmail,
      client.businessName,
      client.clientName
    ];
    if (_isActiveSearch) {
      if (_stringMatch(nameList, _searchController.text)) {
        return true;
      } else {
        return false;
      }
    } else if (_isActiveFilter) {
      if (client.businessName
              .toLowerCase()
              .contains(_businessNameController.text.toLowerCase()) &&
          client.clientName
              .toLowerCase()
              .contains(_clientNameController.text.toLowerCase()) &&
          client.businessEmail
              .toLowerCase()
              .contains(_emailController.text.toLowerCase())) {
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

  int getClientNumber(int length) {
    _clientNumber = length;
    if (length < globals.clientNumber) {
      return length;
    } else {
      return globals.clientNumber;
    }
  }
}
