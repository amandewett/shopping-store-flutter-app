// To parse this JSON data, do
//
//     final myFatoorahPaymentMethodList = myFatoorahPaymentMethodListFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<MyFatoorahPaymentMethodListModel> myFatoorahPaymentMethodListFromJson(String str) =>
    List<MyFatoorahPaymentMethodListModel>.from(json.decode(str).map((x) => MyFatoorahPaymentMethodListModel.fromJson(x)));

String myFatoorahPaymentMethodListToJson(List<MyFatoorahPaymentMethodListModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MyFatoorahPaymentMethodListModel {
  final int paymentMethodId;
  final String paymentMethodAr;
  final String paymentMethodEn;
  final String paymentMethodCode;
  final bool isDirectPayment;
  final double serviceCharge;
  final double totalAmount;
  final String currencyIso;
  final String imageUrl;
  final bool isEmbeddedSupported;
  final String paymentCurrencyIso;

  MyFatoorahPaymentMethodListModel({
    required this.paymentMethodId,
    required this.paymentMethodAr,
    required this.paymentMethodEn,
    required this.paymentMethodCode,
    required this.isDirectPayment,
    required this.serviceCharge,
    required this.totalAmount,
    required this.currencyIso,
    required this.imageUrl,
    required this.isEmbeddedSupported,
    required this.paymentCurrencyIso,
  });

  factory MyFatoorahPaymentMethodListModel.fromJson(Map<String, dynamic> json) => MyFatoorahPaymentMethodListModel(
        paymentMethodId: json["PaymentMethodId"],
        paymentMethodAr: json["PaymentMethodAr"],
        paymentMethodEn: json["PaymentMethodEn"],
        paymentMethodCode: json["PaymentMethodCode"],
        isDirectPayment: json["IsDirectPayment"],
        serviceCharge: json["ServiceCharge"]?.toDouble(),
        totalAmount: json["TotalAmount"]?.toDouble(),
        currencyIso: json["CurrencyIso"],
        imageUrl: json["ImageUrl"],
        isEmbeddedSupported: json["IsEmbeddedSupported"],
        paymentCurrencyIso: json["PaymentCurrencyIso"],
      );

  Map<String, dynamic> toJson() => {
        "PaymentMethodId": paymentMethodId,
        "PaymentMethodAr": paymentMethodAr,
        "PaymentMethodEn": paymentMethodEn,
        "PaymentMethodCode": paymentMethodCode,
        "IsDirectPayment": isDirectPayment,
        "ServiceCharge": serviceCharge,
        "TotalAmount": totalAmount,
        "CurrencyIso": currencyIso,
        "ImageUrl": imageUrl,
        "IsEmbeddedSupported": isEmbeddedSupported,
        "PaymentCurrencyIso": paymentCurrencyIso,
      };
}
