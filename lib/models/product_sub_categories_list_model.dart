// To parse this JSON data, do
//
//     final productSubCategoriesListModel = productSubCategoriesListModelFromJson(jsonString);

import 'dart:convert';

List<ProductSubCategoriesListModel> productSubCategoriesListModelFromJson(String str) => List<ProductSubCategoriesListModel>.from(json.decode(str).map((x) => ProductSubCategoriesListModel.fromJson(x)));

String productSubCategoriesListModelToJson(List<ProductSubCategoriesListModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductSubCategoriesListModel {
    final int id;
    final DateTime createdAt;
    final DateTime updatedAt;
    final String englishName;
    final String arabicName;
    final String englishDescription;
    final String arabicDescription;
    final int addedBy;
    final int isActive;

    ProductSubCategoriesListModel({
        required this.id,
        required this.createdAt,
        required this.updatedAt,
        required this.englishName,
        required this.arabicName,
        required this.englishDescription,
        required this.arabicDescription,
        required this.addedBy,
        required this.isActive,
    });

    factory ProductSubCategoriesListModel.fromJson(Map<String, dynamic> json) => ProductSubCategoriesListModel(
        id: json["id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        englishName: json["englishName"],
        arabicName: json["arabicName"],
        englishDescription: json["englishDescription"],
        arabicDescription: json["arabicDescription"],
        addedBy: json["addedBy"],
        isActive: json["isActive"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "englishName": englishName,
        "arabicName": arabicName,
        "englishDescription": englishDescription,
        "arabicDescription": arabicDescription,
        "addedBy": addedBy,
        "isActive": isActive,
    };
}
