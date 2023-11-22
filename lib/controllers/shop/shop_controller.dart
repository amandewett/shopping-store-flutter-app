import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_store/constants/app_storage_keys.dart';
import 'package:shopping_store/main.dart';
import 'package:shopping_store/services/api.dart';
import 'package:shopping_store/services/remote_service.dart';
import '../../models/product_list_model.dart';

class ShopController extends GetxController {
  BuildContext context;
  int pageSize = 10;
  List<ProductListModel> productsList = [];
  int totalProducts = 0;
  FocusNode searchFieldFocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  TextEditingController searchTextEditingController = TextEditingController();

  ShopController(this.context);

  @override
  void onInit() {
    getShopProducts("");
    super.onInit();
  }

  String? validator(BuildContext context, String? value) {
    if (value != null) {
      if (value.isEmpty) {
        return "textFieldEmptyError".tr;
      }
    }
    return null;
  }

  goBack() async {
    Get.back();
  }

  searchFieldOnChanged(String text) async {
    getShopProducts(text);
  }

  getShopProducts(String searchKeyword) async {
    Map<String, dynamic> apiResponse = await RemoteService().get(
      context: context,
      endpoint: searchKeyword == ""
          ? "${Api.apiListProductsForShopPage}/${hiveBox.get(AppStorageKeys.selectedCountryId)}?pageNumber=1&limit=10"
          : "${Api.apiListProductsForShopPage}/${hiveBox.get(AppStorageKeys.selectedCountryId)}/$searchKeyword?pageNumber=1&limit=10",
    );
    if (apiResponse.isNotEmpty && apiResponse['status']) {
      var productsLength = apiResponse['total'];
      totalProducts = productsLength;
      productsList = productListModelFromJson(jsonEncode(apiResponse['result']));
      update();
    } else {
      BotToast.showText(text: apiResponse['message']);
    }
  }

  loadMoreData(String searchKeyword) async {
    if (totalProducts > productsList.length) {
      Map<String, dynamic> apiResponse = await RemoteService().get(
        context: context,
        endpoint: searchKeyword == ""
            ? "${Api.apiListProductsForShopPage}/${hiveBox.get(AppStorageKeys.selectedCountryId)}?pageNumber=${((productsList.length / 10) + 1).round()}&limit=10"
            : "${Api.apiListProductsForShopPage}/${hiveBox.get(AppStorageKeys.selectedCountryId)}/$searchKeyword?pageNumber=${((productsList.length / 10) + 1).round()}&limit=10",
      );
      if (apiResponse.isNotEmpty && apiResponse['status']) {
        productsList.addAll(productListModelFromJson(jsonEncode(apiResponse['result'])));
        update();
      } else {
        BotToast.showText(text: apiResponse['message']);
      }
    }
  }

  String getImageFromProductMediaList({required List<String> listMedia}) {
    if (listMedia.isNotEmpty) {
      for (String media in listMedia) {
        if (isImage(media)) {
          return media;
        }
      }
      return "";
    } else {
      return "";
    }
  }

  String getVideoFromProductMediaList({required List<String> listMedia}) {
    if (listMedia.isNotEmpty) {
      for (String media in listMedia) {
        if (!isImage(media)) {
          return media;
        }
      }
      return "";
    } else {
      return "";
    }
  }

  bool isImage(String url) {
    List<String> splitedPath = url.split(".");
    String ext = splitedPath[splitedPath.length - 1];
    List<String> listImageExt = ['jpg', 'jpeg', 'png'];
    return listImageExt.contains(ext);
  }
}
