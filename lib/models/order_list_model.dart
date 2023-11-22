import 'dart:convert';

import 'package:shopping_store/models/cart_item_model.dart';
import 'package:shopping_store/models/countries_list.model.dart';
import 'package:shopping_store/models/international_country_model.dart';

List<OrderListModel> orderListModelFromJson(String str) => List<OrderListModel>.from(json.decode(str).map((x) => OrderListModel.fromJson(x)));

String orderListModelToJson(List<OrderListModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OrderListModel {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int userId;
  final List<CartItemModel> cartItems;
  final int itemsTotal;
  final int taxId;
  final int taxPercent;
  final double taxValue;
  final int? couponId;
  final double discountValue;
  final int discountPercent;
  final int shipmentPrice;
  final double totalCartValue;
  final int totalCartWeight;
  final int isInternational;
  final int countryId;
  final int shippingAddressId;
  final int billingAddressId;
  final int invoiceId;
  final String? invoiceStatus;
  final String? invoiceReference;
  final String? customerReference;
  final DateTime? createdDate;
  final String? expiryDate;
  final String? expiryTime;
  final double? invoiceValue;
  final String? comments;
  final String? customerName;
  final String? customerMobile;
  final String? customerEmail;
  final String? userDefinedField;
  final String? invoiceDisplayValue;
  final String? dueDeposit;
  final String? depositStatus;
  final List<dynamic>? invoiceItems;
  final List<dynamic>? suppliers;
  final DateTime? transactionDate;
  final String? paymentGateway;
  final String? referenceId;
  final String? trackId;
  final String? transactionId;
  final String? paymentId;
  final String? authorizationId;
  final String? transactionStatus;
  final String? transactionValue;
  final String? customerServiceCharge;
  final String? totalServiceCharge;
  final String? dueValue;
  final String? paidCurrency;
  final String? paidCurrencyValue;
  final String? ipAddress;
  final String? country;
  final String? currency;
  final String? error;
  final String? cardNumber;
  final String? errorCode;
  final String orderStatus;
  final CountriesListModel? countryDetails;
  final InternationalCountryModel? internationalCountryDetails;

  OrderListModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    required this.cartItems,
    required this.itemsTotal,
    required this.taxId,
    required this.taxPercent,
    required this.taxValue,
    this.couponId,
    required this.discountValue,
    required this.discountPercent,
    required this.shipmentPrice,
    required this.totalCartValue,
    required this.totalCartWeight,
    required this.isInternational,
    required this.countryId,
    required this.shippingAddressId,
    required this.billingAddressId,
    required this.invoiceId,
    this.invoiceStatus,
    this.invoiceReference,
    this.customerReference,
    this.createdDate,
    this.expiryDate,
    this.expiryTime,
    this.invoiceValue,
    this.comments,
    this.customerName,
    this.customerMobile,
    this.customerEmail,
    this.userDefinedField,
    this.invoiceDisplayValue,
    this.dueDeposit,
    this.depositStatus,
    this.invoiceItems,
    this.suppliers,
    this.transactionDate,
    this.paymentGateway,
    this.referenceId,
    this.trackId,
    this.transactionId,
    this.paymentId,
    this.authorizationId,
    this.transactionStatus,
    this.transactionValue,
    this.customerServiceCharge,
    this.totalServiceCharge,
    this.dueValue,
    this.paidCurrency,
    this.paidCurrencyValue,
    this.ipAddress,
    this.country,
    this.currency,
    this.error,
    this.cardNumber,
    this.errorCode,
    required this.orderStatus,
    this.countryDetails,
    this.internationalCountryDetails,
  });

  factory OrderListModel.fromJson(Map<String, dynamic> json) => OrderListModel(
        id: json["id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        userId: json["userId"],
        cartItems: List<CartItemModel>.from(json["cartItems"].map((x) => CartItemModel.fromJson(x))),
        itemsTotal: json["itemsTotal"],
        taxId: json["taxId"],
        taxPercent: json["taxPercent"],
        taxValue: json["taxValue"]?.toDouble(),
        couponId: json["couponId"],
        discountValue: json["discountValue"]?.toDouble(),
        discountPercent: json["discountPercent"],
        shipmentPrice: json["shipmentPrice"],
        totalCartValue: json["totalCartValue"]?.toDouble(),
        totalCartWeight: json["totalCartWeight"],
        isInternational: json["isInternational"],
        countryId: json["countryId"],
        shippingAddressId: json["shippingAddressId"],
        billingAddressId: json["billingAddressId"],
        invoiceId: json["invoiceId"],
        invoiceStatus: json["invoiceStatus"] ?? "",
        invoiceReference: json["invoiceReference"] ?? "",
        customerReference: json["customerReference"],
        createdDate: json["createdDate"] == null ? DateTime.now() : DateTime.parse(json["createdDate"]),
        expiryDate: json["expiryDate"],
        expiryTime: json["expiryTime"],
        invoiceValue: json["invoiceValue"]?.toDouble(),
        comments: json["comments"],
        customerName: json["customerName"],
        customerMobile: json["customerMobile"],
        customerEmail: json["customerEmail"],
        userDefinedField: json["userDefinedField"],
        invoiceDisplayValue: json["invoiceDisplayValue"],
        dueDeposit: json["dueDeposit"],
        depositStatus: json["depositStatus"],
        invoiceItems: json["invoiceItems"] == null ? [] : List<dynamic>.from(json["invoiceItems"].map((x) => x)),
        suppliers: json["suppliers"] == null ? [] : List<dynamic>.from(json["suppliers"].map((x) => x)),
        transactionDate: json["transactionDate"] == null ? DateTime.now() : DateTime.parse(json["transactionDate"]),
        paymentGateway: json["paymentGateway"],
        referenceId: json["referenceId"],
        trackId: json["trackId"],
        transactionId: json["transactionId"],
        paymentId: json["paymentId"],
        authorizationId: json["authorizationId"],
        transactionStatus: json["transactionStatus"],
        transactionValue: json["transactionValue"],
        customerServiceCharge: json["customerServiceCharge"],
        totalServiceCharge: json["totalServiceCharge"] ?? "",
        dueValue: json["dueValue"],
        paidCurrency: json["paidCurrency"],
        paidCurrencyValue: json["paidCurrencyValue"],
        ipAddress: json["ipAddress"],
        country: json["country"],
        currency: json["currency"],
        error: json["error"],
        cardNumber: json["cardNumber"],
        errorCode: json["errorCode"],
        orderStatus: json["orderStatus"],
        countryDetails: json["countryDetails"] == null ? null : CountriesListModel.fromJson(json["countryDetails"]),
        internationalCountryDetails:
            json["internationalCountryDetails"] == null ? null : InternationalCountryModel.fromJson(json["internationalCountryDetails"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "userId": userId,
        "cartItems": List<dynamic>.from(cartItems.map((x) => x.toJson())),
        "itemsTotal": itemsTotal,
        "taxId": taxId,
        "taxPercent": taxPercent,
        "taxValue": taxValue,
        "couponId": couponId,
        "discountValue": discountValue,
        "discountPercent": discountPercent,
        "shipmentPrice": shipmentPrice,
        "totalCartValue": totalCartValue,
        "totalCartWeight": totalCartWeight,
        "isInternational": isInternational,
        "countryId": countryId,
        "shippingAddressId": shippingAddressId,
        "billingAddressId": billingAddressId,
        "invoiceId": invoiceId,
        "invoiceStatus": invoiceStatus,
        "invoiceReference": invoiceReference,
        "customerReference": customerReference,
        "createdDate": createdDate?.toIso8601String(),
        "expiryDate": expiryDate,
        "expiryTime": expiryTime,
        "invoiceValue": invoiceValue,
        "comments": comments,
        "customerName": customerName,
        "customerMobile": customerMobile,
        "customerEmail": customerEmail,
        "userDefinedField": userDefinedField,
        "invoiceDisplayValue": invoiceDisplayValue,
        "dueDeposit": dueDeposit,
        "depositStatus": depositStatus,
        "invoiceItems": List<dynamic>.from(invoiceItems!.map((x) => x)),
        "suppliers": List<dynamic>.from(suppliers!.map((x) => x)),
        "transactionDate": transactionDate?.toIso8601String(),
        "paymentGateway": paymentGateway,
        "referenceId": referenceId,
        "trackId": trackId,
        "transactionId": transactionId,
        "paymentId": paymentId,
        "authorizationId": authorizationId,
        "transactionStatus": transactionStatus,
        "transactionValue": transactionValue,
        "customerServiceCharge": customerServiceCharge,
        "totalServiceCharge": totalServiceCharge,
        "dueValue": dueValue,
        "paidCurrency": paidCurrency,
        "paidCurrencyValue": paidCurrencyValue,
        "ipAddress": ipAddress,
        "country": country,
        "currency": currency,
        "error": error,
        "cardNumber": cardNumber,
        "errorCode": errorCode,
        "orderStatus": orderStatus,
        "countryDetails": countryDetails,
        "internationalCountryDetails": internationalCountryDetails,
      };
}
