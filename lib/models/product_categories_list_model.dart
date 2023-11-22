// To parse this JSON data, do
//
//      productCategoriesListModel = productCategoriesListModelFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_store/constants/app_colors.dart';
import 'package:shopping_store/models/product_sub_categories_list_model.dart';

List<ProductCategoriesListModel> productCategoriesListModelFromJson(String str) =>
    List<ProductCategoriesListModel>.from(json.decode(str).map((x) => ProductCategoriesListModel.fromJson(x)));

String productCategoriesListModelToJson(List<ProductCategoriesListModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductCategoriesListModel {
  int id;
  DateTime createdAt;
  DateTime updatedAt;
  String englishName;
  String arabicName;
  String englishDescription;
  String arabicDescription;
  int? isFeatured;
  int addedBy;
  int isActive;
  List<ProductSubCategoriesListModel>? arrSubCategories;
  IconData icon;
  Color backgroundColor;

  ProductCategoriesListModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.englishName,
    required this.arabicName,
    required this.englishDescription,
    required this.arabicDescription,
    this.isFeatured,
    required this.addedBy,
    required this.isActive,
    this.arrSubCategories,
    this.icon = Icons.widgets_outlined,
    this.backgroundColor = AppColors.logoColor1,
  });

  factory ProductCategoriesListModel.fromJson(Map<String, dynamic> json) => ProductCategoriesListModel(
        id: json["id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        englishName: json["englishName"],
        arabicName: json["arabicName"],
        englishDescription: json["englishDescription"] ?? "",
        arabicDescription: json["arabicDescription"] ?? "",
        isFeatured: json["isFeatured"],
        addedBy: json["addedBy"],
        isActive: json["isActive"],
        arrSubCategories: json["arrSubCategories"] == null
            ? []
            : List<ProductSubCategoriesListModel>.from(json["arrSubCategories"]!.map((x) => ProductSubCategoriesListModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "englishName": englishName,
        "arabicName": arabicName,
        "englishDescription": englishDescription,
        "arabicDescription": arabicDescription,
        "isFeatured": isFeatured,
        "addedBy": addedBy,
        "isActive": isActive,
        "arrSubCategories": arrSubCategories == null ? [] : List<dynamic>.from(arrSubCategories!.map((x) => x.toJson())),
      };
}
