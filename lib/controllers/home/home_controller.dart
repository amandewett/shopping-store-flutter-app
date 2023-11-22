import 'dart:convert';
import 'dart:math';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_store/constants/app_colors.dart';
import 'package:shopping_store/constants/app_storage_keys.dart';
import 'package:shopping_store/main.dart';
import 'package:shopping_store/models/product_categories_list_model.dart';
import 'package:shopping_store/models/product_list_model.dart';
import 'package:shopping_store/services/api.dart';
import 'package:shopping_store/services/remote_service.dart';
import 'package:shopping_store/views/pages/auth/welcome_page.dart';
import 'package:shopping_store/views/pages/search_products/search_products_page.dart';

class HomeController extends GetxController {
  final BuildContext context;
  List<ProductCategoriesListModel> listProductCategories = [];
  List<ProductCategoriesListModel> listPackageCategories = [];
  late ProductCategoriesListModel packageProductCategory;
  List<ProductListModel> listFeaturedProducts = [];
  List<ProductListModel> listNewArrivalProducts = [];
  List<ProductListModel> listPackagedProducts = [];
  final formKey = GlobalKey<FormState>();
  final searchTextEditingController = TextEditingController();
  bool isPackageCategoryExists = false;
  ProductCategoriesListModel allCategory = ProductCategoriesListModel(
    id: 0,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    englishName: "All categories",
    arabicName: "جميع الفئات",
    englishDescription: "All categories",
    arabicDescription: "جميع الفئات",
    isFeatured: 1,
    addedBy: 0,
    isActive: 1,
  );

  HomeController(this.context);

  @override
  void onInit() {
    initializePage();
    super.onInit();
  }

  initializePage() {
    _getCategories();
    _getFeaturedProducts();
    _getNewArrivalProducts();
    _getPackageCategory();
  }

  _getCategories() async {
    Map<String, dynamic> apiResponse = await RemoteService().get(context: context, endpoint: Api.apiListFeaturedCategories);
    if (apiResponse.isNotEmpty && apiResponse['status']) {
      listProductCategories = productCategoriesListModelFromJson(jsonEncode(apiResponse['result']));
      listProductCategories.insert(0, allCategory);
      int index = 0;
      for (ProductCategoriesListModel productCategory in listProductCategories) {
        productCategory.backgroundColor = AppColors.listColorsAndIcons[index]['color'];
        productCategory.icon = AppColors.listColorsAndIcons[index]['icon'];
        index++;
      }
      update();
    } else {
      BotToast.showText(text: apiResponse['message']);
    }
  }

  _getFeaturedProducts() async {
    Map<String, dynamic> apiResponse =
        await RemoteService().get(context: context, endpoint: "${Api.apiListFeaturedProducts}/${hiveBox.get(AppStorageKeys.selectedCountryId)}");
    if (apiResponse.isNotEmpty && apiResponse['status']) {
      listFeaturedProducts = productListModelFromJson(jsonEncode(apiResponse['result']));
      update();
    } else {
      BotToast.showText(text: apiResponse['message']);
    }
  }

  _getNewArrivalProducts() async {
    Map<String, dynamic> apiResponse =
        await RemoteService().get(context: context, endpoint: "${Api.apiListNewArrivalProducts}/${hiveBox.get(AppStorageKeys.selectedCountryId)}");
    if (apiResponse.isNotEmpty && apiResponse['status']) {
      listNewArrivalProducts = productListModelFromJson(jsonEncode(apiResponse['result']));
      update();
    } else {
      BotToast.showText(text: apiResponse['message']);
    }
  }

  _getPackageCategory() async {
    Map<String, dynamic> apiResponse = await RemoteService().get(context: context, endpoint: "${Api.apiListCategories}/package");
    if (apiResponse.isNotEmpty && apiResponse['status']) {
      if (apiResponse['result'].length != 0) {
        listPackageCategories = productCategoriesListModelFromJson(jsonEncode(apiResponse['result']));
        packageProductCategory = listPackageCategories[0];
        isPackageCategoryExists = true;
        await _getPackagedProducts();
        update();
      }
    } else {
      BotToast.showText(text: apiResponse['message']);
    }
  }

  _getPackagedProducts() async {
    Map<String, dynamic> apiResponse = await RemoteService().get(
        context: context,
        endpoint: "${Api.apiListProductsByCategoryId}/${hiveBox.get(AppStorageKeys.selectedCountryId)}/${packageProductCategory.id}");
    if (apiResponse.isNotEmpty && apiResponse['status']) {
      listPackagedProducts = productListModelFromJson(jsonEncode(apiResponse['result']));
      update();
    } else {
      BotToast.showText(text: apiResponse['message']);
    }
  }

  String? validator(BuildContext context, String? value) {
    if (value != null) {
      if (value.isEmpty) {
        return "textFieldEmptyError".tr;
      }
    }
    return null;
  }

  searchFieldOnChanged(String text) {
    debugPrint("=> $text");
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

  onSearchBarTapped() {
    Get.to(() => const SearchProductsPage(
          autoFocus: true,
          cameFromSearch: false,
        ));
  }

  onCategoryTapped({required int categoryId, required String category}) {
    Get.to(
      () => SearchProductsPage(
        categoryId: categoryId,
        category: category,
        autoFocus: false,
        cameFromSearch: false,
      ),
    );
  }

  openFeaturedProducts() => Get.to(() => const SearchProductsPage(cameFromSearch: true, isFeatured: true));

  openNewArrivalProducts() => Get.to(() => const SearchProductsPage(cameFromSearch: true, isNewArrival: true));

  onLoginButtonClicked() => Get.to(() => const WelcomePage());
}
