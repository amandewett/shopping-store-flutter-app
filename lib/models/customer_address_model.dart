// To parse this JSON data, do
//
//     final customerAddressModel = customerAddressModelFromJson(jsonString);

import 'dart:convert';

import 'package:shopping_store/models/countries_list.model.dart';
import 'package:shopping_store/models/international_country_model.dart';
import 'package:shopping_store/models/state_model.dart';

List<CustomerAddressModel> customerAddressModelFromJson(String str) =>
    List<CustomerAddressModel>.from(json.decode(str).map((x) => CustomerAddressModel.fromJson(x)));

/* List<CustomerAddressModel> customerAddressModelFromJson(String str) {
  return List<CustomerAddressModel>.from(json.decode(str).map((x) {
    return CustomerAddressModel.fromJson(x);
  }));
} */

String customerAddressModelToJson(List<CustomerAddressModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CustomerAddressModel {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int userId;
  final String name;
  final String email;
  final String phoneNumber;
  final int isInternational;
  final int countryId;
  final CountriesListModel? countryDetails;
  final InternationalCountryModel? internationalCountryDetails;
  final int stateId;
  final StateModel? stateDetails;
  final String address;
  final dynamic address2;
  final String city;
  final String postalCode;
  final int isDefault;

  CustomerAddressModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.isInternational,
    required this.countryId,
    this.countryDetails,
    this.internationalCountryDetails,
    required this.stateId,
    this.stateDetails,
    required this.address,
    required this.address2,
    required this.city,
    required this.postalCode,
    required this.isDefault,
  });

  factory CustomerAddressModel.fromJson(Map<String, dynamic> json) => CustomerAddressModel(
        id: json["id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        userId: json["userId"],
        name: json["name"],
        email: json["email"],
        phoneNumber: json["phoneNumber"],
        isInternational: json["isInternational"],
        countryId: json["countryId"],
        countryDetails: json["countryDetails"] == null ? null : CountriesListModel.fromJson(json["countryDetails"]),
        internationalCountryDetails:
            json["internationalCountryDetails"] == null ? null : InternationalCountryModel.fromJson(json["internationalCountryDetails"]),
        stateId: json["stateId"] ?? 0,
        stateDetails: json["stateDetails"] == null ? null : StateModel.fromJson(json["stateDetails"]),
        address: json["address"],
        address2: json["address2"] ?? "",
        city: json["city"],
        postalCode: json["postalCode"],
        isDefault: json["isDefault"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "userId": userId,
        "name": name,
        "email": email,
        "phoneNumber": phoneNumber,
        "isInternational": isInternational,
        "countryId": countryId,
        "countryDetails": countryDetails,
        "internationalCountryDetails": internationalCountryDetails,
        "stateId": stateId,
        "stateDetails": stateDetails,
        "address": address,
        "address2": address2,
        "city": city,
        "postalCode": postalCode,
        "isDefault": isDefault,
      };
}
