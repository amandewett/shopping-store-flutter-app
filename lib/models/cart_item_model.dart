// To parse this JSON data, do
//
//     final cartItemModel = cartItemModelFromJson(jsonString);

import 'dart:convert';

import 'package:shopping_store/models/product_list_model.dart';

List<CartItemModel> cartItemModelFromJson(String str) => List<CartItemModel>.from(json.decode(str).map((x) => CartItemModel.fromJson(x)));

String cartItemModelToJson(List<CartItemModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CartItemModel {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int userId;
  final int isGuest;
  final String guestUserId;
  final ProductListModel productId;
  final int countryId;
  final int itemCount;

  CartItemModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    required this.isGuest,
    required this.guestUserId,
    required this.productId,
    required this.countryId,
    required this.itemCount,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) => CartItemModel(
        id: json["id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        userId: json["userId"],
        isGuest: json["isGuest"] ?? 0,
        guestUserId: json["guestUserId"] ?? "",
        productId: ProductListModel.fromJson(json["productId"]),
        countryId: json["countryId"] ?? 1,
        itemCount: json["itemCount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "userId": userId,
        "isGuest": isGuest,
        "guestUserId": guestUserId,
        "productId": productId.toJson(),
        "countryId": countryId,
        "itemCount": itemCount,
      };
}
