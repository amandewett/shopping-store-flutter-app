import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shopping_store/constants/app_storage_keys.dart';
import 'package:shopping_store/main.dart';
import 'package:shopping_store/models/product_list_model.dart';
import 'package:shopping_store/services/api.dart';
import 'package:shopping_store/services/remote_service.dart';

class SearchProductsController extends GetxController {
  final BuildContext context;
  final formKey = GlobalKey<FormState>();
  TextEditingController searchTextEditingController = TextEditingController();
  int pageSize = 10;
  List<ProductListModel> productsList = [];
  int totalProducts = 0;
  FocusNode searchFieldFocusNode = FocusNode();
  final int categoryId;
  final String category;
  final bool isFeatured;
  final bool isNewArrival;
  List<ProductListModel> listFeaturedProducts = [];
  List<ProductListModel> listNewArrivalProducts = [];

  SearchProductsController(
    this.context,
    this.categoryId,
    this.category,
    this.isFeatured,
    this.isNewArrival,
  );

  @override
  void onInit() {
    if (!isFeatured && !isNewArrival) {
      if (category == "") {
        searchFieldFocusNode.requestFocus();
      } else {
        getProductsByCategoryId(categoryId);
      }
    } else {
      isFeatured ? _getFeaturedProducts() : _getNewArrivalProducts();
    }
    super.onInit();
  }

  @override
  void onClose() {
    searchFieldFocusNode.dispose();
    super.onClose();
  }

  String? validator(BuildContext context, String? value) {
    if (value != null) {
      if (value.isEmpty) {
        return "textFieldEmptyError".tr;
      }
    }
    return null;
  }

  searchFieldOnChanged(String text) async {
    if (!isFeatured && !isNewArrival) {
      text == ""
          ? category == ""
              ? getProducts()
              : getProductsByCategoryId(categoryId)
          : category == ""
              ? searchProduct(text.trim())
              : searchProductsByCategoryId(
                  categoryId,
                  text.trim(),
                );
    } else {}
  }

  goBack() async {
    Get.back();
  }

  searchProduct(String keyword) async {
    productsList = [];
    update();
    Map<String, dynamic> apiResponse = await RemoteService().get(
      context: context,
      endpoint: "${Api.apiListProducts}/${hiveBox.get(AppStorageKeys.selectedCountryId)}/$keyword?pageNumber=1&limit=1000",
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

  getProducts() async {
    Map<String, dynamic> apiResponse = await RemoteService().get(
      context: context,
      endpoint: "${Api.apiListProducts}/${hiveBox.get(AppStorageKeys.selectedCountryId)}?pageNumber=1&limit=10",
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

  getProductsByCategoryId(int categoryId) async {
    Map<String, dynamic> apiResponse = await RemoteService().get(
      context: context,
      endpoint: categoryId == 0
          ? "${Api.apiListProducts}/${hiveBox.get(AppStorageKeys.selectedCountryId)}?pageNumber=1&limit=10"
          : "${Api.apiListProductsByCategoryId}/${hiveBox.get(AppStorageKeys.selectedCountryId)}/$categoryId?pageNumber=1&limit=10",
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

  _getFeaturedProducts() async {
    Map<String, dynamic> apiResponse =
        await RemoteService().get(context: context, endpoint: "${Api.apiListFeaturedProducts}/${hiveBox.get(AppStorageKeys.selectedCountryId)}");
    if (apiResponse.isNotEmpty && apiResponse['status']) {
      productsList = productListModelFromJson(jsonEncode(apiResponse['result']));
      update();
    } else {
      BotToast.showText(text: apiResponse['message']);
    }
  }

  _getNewArrivalProducts() async {
    Map<String, dynamic> apiResponse =
        await RemoteService().get(context: context, endpoint: "${Api.apiListNewArrivalProducts}/${hiveBox.get(AppStorageKeys.selectedCountryId)}");
    if (apiResponse.isNotEmpty && apiResponse['status']) {
      productsList = productListModelFromJson(jsonEncode(apiResponse['result']));
      update();
    } else {
      BotToast.showText(text: apiResponse['message']);
    }
  }

  searchProductsByCategoryId(int categoryId, String keyword) async {
    Map<String, dynamic> apiResponse = await RemoteService().get(
      context: context,
      endpoint: categoryId == 0
          ? "${Api.apiListProducts}/${hiveBox.get(AppStorageKeys.selectedCountryId)}/$keyword?pageNumber=1&limit=1000"
          : "${Api.apiListProductsByCategoryId}/${hiveBox.get(AppStorageKeys.selectedCountryId)}/$categoryId/$keyword?pageNumber=1&limit=1000",
    );
    if (apiResponse.isNotEmpty && apiResponse['status']) {
      productsList = productListModelFromJson(jsonEncode(apiResponse['result']));
      update();
    } else {
      BotToast.showText(text: apiResponse['message']);
    }
  }

  loadMoreData() async {
    if (totalProducts > productsList.length) {
      Map<String, dynamic> apiResponse = await RemoteService().get(
        context: context,
        endpoint: category == ""
            ? "${Api.apiListProducts}/${hiveBox.get(AppStorageKeys.selectedCountryId)}?pageNumber=${((productsList.length / 10) + 1).round()}&limit=10"
            : categoryId == 0
                ? "${Api.apiListProducts}/${hiveBox.get(AppStorageKeys.selectedCountryId)}?pageNumber=${((productsList.length / 10) + 1).round()}&limit=10"
                : "${Api.apiListProductsByCategoryId}/${hiveBox.get(AppStorageKeys.selectedCountryId)}/$categoryId?pageNumber=${((productsList.length / 10) + 1).round()}&limit=10",
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
