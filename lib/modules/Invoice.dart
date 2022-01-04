import 'package:invoicing/services/custom_firestore.dart';
import 'package:invoicing/utils/enums.dart';

import 'item.dart';

class Invoice {
  String documentID;
  String userID;
  String username;
//  String companyName;
//  String companyAddress;
  String clientName;
  String clientID;
  String clientCountrey;
  String invoiceNo;
  String invoiceDate;
  List<Item> invoiceItems;
  DiscountType discountType;
  String discountAmount;
  String additionalChargeAmount1;
  String additionalChargeDescription1;
  String additionalChargeAmount2;
  String additionalChargeDescription2;
  bool moreAdditionCharge;
  String taxAmount1;
  String taxDescription1;
  String taxAmount2;
  String taxDescription2;
  bool moreTax;
  String termsAndConditions;
  String notes;
  String dueDate;
  String lateFee;
  String pONo;
  String title;
  String scheduledOn;
  String currency;

  Invoice(
      {this.userID,
      this.documentID,
      this.clientName,
      this.clientID,
      this.username,
//      this.companyName,
//      this.companyAddress,
      this.clientCountrey,
      this.invoiceNo,
      this.invoiceDate,
      this.invoiceItems,
      this.discountType,
      this.discountAmount,
      this.additionalChargeAmount1,
      this.additionalChargeDescription1,
      this.additionalChargeAmount2,
      this.additionalChargeDescription2,
      this.moreAdditionCharge,
      this.taxAmount1,
      this.taxDescription1,
      this.taxAmount2,
      this.taxDescription2,
      this.moreTax,
      this.termsAndConditions,
      this.notes,
      this.dueDate,
      this.lateFee,
      this.pONo,
      this.title,
      this.scheduledOn});

  Map toMap() {
    Map data = Map<String, dynamic>();
    data[USER_ID] = userID;
    data['username'] = username;
//    data['company_name'] = companyName;
//    data['company_address'] = companyAddress;
    data['client_name'] = clientName;
    data['client_id'] = clientID;
    data['client_country'] = clientCountrey;
    data['invoice_no'] = invoiceNo;
    data['invoice_data'] = invoiceDate;
    data['invoice_items'] = _convertInvoiceITemsToMap(invoiceItems);
    data['discount_type'] = discountType.toString();
    data['discount_amount'] = discountAmount;
    data['additional_charge_amount1'] = additionalChargeAmount1;
    data['additional_charge_description1'] = additionalChargeDescription1;
    data['additional_charge_amount2'] = additionalChargeAmount2;
    data['additional_charge_description2'] = additionalChargeDescription2;
    data['more_addition_charge'] = moreAdditionCharge;
    data['tax_amount1'] = taxAmount1;
    data['tax_description1'] = taxDescription1;
    data['tax_amount2'] = taxAmount2;
    data['tax_description2'] = taxDescription2;
    data['more_tax'] = moreTax;
    data['termsAnd_conditions'] = termsAndConditions;
    data['notes'] = notes;
    data['due_date'] = dueDate;
    data['late_fee'] = lateFee;
    data['pO_no'] = pONo;
    data['title'] = title;
    data['scheduled_on'] = scheduledOn;
    data['currency'] = currency;
    return data;
  }

  Invoice.fromMap(Map data) {
    userID = data[USER_ID];
    documentID = data[DOCUMENT_ID] ?? "";
    username = data['username'];
//    companyName = data['company_name'];
//    companyAddress = data['company_address'];
    clientName = data['client_name'];
    clientID = data['client_id'];
    clientCountrey = data['client_country'];
    invoiceNo = data['invoice_no'];
    invoiceDate = data['invoice_data'];
    invoiceItems = _getInvoiceItem(data['invoice_items']);
    discountType = _getDiscountType(data['discount_type']);
    discountAmount = data['discount_amount'];
    additionalChargeAmount1 = data['additional_charge_amount1'];
    additionalChargeDescription1 = data['additional_charge_description1'];
    additionalChargeAmount2 = data['additional_charge_amount2'];
    additionalChargeDescription2 = data['additional_charge_description2'];
    moreAdditionCharge = data['more_addition_charge'];
    taxAmount1 = data['tax_amount1'];
    taxDescription1 = data['tax_description1'];
    taxAmount2 = data['tax_amount2'];
    taxDescription2 = data['tax_description2'];
    moreTax = data['more_tax'];
    termsAndConditions = data['termsAnd_conditions'];
    notes = data['notes'];
    dueDate = data['due_date'];
    lateFee = data['late_fee'];
    pONo = data['pO_no'];
    title = data['title'];
    scheduledOn = data['scheduled_on'];
    currency = data['currency'];
  }
  DiscountType _getDiscountType(String type) {
    if (type == "DiscountType.flat") {
      return DiscountType.flat;
    } else {
      return DiscountType.percentage;
    }
  }

