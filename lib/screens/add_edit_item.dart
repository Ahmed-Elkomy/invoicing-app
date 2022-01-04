import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:invoicing/components/alert_dialog.dart';
import 'package:invoicing/components/big_text_field.dart';
import 'package:invoicing/components/borders_text_field.dart';
import 'package:invoicing/components/currency_widget.dart';
import 'package:invoicing/components/scafold_items.dart';
import 'package:invoicing/components/text_picker.dart';
import 'package:invoicing/modules/item.dart';
import 'package:invoicing/services/custom_firestore.dart';
import 'package:invoicing/utils/constant.dart';
import 'package:invoicing/utils/enums.dart';
import 'package:invoicing/utils/generic_functions.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class AddEditItem extends StatefulWidget {
  static final id = "AddEditItem";

  final ItemOperation itemOperation;
  final Item item;
  final Function onPressed;

  AddEditItem({this.item, this.onPressed, @required this.itemOperation});

  @override
  _AddEditItemState createState() => _AddEditItemState();
}

class _AddEditItemState extends State<AddEditItem> {
  final key = GlobalKey<CurrencyWidgetState>();
  bool _isLoading = false;
  bool isProduct;
  String _currency;
  String _serviceUnit = "";
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _productQuanityController = new TextEditingController();
  TextEditingController _costController = new TextEditingController();
  TextEditingController _discountController = new TextEditingController();
  DiscountType _discountType = DiscountType.flat;
  Function itemFunction;
  String _title;
  String _description;

