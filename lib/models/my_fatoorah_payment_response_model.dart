// To parse this JSON data, do
//
//     final myFatoorahPaymentResponseModel = myFatoorahPaymentResponseModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

MyFatoorahPaymentResponseModel myFatoorahPaymentResponseModelFromJson(String str) => MyFatoorahPaymentResponseModel.fromJson(json.decode(str));

String myFatoorahPaymentResponseModelToJson(MyFatoorahPaymentResponseModel data) => json.encode(data.toJson());

class MyFatoorahPaymentResponseModel {
  final int invoiceId;
  final String invoiceStatus;
  final String invoiceReference;
  final String customerReference;
  final DateTime createdDate;
  final String expiryDate;
  final String expiryTime;
  final double invoiceValue;
  final String comments;
  final String customerName;
  final String customerMobile;
  final String customerEmail;
  final String userDefinedField;
  final String invoiceDisplayValue;
  final String dueDeposit;
  final String depositStatus;
  final List<dynamic> invoiceItems;
  final List<InvoiceTransaction> invoiceTransactions;
  final List<dynamic> suppliers;

  MyFatoorahPaymentResponseModel({
    required this.invoiceId,
    required this.invoiceStatus,
    required this.invoiceReference,
    required this.customerReference,
    required this.createdDate,
    required this.expiryDate,
    required this.expiryTime,
    required this.invoiceValue,
    required this.comments,
    required this.customerName,
    required this.customerMobile,
    required this.customerEmail,
    required this.userDefinedField,
    required this.invoiceDisplayValue,
    required this.dueDeposit,
    required this.depositStatus,
    required this.invoiceItems,
    required this.invoiceTransactions,
    required this.suppliers,
  });

  factory MyFatoorahPaymentResponseModel.fromJson(Map<String, dynamic> json) => MyFatoorahPaymentResponseModel(
        invoiceId: json["InvoiceId"],
        invoiceStatus: json["InvoiceStatus"] ?? "",
        invoiceReference: json["InvoiceReference"] ?? "",
        customerReference: json["CustomerReference"] ?? "",
        createdDate: DateTime.parse(json["CreatedDate"]),
        expiryDate: json["ExpiryDate"] ?? "",
        expiryTime: json["ExpiryTime"] ?? "",
        invoiceValue: json["InvoiceValue"]?.toDouble() ?? 0,
        comments: json["Comments"] ?? "",
        customerName: json["CustomerName"] ?? "",
        customerMobile: json["CustomerMobile"] ?? "",
        customerEmail: json["CustomerEmail"] ?? "",
        userDefinedField: json["UserDefinedField"] ?? "",
        invoiceDisplayValue: json["InvoiceDisplayValue"] ?? "",
        dueDeposit: json["DueDeposit"] ?? "",
        depositStatus: json["DepositStatus"] ?? "",
        invoiceItems: List<dynamic>.from(json["InvoiceItems"].map((x) => x)),
        invoiceTransactions: List<InvoiceTransaction>.from(json["InvoiceTransactions"].map((x) => InvoiceTransaction.fromJson(x))),
        suppliers: List<dynamic>.from(json["Suppliers"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "InvoiceId": invoiceId,
        "InvoiceStatus": invoiceStatus,
        "InvoiceReference": invoiceReference,
        "CustomerReference": customerReference,
        "CreatedDate": createdDate.toIso8601String(),
        "ExpiryDate": expiryDate,
        "ExpiryTime": expiryTime,
        "InvoiceValue": invoiceValue,
        "Comments": comments,
        "CustomerName": customerName,
        "CustomerMobile": customerMobile,
        "CustomerEmail": customerEmail,
        "UserDefinedField": userDefinedField,
        "InvoiceDisplayValue": invoiceDisplayValue,
        "DueDeposit": dueDeposit,
        "DepositStatus": depositStatus,
        "InvoiceItems": List<dynamic>.from(invoiceItems.map((x) => x)),
        "InvoiceTransactions": List<dynamic>.from(invoiceTransactions.map((x) => x.toJson())),
        "Suppliers": List<dynamic>.from(suppliers.map((x) => x)),
      };
}

class InvoiceTransaction {
  final DateTime transactionDate;
  final String paymentGateway;
  final String referenceId;
  final String trackId;
  final String transactionId;
  final String paymentId;
  final String authorizationId;
  final String transactionStatus;
  final String transationValue;
  final String customerServiceCharge;
  final StringConversionSink? totalServiceCharge;
  final String dueValue;
  final String paidCurrency;
  final String paidCurrencyValue;
  final String ipAddress;
  final String country;
  final String currency;
  final String error;
  final String cardNumber;
  final String errorCode;

  InvoiceTransaction({
    required this.transactionDate,
    required this.paymentGateway,
    required this.referenceId,
    required this.trackId,
    required this.transactionId,
    required this.paymentId,
    required this.authorizationId,
    required this.transactionStatus,
    required this.transationValue,
    required this.customerServiceCharge,
    this.totalServiceCharge,
    required this.dueValue,
    required this.paidCurrency,
    required this.paidCurrencyValue,
    required this.ipAddress,
    required this.country,
    required this.currency,
    required this.error,
    required this.cardNumber,
    required this.errorCode,
  });

  factory InvoiceTransaction.fromJson(Map<String, dynamic> json) => InvoiceTransaction(
        transactionDate: DateTime.parse(json["TransactionDate"]),
        paymentGateway: json["PaymentGateway"] ?? "",
        referenceId: json["ReferenceId"] ?? "",
        trackId: json["TrackId"] ?? "",
        transactionId: json["TransactionId"] ?? "",
        paymentId: json["PaymentId"] ?? "",
        authorizationId: json["AuthorizationId"] ?? "",
        transactionStatus: json["TransactionStatus"] ?? "",
        transationValue: json["TransationValue"] ?? "",
        customerServiceCharge: json["CustomerServiceCharge"] ?? "",
        totalServiceCharge: json["TotalServiceCharge"],
        dueValue: json["DueValue"] ?? "",
        paidCurrency: json["PaidCurrency"] ?? "",
        paidCurrencyValue: json["PaidCurrencyValue"] ?? "",
        ipAddress: json["IpAddress"] ?? "",
        country: json["Country"] ?? "",
        currency: json["Currency"] ?? "",
        error: json["Error"] ?? "",
        cardNumber: json["CardNumber"] ?? "",
        errorCode: json["ErrorCode"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "TransactionDate": transactionDate.toIso8601String(),
        "PaymentGateway": paymentGateway,
        "ReferenceId": referenceId,
        "TrackId": trackId,
        "TransactionId": transactionId,
        "PaymentId": paymentId,
        "AuthorizationId": authorizationId,
        "TransactionStatus": transactionStatus,
        "TransationValue": transationValue,
        "CustomerServiceCharge": customerServiceCharge,
        "TotalServiceCharge": totalServiceCharge,
        "DueValue": dueValue,
        "PaidCurrency": paidCurrency,
        "PaidCurrencyValue": paidCurrencyValue,
        "IpAddress": ipAddress,
        "Country": country,
        "Currency": currency,
        "Error": error,
        "CardNumber": cardNumber,
        "ErrorCode": errorCode,
      };
}
