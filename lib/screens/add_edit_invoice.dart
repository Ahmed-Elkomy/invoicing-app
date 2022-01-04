import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:invoicing/components/big_text_field.dart';
import 'package:invoicing/components/borderless_text_field.dart';
import 'package:invoicing/components/borders_text_field.dart';
import 'package:invoicing/components/scafold_items.dart';
import 'package:invoicing/modules/Invoice.dart';
import 'package:invoicing/modules/client.dart';
import 'package:invoicing/modules/item.dart';
import 'package:invoicing/modules/user.dart';
import 'package:invoicing/screens/items.dart';
import 'package:invoicing/services/custom_firestore.dart';
import 'package:invoicing/utils/constant.dart';
import 'package:invoicing/utils/enums.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'invoices.dart';

class AddEditInvoice extends StatefulWidget {
  static final id = "AddEditInvoice";
  final Client client;
  final Invoice invoice;

  AddEditInvoice({this.client, this.invoice});

  @override
  _AddEditInvoiceState createState() => _AddEditInvoiceState();
}

class _AddEditInvoiceState extends State<AddEditInvoice> {
  TextEditingController _clientNameController = TextEditingController();
  TextEditingController _invoiceNuController = TextEditingController();
  TextEditingController _invoiceDateController = TextEditingController();
  TextEditingController _dueDateController = TextEditingController();
  TextEditingController _lateFeeController = TextEditingController();
  TextEditingController _poNuController = TextEditingController();
  TextEditingController _invoiceTitleController = TextEditingController();
  TextEditingController _scheduledOnController = TextEditingController();
  TextEditingController _discountController = TextEditingController();
  TextEditingController _additionalChargeAmount1Controller =
      TextEditingController();
  TextEditingController _additionalChargeDescription1Controller =
      TextEditingController();
  TextEditingController _additionalChargeAmount2Controller =
      TextEditingController();
  TextEditingController _additionalChargeDescription2Controller =
      TextEditingController();
  TextEditingController _taxAmount1Controller = TextEditingController();
  TextEditingController _taxDescription1Controller = TextEditingController();
  TextEditingController _taxAmount2Controller = TextEditingController();
  TextEditingController _taxDescription2Controller = TextEditingController();

  bool _isLoading = false;
  String currency;
  Invoice invoice;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initializeWidgets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBarWhite("Create Invoice"),
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        child: SafeArea(
          child: Container(
//            padding: EdgeInsets.all(kVERTICAL_SPACING),
            child: ListView(
              children: <Widget>[
                BorderlessTextField(
                  label: "Client Name:",
                  controller: _clientNameController,
                  onChanged: (String value) {
                    setState(() {
                      invoice.clientName = value;
                    });
                  },
                ),
                BorderlessTextField(
                  label: "Invoice #",
                  controller: _invoiceNuController,
                  onChanged: (String value) {
                    setState(() {
                      invoice.invoiceNo = value;
                    });
                  },
                ),
                _buildBorderlessTextFieldCalender(
                  label: "Invoice Date:",
                  controller: _invoiceDateController,
                  onChanged: (String value) {
                    setState(() {
                      invoice.invoiceDate = value;
                    });
                  },
                ),
                Stack(
                  alignment: Alignment.centerRight,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Icon(
                        Icons.add_circle,
                        color: kGREEN_COLOR,
                      ),
                    ),
                    ListTile(
                      leading: Text("Add Item",
                          style: TextStyle(
                              fontSize: 16, color: kITEMS_TEXT_COLOR)),
                      onTap: _addItem,
                    ),
                  ],
                ),
                _buildInvoiceSecondPart(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector _buildBorderlessTextFieldCalender(
      {String label,
      TextEditingController controller,
      Function onChanged,
      String minData}) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
        String MIN_DATETIME = minData ?? '2000-01-01';
        const String MAX_DATETIME = '2099-01-01';
        DateFormat formatter = DateFormat('yyyy-MM-dd');
        String INIT_DATETIME = formatter.format(DateTime.now());
        String _format = 'dd-MMMM-yyyy';
        DateTimePickerLocale _locale = DateTimePickerLocale.en_us;
        DateTime _dateTime;
        _dateTime = DateTime.parse(INIT_DATETIME);
        DatePicker.showDatePicker(
          context,
//              onMonthChangeStartWithFirstDate: true,
          pickerTheme: DateTimePickerTheme(
            showTitle: true,
            cancel: Text('Cancel',
                style: TextStyle(color: Colors.red, fontSize: 18)),
            confirm: Text('Select',
                style: TextStyle(color: Color(0xff32BBD0), fontSize: 18)),
          ),
          minDateTime: DateTime.parse(MIN_DATETIME),
          maxDateTime: DateTime.parse(MAX_DATETIME),
          initialDateTime: DateTime.now(),
          dateFormat: _format,
          locale: _locale,
//              onClose: () => print("----- onClose -----"),
//              onCancel: () => print('onCancel'),
          onConfirm: (dateTime, List<int> index) {
            controller.text = invoiceDateFormatter.format(dateTime);
            onChanged(controller.text);
          },
        );
//            print("clicked");
      },
      child: AbsorbPointer(
        absorbing: true,
        child: BorderlessTextField(
          label: label,
          controller: controller,
          suffixIcon: IconButton(
            icon: Icon(Icons.calendar_today),
          ),
        ),
      ),
    );
  }

