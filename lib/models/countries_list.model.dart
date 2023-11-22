// To parse this JSON data, do
//
//     final countriesListModel = countriesListModelFromJson(jsonString);

import 'dart:convert';

List<CountriesListModel> countriesListModelFromJson(String str) =>
    List<CountriesListModel>.from(json.decode(str).map((x) => CountriesListModel.fromJson(x)));
CountriesListModel countryModelFromJson(String str) => CountriesListModel.fromJson(json.decode(str));

String countriesListModelToJson(List<CountriesListModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CountriesListModel {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String countryName;
  final String countryCode;
  final String currencyName;
  final String currencyCode;
  final String currencyCodeInArabic;
  final String image;
  final int isDeleted;
  final String defaultLanguage;
  final String phoneNumber;
  final String email;
  final String address;
  final String latitude;
  final String longitude;

  CountriesListModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.countryName,
    required this.countryCode,
    required this.currencyName,
    required this.currencyCode,
    required this.currencyCodeInArabic,
    required this.image,
    required this.isDeleted,
    required this.defaultLanguage,
    required this.phoneNumber,
    required this.email,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  factory CountriesListModel.fromJson(Map<String, dynamic> json) => CountriesListModel(
        id: json["id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        countryName: json["countryName"],
        countryCode: json["countryCode"],
        currencyName: json["currencyName"],
        currencyCode: json["currencyCode"],
        currencyCodeInArabic: json["currencyCodeInArabic"],
        image: json["image"],
        isDeleted: json["isDeleted"],
        defaultLanguage: json["defaultLanguage"],
        phoneNumber: json["phoneNumber"] ?? "+96566628080",
        email: json["email"] ?? "",
        address: json["address"] ?? "",
        latitude: json["latitude"] ?? "",
        longitude: json["longitude"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "countryName": countryName,
        "countryCode": countryCode,
        "currencyName": currencyName,
        "currencyCode": currencyCode,
        "currencyCodeInArabic": currencyCodeInArabic,
        "image": image,
        "isDeleted": isDeleted,
        "defaultLanguage": defaultLanguage,
        "phoneNumber": phoneNumber,
        "email": email,
        "address": address,
        "latitude": latitude,
        "longitude": longitude,
      };
}
