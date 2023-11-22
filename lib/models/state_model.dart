// To parse this JSON data, do
//
//     final stateModel = stateModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<StateModel> listStateModelFromJson(String str) => List<StateModel>.from(json.decode(str).map((x) => StateModel.fromJson(x)));
String stateModelToJson(List<StateModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

StateModel stateModelFromJson(String str) => StateModel.fromJson(json.decode(str));

class StateModel {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int countryId;
  final String stateName;
  final double shipmentPrice;
  final int addedBy;

  StateModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.countryId,
    required this.stateName,
    required this.shipmentPrice,
    required this.addedBy,
  });

  factory StateModel.fromJson(Map<String, dynamic> json) => StateModel(
        id: json["id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        countryId: json["countryId"],
        stateName: json["stateName"],
        shipmentPrice: json["shipmentPrice"].toDouble(),
        addedBy: json["addedBy"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "countryId": countryId,
        "stateName": stateName,
        "shipmentPrice": shipmentPrice,
        "addedBy": addedBy,
      };
}