  Future<void> _initializeWidgets() async {
    DateTime now = new DateTime.now();
    if (widget.invoice != null) {
      invoice = widget.invoice;
      _clientNameController.text = invoice.clientName ?? "";
      _invoiceNuController.text = invoice.invoiceNo ?? "";
      _invoiceDateController.text = invoice.invoiceDate ?? "";
      _dueDateController.text = invoice.dueDate ?? "";
      _lateFeeController.text = invoice.lateFee ?? "";
      _poNuController.text = invoice.pONo ?? "";
      _invoiceTitleController.text = invoice.title ?? "";
      _scheduledOnController.text = invoice.scheduledOn ?? "";
      _discountController.text = invoice.discountAmount ?? "";
      _additionalChargeAmount1Controller.text =
          invoice.additionalChargeAmount1 ?? "";
      _additionalChargeDescription1Controller.text =
          invoice.additionalChargeDescription1 ?? "";
      _additionalChargeAmount2Controller.text =
          invoice.additionalChargeAmount2 ?? "";
      _additionalChargeDescription2Controller.text =
          invoice.additionalChargeDescription2 ?? "";
      _taxAmount1Controller.text = invoice.taxAmount1 ?? "";
      _taxDescription1Controller.text = invoice.taxDescription1 ?? "";
      _taxAmount2Controller.text = invoice.taxAmount2 ?? "";
      _taxDescription2Controller.text = invoice.taxDescription2 ?? "";
    } else {
      invoice = Invoice();
      invoice.clientName = widget.client.businessName;
      invoice.invoiceNo = await CustomFireStore.getLastInvoiceID();
      invoice.invoiceDate = invoiceDateFormatter.format(now);
      invoice.moreTax = false;
      invoice.moreAdditionCharge = false;
      invoice.additionalChargeAmount1 = "";
      invoice.taxAmount1 = "";
      invoice.invoiceItems = List<Item>();
      invoice.discountType = DiscountType.flat;
      invoice.discountAmount = "";
    }
    _clientNameController.text = invoice.clientName;
    _invoiceNuController.text = invoice.invoiceNo;
    _invoiceDateController.text = invoice.invoiceDate;

    String currency;
  }

