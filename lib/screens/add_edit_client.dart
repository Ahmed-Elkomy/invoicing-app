import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:invoicing/components/alert_dialog.dart';
import 'package:invoicing/components/borders_text_field.dart';
import 'package:invoicing/components/country_widget.dart';
import 'package:invoicing/components/currency_widget.dart';
import 'package:invoicing/components/scafold_items.dart';
import 'package:invoicing/modules/client.dart';
import 'package:invoicing/services/custom_firestore.dart';
import 'package:invoicing/utils/constant.dart';
import 'package:invoicing/utils/enums.dart';
import 'package:invoicing/utils/generic_functions.dart';
import 'package:invoicing/utils/globals.dart' as globals;
import 'package:modal_progress_hud/modal_progress_hud.dart';

class AddEditClient extends StatefulWidget {
  static final id = "AddEditClient";
  final Client client;
  final ClientOperation clientOperation;
  AddEditClient({this.clientOperation, this.client});
  @override
  _AddEditClientState createState() => _AddEditClientState();
}

class _AddEditClientState extends State<AddEditClient> {
  TextEditingController _clientNameController = TextEditingController();
  TextEditingController _businessNameController = TextEditingController();
  TextEditingController _businessEmailController = TextEditingController();
  TextEditingController _phoneNoController = TextEditingController();
  TextEditingController _billingAddressController = TextEditingController();
  TextEditingController _shippingAddressController = TextEditingController();
  TextEditingController _notesController = TextEditingController();
  final key = GlobalKey<CurrencyWidgetState>();
  final key2 = GlobalKey<CountryWidgetState>();
  String _currency;
  String _country;
  bool _isShowMore;
  bool _isBillingAsShippingAddr = false;
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initializeItemWidget();
    _isShowMore = _isEditClient() ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBarWhite(_isEditClient() ? "Edit Client" : "Create Client"),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: _isLoading,
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 2 * kVERTICAL_SPACING,
              ),
              BordersTextField(
                controller: _clientNameController,
                label: "Client Name:",
                textCapitalization: TextCapitalization.words,
              ),
              BordersTextField(
                controller: _businessNameController,
                label: "Buss. Name:",
                textCapitalization: TextCapitalization.words,
              ),
              BordersTextField(
                controller: _businessEmailController,
                label: "Buss. Email:",
                keyboardType: TextInputType.emailAddress,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(),
                    ),
                    Expanded(
                      flex: 1,
                      child: FlatButton(
                        color: kORANGE_COLOR,
                        child: Text(
                          _isShowMore ? "REMOVE OPTIONS" : "ADD MORE OPTIONS",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: _addMoreOptions,
                      ),
                    )
                  ],
                ),
              ),
              AnimatedOpacity(
                opacity: _isShowMore ? 1 : 0,
                duration: Duration(milliseconds: 1000),
                child: _isShowMore
                    ? Column(
                        children: <Widget>[
                          BordersTextField(
                            controller: _phoneNoController,
                            label: "Phone no:",
                            keyboardType: TextInputType.phone,
                          ),
                          BordersTextField(
                            controller: _billingAddressController,
                            label: "Billing Addr.:",
                          ),
                          Row(
                            children: <Widget>[
                              Checkbox(
                                tristate: false,
                                checkColor: Colors.orange,
                                activeColor: Colors.white,
                                hoverColor: Colors.orange,
                                value: _isBillingAsShippingAddr,
                                onChanged: (bool value) {
                                  setState(() {
                                    _isBillingAsShippingAddr = value;
                                  });
                                },
                              ),
                              Text(
                                "If shipping address is same as billing address",
//                              style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                          _isBillingAsShippingAddr
                              ? Container()
                              : BordersTextField(
                                  controller: _shippingAddressController,
                                  label: "Shipping Addr.:",
                                ),
                          CurrencyWidget(
                            key: key,
                            context: context,
                            currency: _currency ?? getLocalCurrency(context),
                            onTap: () {
                              _currency = key.currentState.currency;
                            },
                          ),
                          CountryWidget(
                            key: key2,
                            context: context,
                            country: _country ?? getLocalCountry(context),
                            onTap: () {
                              _country = key2.currentState.country;
                            },
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                top: 5, bottom: 5, right: 10, left: 10),
                            child: TextField(
                              maxLines: 3,
                              controller: _notesController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.zero)),
                                labelText: "Note",
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(),
              ),
              SizedBox(height: 2 * kVERTICAL_SPACING),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: RaisedButton(
                  onPressed: _save,
                  color: kORANGE_COLOR,
                  child: Text(
                    "SAVE",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    int clientsNo = await CustomFireStore.getClientsNumber();
    if (clientsNo >= globals.clientNumber) {
      Alert.showMyDialogOk(
          context: context,
          title: ERROR_TITLE,
          description: kCLIENT_NUMBER_MAX_REACHED);
      return;
    }

    //if the currency is null, it will be updated with the default currency

    _currency = _currency ?? getLocalCurrency(context);
    _country = _country ?? getLocalCountry(context);
    setState(() {
      _isLoading = true;
    });
    if (_isEditClient()) {
      await _editClient();
    } else {
      await _addClient();
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.pop(context);
  }

  bool _isEditClient() {
    if (widget.clientOperation != null &&
        widget.clientOperation == ClientOperation.editClient) {
      return true;
    } else {
      return false;
    }
  }

  void _addMoreOptions() {
    FocusScope.of(context).requestFocus(new FocusNode());
    setState(() {
      _isShowMore = !_isShowMore;
    });
  }

  String _initializeItemWidget() {
    if (_isEditClient()) {
      //initialize the widgets
      Client client = widget.client;
      _clientNameController.text = widget.client.clientName;
      _businessNameController.text = client.businessName;
      _businessEmailController.text = client.businessEmail;
      _phoneNoController.text = client.phoneNumber;
      _billingAddressController.text = client.billingAddress;
      _shippingAddressController.text = client.shippingAddress;
      _notesController.text = client.notes;
      _currency = client.currency;
      _country = client.country;
    }
  }

  Future<void> _editClient() async {
    Client client = widget.client;
    client.currency = _currency;
    client.timestamp = Timestamp.now();
    client.billingAddress = _billingAddressController.text;
    client.businessEmail = _businessEmailController.text;
    client.businessName = _businessNameController.text;
    client.clientName = _clientNameController.text;
    client.country = _country;
    client.notes = _notesController.text;
    client.phoneNumber = _phoneNoController.text;
    client.shippingAddress = _shippingAddressController.text;
    await CustomFireStore.editClient(client);
  }

  Future<void> _addClient() async {
    Client client = Client(
      currency: _currency,
      timestamp: Timestamp.now(),
      billingAddress: _billingAddressController.text,
      businessEmail: _businessEmailController.text,
      businessName: _businessNameController.text,
      clientName: _clientNameController.text,
      country: _country,
      credit: "0.00",
      notes: _notesController.text,
      outstanding: "0.00",
      phoneNumber: _phoneNoController.text,
      shippingAddress: _shippingAddressController.text,
    );
    await CustomFireStore.addClient(client);
  }
}