  List<Item> _getInvoiceItem(dynamic itemsMap) {
    List<Item> items = List<Item>();
    itemsMap.forEach((dynamic data) {
      Item item = Item();
      item.type = _convertType(data["type"]);
      item.name = data["name"];
      item.unit = data["unit"];
      item.cost = data["cost"];
      item.discount = data["discount"];
      item.description = data["description"];
      item.currency = data["currency"];
      items.add(item);
    });
    return items;
  }

  List<Map> _convertInvoiceITemsToMap(List<Item> items) {
    List<Map> itemsMap = List<Map>();
    items.forEach((Item item) {
      Map data = Map<String, dynamic>();
      data["type"] = item.type.toString();
      data["name"] = item.name;
      data["unit"] = item.unit;
      data["cost"] = item.cost;
      data["discount"] = item.discount;
      data["description"] = item.description;
      data["currency"] = item.currency;
      itemsMap.add(data);
    });
    return itemsMap;
  }

  ItemType _convertType(String type) {
    if (type == "ItemType.product") {
      return ItemType.product;
    } else {
      return ItemType.service;
    }
  }

  String getAdditionalCharge() {
    double additionalCharge = 0;
    if (additionalChargeAmount1 != "") {
      try {
        additionalCharge += double.parse(additionalChargeAmount1);
      } catch (e) {}
    }
    if (moreAdditionCharge && additionalChargeAmount2 != "") {
      try {
        additionalCharge += double.parse(additionalChargeAmount2);
      } catch (e) {}
    }
    return additionalCharge.toStringAsFixed(2);
  }

  String getTotalDiscount() {
    double discount = 0;
    if (discountAmount != "") {
      discount = discountType == DiscountType.flat
          ? double.parse(discountAmount)
          : double.parse(getSubTotal()) * double.parse(discountAmount) / 100;
    }
    return discount.toStringAsFixed(2);
  }

  String getSubTotal() {
    double subtotal = 0;
    invoiceItems.forEach((Item item) {
      subtotal += double.parse(item.unit) * double.parse(item.cost) -
          double.parse(item.discount);
    });
    return subtotal.toStringAsFixed(2);
  }

  String getDiscount() {
    double discount = 0;
    invoiceItems.forEach((Item item) {
      discount += double.parse(item.discount);
    });
    return discount.toStringAsFixed(2);
  }

  String getTotalAfterDiscount() {
    double total = double.parse(getSubTotal());
    if (discountAmount != "") {
      double discount = discountType == DiscountType.flat
          ? double.parse(discountAmount)
          : double.parse(getSubTotal()) * double.parse(discountAmount) / 100;
      total -= discount;
    }

    return total.toStringAsFixed(2);
  }

  String getNetBalanceAfterAdditionalCharge() {
    double total = double.parse(getTotalAfterDiscount());
    double additionalCharge = 0;
    if (additionalChargeAmount1 != "") {
      try {
        additionalCharge += double.parse(additionalChargeAmount1);
      } catch (e) {}
    }
    if (moreAdditionCharge && additionalChargeAmount2 != "") {
      try {
        additionalCharge += double.parse(additionalChargeAmount2);
      } catch (e) {}
    }
    total += additionalCharge;
    return total.toStringAsFixed(2);
  }

  String getGrossTotalAfterTaxs() {
    double total = double.parse(getNetBalanceAfterAdditionalCharge());
    double taxs = 0;
    if (taxAmount1 != "") {
      try {
        taxs += total * double.parse(taxAmount1) / 100;
      } catch (e) {}
    }
    if (moreTax && taxAmount2 != "") {
      try {
        taxs += total * double.parse(taxAmount2) / 100;
      } catch (e) {}
    }
    total += taxs;
    return total.toStringAsFixed(2);
  }
}