  @override
  Future<void> initState() {
    // TODO: implement initState
    super.initState();
    _initializeItemWidget();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBarWhite(_title),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: _isLoading,
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              BordersTextField(
                label: 'Name:',
                controller: _nameController,
              ),
              isProduct
                  ? BordersTextField(
                      label: "Quantity:",
                      keyboardType: TextInputType.number,
                      controller: _productQuanityController,
                    )
                  : _buildServiceUnit(context),
              BordersTextField(
                label: 'Unit Cost:',
                keyboardType: TextInputType.number,
                controller: _costController,
              ),
              CurrencyWidget(
                key: key,
                context: context,
                currency: _currency ?? getLocalCurrency(context),
                onTap: () {
                  _currency = key.currentState.currency;
                },
              ),
              ListTile(
                leading: Text("Description"),
                trailing: Icon(
                  Icons.navigate_next,
                  color: kGREEN_COLOR,
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return BigTextField(
                      title: "Description",
                      text: _description,
                      onPressed: (String value) {
                        _description = value;
                      },
                    );
                  }));
                },
              ),
              SizedBox(height: 2 * kVERTICAL_SPACING),
              widget.onPressed != null
                  ? _buildDiscountWidget("Discount")
                  : Container(),
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

  Widget _buildServiceUnit(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5, bottom: 5, right: 10, left: 10),
      decoration: BoxDecoration(
          border: Border.all(
        color: kITEMS_BORDER_COLOR,
      )),
      child: ListTile(
          title: Text(_serviceUnit),
          leading: Text(
            'Unit:                 ',
            style: TextStyle(fontSize: 16, color: kITEMS_TEXT_COLOR),
          ),
          onTap: () async {
            FocusScope.of(context).requestFocus(new FocusNode());
            final data = await showModalBottomSheet<String>(
              context: context,
              builder: (context) {
                return TextPicker(
                  initialValue: _serviceUnit ?? "",
                  values: kITEMS_SERVICE_UNIT,
                  title: kSERVICE_UNIT_TEXT_PICKER_TITLE,
                  description: kSERVICE_UNIT_TEXT_PICKER_DESCRIPTION,
                );
              },
            );
            setState(() {
              _serviceUnit = data ?? _serviceUnit;
            });
          }),
    );
  }

  String _initializeItemWidget() {
    switch (widget.itemOperation) {
      case ItemOperation.addProduct:
        {
          isProduct = true;
          itemFunction = _addProduct;

          _title = "Add Product";
        }
        break;
      case ItemOperation.editProduct:
        {
          isProduct = true;
          itemFunction = _editProduct;
          _title = "Edit Product";

          _nameController.text = widget.item.name;
          _productQuanityController.text = widget.item.unit;
          _costController.text = widget.item.cost;
          _currency = widget.item.currency;
        }
        break;
      case ItemOperation.addService:
        {
          isProduct = false;
          itemFunction = _addService;
          _title = "Add Service";
        }
        break;
      case ItemOperation.editService:
        {
          isProduct = false;
          itemFunction = _editService;
          _title = "Edit Service";
          _nameController.text = widget.item.name;
          _serviceUnit = widget.item.unit;
          _costController.text = widget.item.cost;
          _currency = widget.item.currency;
        }
        break;
    }
    return _title;
  }

  Widget _buildDiscountWidget(String discount) {
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 10, left: 10, right: 10),
          padding: EdgeInsets.all(12),
          decoration:
              BoxDecoration(border: Border.all(color: kORANGE_COLOR, width: 2)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Text(
                "Discount Type:",
                style: kBLACK_16,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: RadioListTile<DiscountType>(
                      title: const Text('Flat'),
                      activeColor: kORANGE_COLOR,
                      value: DiscountType.flat,
                      groupValue: _discountType,
                      onChanged: (DiscountType value) {
                        setState(() {
                          _discountType = value;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<DiscountType>(
                      activeColor: kORANGE_COLOR,
                      title: const Text('Percentage'),
                      value: DiscountType.percentage,
                      groupValue: _discountType,
                      onChanged: (DiscountType value) {
                        setState(() {
                          _discountType = value;
                        });
                      },
                    ),
                  )
                ],
              ),
              BordersTextField(
                label: "Amount:",
                keyboardType: TextInputType.number,
                controller: _discountController,
                onChanged: (String v) {
                  setState(() {});
                },
              )
            ],
          ),
//          decoration: Decoration(
//              border: OutlineInputBorder(
//                  borderRadius: BorderRadius.all(Radius.zero))),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 50),
          padding: EdgeInsets.all(5),
          child: Text(
            discount,
            style: kWHITE_16_BOLD,
          ),
          color: kORANGE_COLOR,
        ),
      ],
    );
  }

  Future<bool> _validation() async {
    String description = "";
    if (_nameController.text == "") {
      description = "Please ensure to enter the name";
    } else if (_productQuanityController.text == "" && _serviceUnit == "") {
      description = "Please ensure to enter the quantity";
    } else if (_costController.text == "") {
      description = "Please ensure to enter the cost";
    } else if (_currency == "") {
      description = "Please ensure to enter the currency";
    } else {
      return true;
    }

    setState(() {
      _isLoading = false;
    });
    await Alert.showMyDialogOk(
        context: context, title: ERROR_TITLE, description: description);
    return false;
  }

  Future<void> _save() async {
    bool isValiated = await _validation();
    if (isValiated) {
      if (widget.onPressed != null) {
        Item item = widget.item;
        item.cost = _costController.text;
        item.currency = _currency;
        item.name = _nameController.text;
        item.unit = widget.item.type == ItemType.service
            ? "1"
            : _productQuanityController.text;
        item.discount = _getDiscountAmount();
        item.description = _description;
        item.timestamp = Timestamp.now();
        widget.onPressed(item);
        Navigator.pop(context);
      } else {
        _currency = _currency ?? getLocalCurrency(context);
        setState(() {
          _isLoading = true;
        });
        await itemFunction();
        setState(() {
          _isLoading = false;
        });
        Navigator.pop(context);
      }
    }
  }

  void _addProduct() async {
    Item item = Item(
        cost: _costController.text,
        currency: _currency,
        name: _nameController.text,
        type: ItemType.product,
        unit: _productQuanityController.text,
        timestamp: Timestamp.now());
    await CustomFireStore.addItem(item);
  }

  void _editProduct() async {
    Item item = widget.item;
    item.cost = _costController.text;
    item.currency = _currency;
    item.name = _nameController.text;
    item.type = ItemType.product;
    item.unit = _productQuanityController.text;
    item.timestamp = Timestamp.now();
    await CustomFireStore.editItem(item);
  }

  void _addService() async {
    Item item = Item(
        cost: _costController.text,
        currency: _currency,
        name: _nameController.text,
        type: ItemType.service,
        unit: _serviceUnit,
        timestamp: Timestamp.now());
    await CustomFireStore.addItem(item);
  }

  void _editService() async {
    Item item = widget.item;
    item.cost = _costController.text;
    item.currency = _currency;
    item.name = _nameController.text;
    item.type = ItemType.service;
    item.unit = _serviceUnit;
    item.timestamp = Timestamp.now();
    await CustomFireStore.editItem(item);
  }

  String _getDiscountAmount() {
    if (_discountController.text == "") {
      return "0";
    }
    double iniDiscount = double.parse(_discountController.text);
    if (_discountType == DiscountType.flat) {
      return iniDiscount.toStringAsFixed(2);
    } else {
      double cost = double.parse(_costController.text);
      double unites = widget.item.type == ItemType.service
          ? 1
          : double.parse(_productQuanityController.text);
      double discount = cost * unites * iniDiscount / 100;
      return discount.toStringAsFixed(2);
    }
    return "";
  }
}
