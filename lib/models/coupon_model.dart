import 'dart:convert';

import 'package:shopping_store/models/countries_list.model.dart';

List<CouponModel> couponModelFromJson(String str) => List<CouponModel>.from(json.decode(str).map((x) => CouponModel.fromJson(x)));

CouponModel singleCouponModelFromJson(String str) => CouponModel.fromJson(jsonDecode(str));

String couponModelToJson(List<CouponModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CouponModel {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String couponName;
  final String couponNameInArabic;
  final String couponDescription;
  final String couponDescriptionInArabic;
  final double couponPercent;
  final CountriesListModel countryId;
  final DateTime expiryDate;
  final String couponCode;
  final double minCartValue;
  final int isActive;
  final int couponType;

  CouponModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.couponName,
    required this.couponNameInArabic,
    required this.couponDescription,
    required this.couponDescriptionInArabic,
    required this.couponPercent,
    required this.countryId,
    required this.expiryDate,
    required this.couponCode,
    required this.minCartValue,
    required this.isActive,
    required this.couponType,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) => CouponModel(
        id: json["id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        couponName: json["couponName"],
        couponNameInArabic: json["couponNameInArabic"] ?? "",
        couponDescription: json["couponDescription"] ?? "",
        couponDescriptionInArabic: json["couponDescriptionInArabic"] ?? "",
        couponPercent: json["couponPercent"].toDouble(),
        countryId: CountriesListModel.fromJson(json["countryId"]),
        expiryDate: DateTime.parse(json["expiryDate"]),
        couponCode: json["couponCode"],
        minCartValue: json["minCartValue"].toDouble(),
        isActive: json["isActive"],
        couponType: json["couponType"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "couponName": couponName,
        "couponNameInArabic": couponNameInArabic,
        "couponDescription": couponDescription,
        "couponDescriptionInArabic": couponDescriptionInArabic,
        "couponPercent": couponPercent,
        "countryId": countryId.toJson(),
        "expiryDate": expiryDate.toIso8601String(),
        "couponCode": couponCode,
        "minCartValue": minCartValue,
        "isActive": isActive,
        "couponType": couponType,
      };
}
