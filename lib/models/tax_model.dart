// To parse this JSON data, do
//
//     final taxModel = taxModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

import 'package:shopping_store/models/countries_list.model.dart';

TaxModel taxModelFromJson(String str) => TaxModel.fromJson(json.decode(str));

String taxModelToJson(TaxModel data) => json.encode(data.toJson());

class TaxModel {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String taxName;
  final String taxDescription;
  final double taxValue;
  final CountriesListModel countryId;

  TaxModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.taxName,
    required this.taxDescription,
    required this.taxValue,
    required this.countryId,
  });

  factory TaxModel.fromJson(Map<String, dynamic> json) => TaxModel(
        id: json["id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        taxName: json["taxName"],
        taxDescription: json["taxDescription"] ?? "",
        taxValue: json["taxValue"].toDouble(),
        countryId: CountriesListModel.fromJson(json["countryId"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "taxName": taxName,
        "taxDescription": taxDescription,
        "taxValue": taxValue,
        "countryId": countryId.toJson(),
      };
}
