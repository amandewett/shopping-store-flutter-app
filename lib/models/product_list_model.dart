// To parse this JSON data, do
//
//     final productListModel = productListModelFromJson(jsonString);

import 'dart:convert';

import 'package:shopping_store/models/product_categories_list_model.dart';
import 'package:shopping_store/models/product_sub_categories_list_model.dart';

List<ProductListModel> productListModelFromJson(String str) => List<ProductListModel>.from(json.decode(str).map((x) => ProductListModel.fromJson(x)));

String productListModelToJson(List<ProductListModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductListModel {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String englishName;
  final String arabicName;
  final String englishDescription;
  final String arabicDescription;
  final ProductCategoriesListModel categoryId;
  final ProductSubCategoriesListModel subCategoryId;
  final int countryId;
  final double price;
  final List<String> arrMedia;
  final int isFeatured;
  final int isNewArrival;
  final int isPackage;
  final int isActive;
  final int addedBy;
  final double weight;

  ProductListModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.englishName,
    required this.arabicName,
    required this.englishDescription,
    required this.arabicDescription,
    required this.categoryId,
    required this.subCategoryId,
    required this.countryId,
    required this.price,
    required this.arrMedia,
    required this.isFeatured,
    required this.isNewArrival,
    required this.isPackage,
    required this.isActive,
    required this.addedBy,
    required this.weight,
  });

  factory ProductListModel.fromJson(Map<String, dynamic> json) => ProductListModel(
        id: json["id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        englishName: json["englishName"],
        arabicName: json["arabicName"],
        englishDescription: json["englishDescription"] ?? "",
        arabicDescription: json["arabicDescription"] ?? "",
        categoryId: ProductCategoriesListModel.fromJson(json["categoryId"]),
        subCategoryId: ProductSubCategoriesListModel.fromJson(json["subCategoryId"]),
        countryId: json["countryId"],
        price: json["price"].toDouble(),
        arrMedia: List<String>.from(json["arrMedia"].map((x) => x)),
        isFeatured: json["isFeatured"],
        isNewArrival: json["isNewArrival"],
        isPackage: json["isPackage"],
        isActive: json["isActive"],
        addedBy: json["addedBy"],
        weight: json["weight"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "englishName": englishName,
        "arabicName": arabicName,
        "englishDescription": englishDescription,
        "arabicDescription": arabicDescription,
        "categoryId": categoryId.toJson(),
        "subCategoryId": subCategoryId.toJson(),
        "countryId": countryId,
        "price": price,
        "arrMedia": List<dynamic>.from(arrMedia.map((x) => x)),
        "isFeatured": isFeatured,
        "isNewArrival": isNewArrival,
        "isPackage": isPackage,
        "isActive": isActive,
        "addedBy": addedBy,
        "weight": weight,
      };
}
