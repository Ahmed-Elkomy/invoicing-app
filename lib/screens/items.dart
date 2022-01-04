import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:invoicing/components/custom_drawer.dart';
import 'package:invoicing/components/item_list_container.dart';
import 'package:invoicing/components/scafold_items.dart';
import 'package:invoicing/components/search_text_field.dart';
import 'package:invoicing/components/search_widget.dart';
import 'package:invoicing/modules/item.dart';
import 'package:invoicing/services/custom_firestore.dart';
import 'package:invoicing/utils/constant.dart';
import 'package:invoicing/utils/enums.dart';
import 'package:invoicing/utils/globals.dart' as globals;
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'add_edit_item.dart';

class Items extends StatefulWidget {
  static final id = "Items";
  final Function onPressed;
  Items({this.onPressed});
  @override
  _ItemsState createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  bool _isLoading = false;
  bool _isProduct = true;
  bool _isActiveFilter = false;
  bool _isActiveSearch = false;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _costFromController = TextEditingController();
  TextEditingController _costToController = TextEditingController();
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      resizeToAvoidBottomPadding: false,
//      floatingActionButton: getFloatingActionButton(_addItem),
      appBar: getAppBarWhiteWithAction(
          title: 'Items', filter: _filter, search: _search),
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
                    .collection(ITEMS_COLLECTION)
                    .where("type",
                        isEqualTo:
                            _isProduct ? ITEM_TYPE_PRODUCT : ITEM_TYPE_SERVICE)
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
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot document =
                                  snapshot.data.documents[index];
//                          children: snapshot.data.documents
//                              .map((DocumentSnapshot document) {
                              Map<String, dynamic> item = document.data;
                              item[DOCUMENT_ID] = document.documentID;
//                            return Container();
                              if (_matchSearch(Item.fromMap(item))) {
                                return ItemListContainer(
                                  item: Item.fromMap(item),
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
              Align(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: getFloatingActionButton(_addItem),
                ),
                alignment: Alignment.centerRight,
              ),
              _buildProductServiceButton()
            ],
          ),
        ),
      ),
    );
  }

  Padding _buildProductServiceButton() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              onTap: () {
                _switchView(ItemType.product);
              },
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: kORANGE_COLOR),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      topLeft: Radius.circular(10)),
                  color: _isProduct ? kORANGE_COLOR : Colors.white,
                ),
                child: Text(
                  "Products",
                  style: TextStyle(
                      fontSize: 18,
                      color: _isProduct ? Colors.white : kORANGE_COLOR,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                _switchView(ItemType.service);
              },
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: kORANGE_COLOR),
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  color: _isProduct ? Colors.white : kORANGE_COLOR,
                ),
                child: Text(
                  "Services",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: _isProduct ? kORANGE_COLOR : Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _addItem() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddEditItem(
        itemOperation:
            _isProduct ? ItemOperation.addProduct : ItemOperation.addService,
      );
    }));
  }

  void _switchView(ItemType itemType) {
    if ((itemType == ItemType.product && !_isProduct) ||
        (itemType == ItemType.service && _isProduct)) {
      setState(() {
        _isProduct = !_isProduct;
      });
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
              controller: _nameController,
              hintText: "Name",
              onChanged: _setState),
          SizedBox(
            height: kVERTICAL_SPACING,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: SearchTextField(
                    hintText: "Unit Cost From",
                    controller: _costFromController,
                    keyboardType: TextInputType.number,
                    onChanged: _setState),
              ),
              SizedBox(
                width: kVERTICAL_SPACING,
              ),
              Expanded(
                child: SearchTextField(
                  hintText: "Unit Cost To",
                  controller: _costToController,
                  keyboardType: TextInputType.number,
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
      _nameController.text = "";
      _costFromController.text = "";
      _costToController.text = "";
    });
  }

  bool _matchSearch(Item item) {
    String name = item.name.toString().toLowerCase();
    int cost = int.parse(item.cost);
    int costFrom;
    int costTo;
    if (_isActiveSearch) {
      if (name.contains(_searchController.text.toLowerCase())) {
        return true;
      } else {
        return false;
      }
    } else if (_isActiveFilter) {
      if (name.contains(_nameController.text.toLowerCase())) {
        if (_costFromController.text != "" && _costToController.text != "") {
          costFrom = int.parse(_costFromController.text);
          costTo = int.parse(_costToController.text);
          if (costFrom <= cost && cost <= costTo) {
            return true;
          } else {
            return false;
          }
        } else if (_costFromController.text != "") {
          costFrom = int.parse(_costFromController.text);
          if (costFrom <= cost) {
            return true;
          } else {
            return false;
          }
        } else if (_costToController.text != "") {
          costTo = int.parse(_costToController.text);
          if (cost <= costTo) {
            return true;
          } else {
            return false;
          }
        } else {
          return true;
        }
      } else {
        return false;
      }
    } else {
      return true;
    }
  }

  _setState(value) {
    setState(() {});
  }
}