  Widget _buildInvoiceSecondPart() {
    return invoice.invoiceItems == null
        ? Container()
        : invoice.invoiceItems.length == 0
            ? Container()
            : Column(
                children: <Widget>[
                  _buidItemsList(),
                  ListTile(
                    leading: Text("Sub Total :"),
                    trailing: Text(" ($currency) ${invoice.getSubTotal()}"),
                  ),
                  ListTile(
                    leading: Text("Total Discount (Incl.) :"),
                    trailing: Text(" ($currency) ${invoice.getDiscount()}"),
                  ),
                  Divider(
                    thickness: 15,
                  ),
                  _buildDiscountWidget("DISCOUNT ON TOTAL"),
                  ListTile(
                    leading: Text("Total after discount :"),
                    trailing:
                        Text(" ($currency) ${invoice.getTotalAfterDiscount()}"),
                  ),
                  Divider(
                    thickness: 15,
                  ),
                  _buildAdditionalChargeList(),
                  ListTile(
                    leading: Text("Net Balance :"),
                    trailing: Text(
                        " ($currency) ${invoice.getNetBalanceAfterAdditionalCharge()}"),
                  ),
                  Divider(
                    thickness: 15,
                  ),
                  _buildAdditionalTaxList(),
                  ListTile(
                    leading: Text("Gross Total :"),
                    trailing: Text(
                        " ($currency) ${invoice.getGrossTotalAfterTaxs()}"),
                  ),
                  Divider(
                    thickness: 15,
                  ),
                  ListTile(
                    leading: Text("Terms & Conditions"),
                    trailing: Icon(
                      Icons.navigate_next,
                      color: kGREEN_COLOR,
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return BigTextField(
                          title: "Terms & Conditions",
                          text: invoice.termsAndConditions,
                          onPressed: (String value) {
                            invoice.termsAndConditions = value;
                            print(invoice.termsAndConditions);
                          },
                        );
                      }));
                    },
                  ),
                  Divider(
                    thickness: 15,
                  ),
                  ListTile(
                    leading: Text("Invoice Notes"),
                    trailing: Icon(
                      Icons.navigate_next,
                      color: kGREEN_COLOR,
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return BigTextField(
                          title: "Notes",
                          text: invoice.notes,
                          onPressed: (String value) {
                            invoice.notes = value;
                          },
                        );
                      }));
                    },
                  ),
                  Divider(
                    thickness: 15,
                  ),
                  _buildBorderlessTextFieldCalender(
                      label: "Due Date:",
                      controller: _dueDateController,
                      onChanged: (String value) {
                        setState(() {
                          invoice.dueDate = value;
                        });
                      },
                      minData: DateFormat('yyyy-MM-dd').format(
                          invoiceDateFormatter
                              .parse(_invoiceDateController.text))),
                  BorderlessTextField(
                      label: "Late Fee:",
                      controller: _lateFeeController,
                      onChanged: (String value) {
                        setState(() {
                          invoice.lateFee = value;
                        });
                      }),
                  BorderlessTextField(
                      label: "PO #:",
                      controller: _poNuController,
                      keyboardType: TextInputType.number,
                      onChanged: (String value) {
                        setState(() {
                          invoice.pONo = value;
                        });
                      }),
                  BorderlessTextField(
                      label: "Invoice Title:",
                      controller: _invoiceTitleController,
                      onChanged: (String value) {
                        setState(() {
                          invoice.title = value;
                        });
                      }),
