// To parse this JSON data, do
//
//     final myFatoorahPaymentFailedResponseModel = myFatoorahPaymentFailedResponseModelFromJson(jsonString);

import 'dart:convert';

MyFatoorahPaymentFailedResponseModel myFatoorahPaymentFailedResponseModelFromJson(String str) =>
    MyFatoorahPaymentFailedResponseModel.fromJson(json.decode(str));

String myFatoorahPaymentFailedResponseModelToJson(MyFatoorahPaymentFailedResponseModel data) => json.encode(data.toJson());

class MyFatoorahPaymentFailedResponseModel {
  final bool? isSuccess;
  final String? message;
  final Data? data;

  MyFatoorahPaymentFailedResponseModel({
    this.isSuccess,
    this.message,
    this.data,
  });

  factory MyFatoorahPaymentFailedResponseModel.fromJson(Map<String, dynamic> json) => MyFatoorahPaymentFailedResponseModel(
        isSuccess: json["IsSuccess"],
        message: json["Message"],
        data: json["Data"] == null ? null : Data.fromJson(json["Data"]),
      );

  Map<String, dynamic> toJson() => {
        "IsSuccess": isSuccess,
        "Message": message,
        "Data": data?.toJson(),
      };
}

class Data {
  final int? invoiceId;
  final String? invoiceStatus;
  final String? invoiceReference;
  final String? customerReference;
  final DateTime? createdDate;
  final String? expiryDate;
  final String? expiryTime;
  final int? invoiceValue;
  final String? comments;
  final String? customerName;
  final String? customerMobile;
  final String? customerEmail;
  final String? userDefinedField;
  final String? invoiceDisplayValue;
  final int? dueDeposit;
  final String? depositStatus;
  final List<dynamic>? invoiceItems;
  final List<InvoiceTransaction>? invoiceTransactions;
  final List<dynamic>? suppliers;

  Data({
    this.invoiceId,
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
    this.invoiceTransactions,
    this.suppliers,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        invoiceId: json["InvoiceId"],
        invoiceStatus: json["InvoiceStatus"],
        invoiceReference: json["InvoiceReference"],
        customerReference: json["CustomerReference"],
        createdDate: json["CreatedDate"] == null ? null : DateTime.parse(json["CreatedDate"]),
        expiryDate: json["ExpiryDate"],
        expiryTime: json["ExpiryTime"],
        invoiceValue: json["InvoiceValue"],
        comments: json["Comments"],
        customerName: json["CustomerName"],
        customerMobile: json["CustomerMobile"],
        customerEmail: json["CustomerEmail"],
        userDefinedField: json["UserDefinedField"],
        invoiceDisplayValue: json["InvoiceDisplayValue"],
        dueDeposit: json["DueDeposit"],
        depositStatus: json["DepositStatus"],
        invoiceItems: json["InvoiceItems"] == null ? [] : List<dynamic>.from(json["InvoiceItems"]!.map((x) => x)),
        invoiceTransactions: json["InvoiceTransactions"] == null
            ? []
            : List<InvoiceTransaction>.from(json["InvoiceTransactions"]!.map((x) => InvoiceTransaction.fromJson(x))),
        suppliers: json["Suppliers"] == null ? [] : List<dynamic>.from(json["Suppliers"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "InvoiceId": invoiceId,
        "InvoiceStatus": invoiceStatus,
        "InvoiceReference": invoiceReference,
        "CustomerReference": customerReference,
        "CreatedDate": createdDate?.toIso8601String(),
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
        "InvoiceItems": invoiceItems == null ? [] : List<dynamic>.from(invoiceItems!.map((x) => x)),
        "InvoiceTransactions": invoiceTransactions == null ? [] : List<dynamic>.from(invoiceTransactions!.map((x) => x.toJson())),
        "Suppliers": suppliers == null ? [] : List<dynamic>.from(suppliers!.map((x) => x)),
      };
}

class InvoiceTransaction {
  final DateTime? transactionDate;
  final String? paymentGateway;
  final String? referenceId;
  final String? trackId;
  final String? transactionId;
  final String? paymentId;
  final String? authorizationId;
  final String? transactionStatus;
  final String? transationValue;
  final String? customerServiceCharge;
  final String? totalServiceCharge;
  final String? dueValue;
  final String? paidCurrency;
  final String? paidCurrencyValue;
  final String? vatAmount;
  final String? ipAddress;
  final String? country;
  final String? currency;
  final String? error;
  final String? cardNumber;
  final String? errorCode;

  InvoiceTransaction({
    this.transactionDate,
    this.paymentGateway,
    this.referenceId,
    this.trackId,
    this.transactionId,
    this.paymentId,
    this.authorizationId,
    this.transactionStatus,
    this.transationValue,
    this.customerServiceCharge,
    this.totalServiceCharge,
    this.dueValue,
    this.paidCurrency,
    this.paidCurrencyValue,
    this.vatAmount,
    this.ipAddress,
    this.country,
    this.currency,
    this.error,
    this.cardNumber,
    this.errorCode,
  });

  factory InvoiceTransaction.fromJson(Map<String, dynamic> json) => InvoiceTransaction(
        transactionDate: json["TransactionDate"] == null ? null : DateTime.parse(json["TransactionDate"]),
        paymentGateway: json["PaymentGateway"],
        referenceId: json["ReferenceId"],
        trackId: json["TrackId"],
        transactionId: json["TransactionId"],
        paymentId: json["PaymentId"],
        authorizationId: json["AuthorizationId"],
        transactionStatus: json["TransactionStatus"],
        transationValue: json["TransationValue"],
        customerServiceCharge: json["CustomerServiceCharge"],
        totalServiceCharge: json["TotalServiceCharge"],
        dueValue: json["DueValue"],
        paidCurrency: json["PaidCurrency"],
        paidCurrencyValue: json["PaidCurrencyValue"],
        vatAmount: json["VatAmount"],
        ipAddress: json["IpAddress"],
        country: json["Country"],
        currency: json["Currency"],
        error: json["Error"],
        cardNumber: json["CardNumber"],
        errorCode: json["ErrorCode"],
      );

  Map<String, dynamic> toJson() => {
        "TransactionDate": transactionDate?.toIso8601String(),
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
        "VatAmount": vatAmount,
        "IpAddress": ipAddress,
        "Country": country,
        "Currency": currency,
        "Error": error,
        "CardNumber": cardNumber,
        "ErrorCode": errorCode,
      };
}
