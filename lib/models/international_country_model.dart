// To parse this JSON data, do
//
//     final internationalCountryModel = internationalCountryModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<InternationalCountryModel> internationalCountryListModelFromJson(String str) =>
    List<InternationalCountryModel>.from(json.decode(str).map((x) => InternationalCountryModel.fromJson(x)));
InternationalCountryModel internationalCountryModelFromJson(String str) => InternationalCountryModel.fromJson(json.decode(str));

String internationalCountryModelToJson(List<InternationalCountryModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class InternationalCountryModel {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String countryName;
  final String countryCode;
  final String countryImage;
  final double priceOne;
  final double priceTwo;

  InternationalCountryModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.countryName,
    required this.countryCode,
    required this.countryImage,
    required this.priceOne,
    required this.priceTwo,
  });

  factory InternationalCountryModel.fromJson(Map<String, dynamic> json) => InternationalCountryModel(
        id: json["id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        countryName: json["countryName"],
        countryCode: json["countryCode"],
        countryImage: json["countryImage"],
        priceOne: json["priceOne"].toDouble(),
        priceTwo: json["priceTwo"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "countryName": countryName,
        "countryCode": countryCode,
        "countryImage": countryImage,
        "priceOne": priceOne,
        "priceTwo": priceTwo,
      };
}