//                  _buildBorderlessTextFieldCalender(
//                      label: "Scheduled On:",
//                      controller: _scheduledOnController,
//                      onChanged: (String value) {
//                        setState(() {
//                          invoice.scheduledOn = value;
//                        });
//                      }),
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
              );
  }

  Widget _buidItemsList() {
    List<Widget> list = List<Widget>();
    for (int i = 0; i < invoice.invoiceItems.length; i++) {
      Item item = invoice.invoiceItems[i];
      list.add(_buildItemWidget(item, i));
      currency = item.currency;
      invoice.currency = currency;
    }
    return Column(
      children: list,
    );
  }

  Widget _buildItemWidget(Item item, int index) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.remove_circle,
                color: Colors.red,
              ),
              onPressed: () {
                setState(() {
                  invoice.invoiceItems.removeAt(index);
                });
              },
            ),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      item.name,
                      style: kBLACK_16_W500,
                    ),
                    Text(
                        "${item.unit} @ ${item.cost} = ${(double.parse(item.unit) * double.parse(item.cost)).toStringAsFixed(2)} "),
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    "${(double.parse(item.unit) * double.parse(item.cost) - double.parse(item.discount)).toStringAsFixed(2)}",
                    style: kBLACK_16_W500,
                  ),
                  Text(
                      item.discount == "0" ? "" : "Discount: ${item.discount}"),
                ],
              ),
            )
          ],
        ),
        Divider(
          thickness: 2,
        )
      ],
    );
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
                      groupValue: invoice.discountType,
                      onChanged: (DiscountType value) {
                        setState(() {
                          invoice.discountType = value;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<DiscountType>(
                      activeColor: kORANGE_COLOR,
                      title: const Text('Percentage'),
                      value: DiscountType.percentage,
                      groupValue: invoice.discountType,
                      onChanged: (DiscountType value) {
                        setState(() {
                          invoice.discountType = value;
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
                  invoice.discountAmount = v;
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

  Widget _buildAdditionalChargeList() {
    List<Widget> list = List<Widget>();
    if (!invoice.moreAdditionCharge) {
      return _buildAdditionalChargeAndTaxWidget(
          amountController: _additionalChargeAmount1Controller,
          amountLabel: "Addition Charge Amount:",
          descriptionController: _additionalChargeDescription1Controller,
          descriptionLable: "Description",
          type: ChargeType.additionalCharge,
          last: false);
    } else {
      return Column(
        children: <Widget>[
          _buildAdditionalChargeAndTaxWidget(
              amountController: _additionalChargeAmount1Controller,
              amountLabel: "Addition Charge Amount:",
              descriptionController: _additionalChargeDescription1Controller,
              descriptionLable: "Description",
              type: ChargeType.additionalCharge,
              last: false),
          _buildAdditionalChargeAndTaxWidget(
              amountController: _additionalChargeAmount2Controller,
              amountLabel: "Addition Charge Amount:",
              descriptionController: _additionalChargeDescription2Controller,
              descriptionLable: "Description",
              type: ChargeType.additionalCharge,
              last: true)
        ],
      );
    }
  }

  Widget _buildAdditionalTaxList() {
    List<Widget> list = List<Widget>();
    if (!invoice.moreTax) {
      return _buildAdditionalChargeAndTaxWidget(
          amountController: _taxAmount1Controller,
          amountLabel: "Tax Percentage:",
          descriptionController: _taxDescription1Controller,
          descriptionLable: "Description",
          type: ChargeType.tax,
          last: false);
    } else {
      return Column(
        children: <Widget>[
          _buildAdditionalChargeAndTaxWidget(
              amountController: _taxAmount1Controller,
              amountLabel: "Tax Percentage:",
              descriptionController: _taxDescription1Controller,
              descriptionLable: "Description",
              type: ChargeType.tax,
              last: false),
          _buildAdditionalChargeAndTaxWidget(
              amountController: _taxAmount2Controller,
              amountLabel: "Tax Percentage:",
              descriptionController: _taxDescription2Controller,
              descriptionLable: "Description",
              type: ChargeType.tax,
              last: true)
        ],
      );
    }
  }

  Widget _buildAdditionalChargeAndTaxWidget(
      {bool last,
      ChargeType type,
      String amountLabel,
      String descriptionLable,
      TextEditingController amountController,
      TextEditingController descriptionController}) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.remove_circle,
                color: Colors.red,
              ),
              onPressed: () {
                _deleteCharge(type, last);
              },
            ),
            Expanded(
              child: TextField(
                keyboardType: TextInputType.number,
                controller: amountController,
                onChanged: (String value) {
                  setState(() {
                    if (type == ChargeType.additionalCharge) {
                      if (last) {
                        invoice.additionalChargeAmount2 = value;
                      } else {
                        invoice.additionalChargeAmount1 = value;
                      }
                    } else {
                      if (last) {
                        invoice.taxAmount2 = value;
                      } else {
                        invoice.taxAmount1 = value;
                      }
                    }
                  });
                },
                decoration: InputDecoration(labelText: amountLabel),
              ),
            )
          ],
        ),
        Row(
          children: <Widget>[
            !last
                ? IconButton(
                    icon: Icon(
                      Icons.add_circle,
                      color: kGREEN_COLOR,
                    ),
                    onPressed: () {
                      setState(() {
                        type == ChargeType.additionalCharge
                            ? invoice.moreAdditionCharge = true
                            : invoice.moreTax = true;
                      });
                    },
                  )
                : IconButton(
                    icon: Icon(
                      Icons.add_circle,
                      color: Colors.white,
                    ),
                  ),
            Expanded(
              child: TextField(
                controller: descriptionController,
                onChanged: (String value) {
                  setState(() {
                    if (type == ChargeType.additionalCharge) {
                      if (last) {
                        invoice.additionalChargeDescription2 = value;
                      } else {
                        invoice.additionalChargeDescription1 = value;
                      }
                    } else {
                      if (last) {
                        invoice.taxDescription2 = value;
                      } else {
                        invoice.taxDescription1 = value;
                      }
                    }
                  });
                },
                decoration: InputDecoration(labelText: descriptionLable),
              ),
            )
          ],
        ),
        Divider(
          thickness: 1,
        )
      ],
    );
  }

  Future<void> _addItem() async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Items(
        onPressed: (Item item) {
          invoice.invoiceItems.add(item);
          Navigator.pop(context);
        },
      );
    }));
    setState(() {});
  }

  void _deleteCharge(ChargeType type, bool last) {
    if (type == ChargeType.additionalCharge) {
      invoice.moreAdditionCharge = false;
      if (last) {
        _additionalChargeAmount2Controller.text = "";
        _additionalChargeDescription2Controller.text = "";
      } else {
        _additionalChargeAmount1Controller.text =
            _additionalChargeAmount2Controller.text;
        _additionalChargeDescription1Controller.text =
            _additionalChargeDescription2Controller.text;
        _additionalChargeAmount2Controller.text = "";
        _additionalChargeDescription2Controller.text = "";
      }
    } else {
      invoice.moreTax = false;
      if (last) {
        _taxAmount2Controller.text = "";
        _taxDescription2Controller.text = "";
      } else {
        _taxAmount1Controller.text = _taxAmount2Controller.text;
        _taxDescription1Controller.text = _taxDescription2Controller.text;
        _taxAmount2Controller.text = "";
        _taxDescription2Controller.text = "";
      }
    }
    setState(() {});
  }

  Future<void> _save() async {
    setState(() {
      _isLoading = true;
    });
    if (_isEditInvoice()) {
      await _editInvoice();
    } else {
      await _addInvoice();
    }
    setState(() {
      _isLoading = false;
    });

    if (widget.invoice == null) {
      Navigator.pushReplacementNamed(context, Invoices.id);
    } else {
      Navigator.pop(context, invoice);
    }
  }

  bool _isEditInvoice() {
    if (widget.invoice != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> _editInvoice() async {
    await CustomFireStore.editInvoice(invoice);
  }

  Future<void> _addInvoice() async {
    User user = await CustomFireStore.getUserData();
    invoice.username = user.username;
//    invoice.companyName = user.companyName;
//    invoice.companyAddress = user.companyAddress;
    invoice.clientCountrey = widget.client.billingAddress;
    invoice.clientID = widget.client.documentID;
    await CustomFireStore.addInvoice(invoice);

  }
}
