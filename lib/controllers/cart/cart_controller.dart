import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_store/constants/app_enums.dart';
import 'package:shopping_store/constants/app_storage_keys.dart';
import 'package:shopping_store/main.dart';
import 'package:shopping_store/models/cart_item_model.dart';
import 'package:shopping_store/models/coupon_model.dart';
import 'package:shopping_store/models/tax_model.dart';
import 'package:shopping_store/services/api.dart';
import 'package:shopping_store/services/remote_service.dart';
import 'package:shopping_store/views/pages/auth/login_page.dart';
import 'package:shopping_store/views/pages/billing/billing_page.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';

class CartController extends GetxController {
  final BuildContext context;
  bool isLoaderEnabled = true;
  List<CartItemModel> listCartItems = [];
  bool isBottomExpanded = false;
  bool isBottomExpandedCompletely = false;
  double itemTotal = 0;
  double taxPercent = 0;
  double taxValue = 0;
  // double discountPercent = 0;
  // double discountValue = 0;
  double shippingFee = 0;
  double totalCartValue = 0;
  double totalCartWeight = 0;
  final visibilityKey = const Key('MainList');
  late TaxModel taxModel;
  bool isTaxAvailable = false;

  //monthly coupon
  late CouponModel monthlyDiscountCoupon;
  bool isMonthlyDiscountAvailable = false;
  double monthlyDiscountPercent = 0;
  double monthlyDiscountValue = 0;

  //auto discount coupon
  late CouponModel autoDiscountCoupon;
  bool isAutoDiscountAvailable = false;
  double autoDiscountPercent = 0;
  double autoDiscountValue = 0;

  //user coupon
  late CouponModel userCoupon;
  bool isUserCouponAvailable = false;
  double userCouponPercent = 0;
  double userCouponValue = 0;

  //total discount
  double totalDiscountPercent = 0;
  double totalDiscountValue = 0;

  bool isCouponVisible = false;
  late CouponModel latestCoupon;
  int selectedCouponIndex = 0;
  bool isCouponApplied = false;
  bool isShippingAddressSelected = false;
  int couponId = 0;
  bool isAddingToCart = false;
  bool isRemovingFromCart = false;

  CartController(this.context);

  @override
  void onInit() {
    getMonthlyDiscountCoupons();
    getAutoDiscountCoupons();
    getTaxByCountryId();
    getCartList();
    super.onInit();
  }

  goBack() => Get.back();

  onAnimationCompleted() {
    isBottomExpandedCompletely = !isBottomExpandedCompletely;
    update();
  }

  clickOnLogin() => Get.to(() => const LoginPage());

  getCartList() async {
    Map<String, dynamic> apiResponse = await RemoteService().get(
      context: context,
      endpoint: Api.apiListCart,
      willLoad: isLoaderEnabled,
    );
    if (apiResponse.isNotEmpty && apiResponse['status']) {
      listCartItems = cartItemModelFromJson(jsonEncode(apiResponse['result']));
      calculateCartValues(listCartItems);
      isLoaderEnabled = false;
      update();
    } else {
      BotToast.showText(text: apiResponse['message']);
    }
  }

  addToCart({required int productId}) async {
    if (!isAddingToCart) {
      isAddingToCart = true;
      update();

      var payload = jsonEncode(<String, dynamic>{
        "productId": productId,
        "countryId": hiveBox.get(AppStorageKeys.selectedCountryId, defaultValue: 1),
      });

      Map<String, dynamic> apiResponse = await RemoteService().post(
        context: context,
        endpoint: Api.apiAddCart,
        payloadObj: payload,
        willLoad: false,
      );

      if (apiResponse.isNotEmpty && apiResponse['status']) {
        await getCartList();
        isAddingToCart = false;
        update();
      } else {
        isAddingToCart = false;
        update();
        BotToast.showText(text: apiResponse['message']);
      }
    }
  }

  deleteFromCart({required int productId}) async {
    if (!isRemovingFromCart) {
      isRemovingFromCart = true;
      update();

      var payload = jsonEncode(<String, dynamic>{
        "productId": productId,
        "countryId": hiveBox.get(AppStorageKeys.selectedCountryId, defaultValue: 1),
      });

      Map<String, dynamic> apiResponse = await RemoteService().post(
        context: context,
        endpoint: Api.apiDeleteCart,
        payloadObj: payload,
        willLoad: false,
      );

      if (apiResponse.isNotEmpty && apiResponse['status']) {
        await getCartList();
        isRemovingFromCart = false;
        update();
      } else {
        isRemovingFromCart = false;
        update();
        BotToast.showText(text: apiResponse['message']);
      }
    }
  }

  toggleBottom() {
    isBottomExpanded = !isBottomExpanded;
    update();
  }

  calculateCartValues(List<CartItemModel> listCart) {
    //set values ot default
    itemTotal = 0;
    totalCartWeight = 0;
    totalDiscountPercent = 0;

    //calculating cart item total
    for (var cartItem in listCart) {
      itemTotal = itemTotal + cartItem.productId.price * cartItem.itemCount;
      totalCartWeight = totalCartWeight + cartItem.productId.weight * cartItem.itemCount;
    }

    //calculate all discounts here (always calculate discounts before application of tax)
    //apply monthly discount if available
    if (isMonthlyDiscountAvailable) {
      totalDiscountPercent = totalDiscountPercent + monthlyDiscountCoupon.couponPercent;
    }

    //apply auto discount if available
    if (isAutoDiscountAvailable) {
      if (itemTotal >= autoDiscountCoupon.minCartValue) {
        totalDiscountPercent = totalDiscountPercent + autoDiscountCoupon.couponPercent;
      }
    }

    //apply user coupon discount if available
    if (isUserCouponAvailable) {
      totalDiscountPercent = totalDiscountPercent + userCoupon.couponPercent;
    }

    //apply discount on item total
    totalDiscountValue = itemTotal * totalDiscountPercent / 100;

    //calculate tax on total items
    if (isTaxAvailable) {
      taxPercent = taxModel.taxValue;
      taxValue = (itemTotal - totalDiscountValue) * taxPercent / 100;
    }

    //calculate total cart value
    totalCartValue = (itemTotal - totalDiscountValue) + taxValue + shippingFee;
    update();
  }

  onCheckoutTapped() {
    toggleBottom();
    Get.to(
      () => BillingPage(
        itemTotal: itemTotal,
        taxValue: taxValue,
        taxPercent: taxPercent,
        discountValue: totalDiscountValue,
        discountPercent: totalDiscountPercent,
        totalCartValue: totalCartValue,
        totalCartWeight: totalCartWeight,
        cartItems: jsonDecode(cartItemModelToJson(listCartItems)),
        taxId: taxModel.id,
        couponId: couponId,
        countryId: hiveBox.get(AppStorageKeys.selectedCountryId),
      ),
    );
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

  onVisibilityChange(VisibilityInfo visibilityInfo) {
    getCartList();
  }

  getTaxByCountryId() async {
    Map<String, dynamic> apiResponse = await RemoteService().get(
      context: context,
      endpoint: "${Api.apiTaxDetailsByCountryId}/${hiveBox.get(AppStorageKeys.selectedCountryId)}",
      willLoad: false,
    );

    if (apiResponse.isNotEmpty && apiResponse['status']) {
      taxModel = taxModelFromJson(jsonEncode(apiResponse['result']));
      isTaxAvailable = true;
      update();
    }
  }

  Future<bool> getMonthlyDiscountCoupons() async {
    List<CouponModel> listCoupons = [];
    List<CouponModel> activeCouponList = [];
    Map<String, dynamic> apiResponse = await RemoteService().get(
      context: context,
      endpoint: "${Api.apiListCoupons}/${hiveBox.get(AppStorageKeys.selectedCountryId)}?couponType=${EnumCouponType.monthlyDiscount.index}",
      willLoad: false,
    );
    if (apiResponse.isNotEmpty && apiResponse['status']) {
      listCoupons = couponModelFromJson(jsonEncode(apiResponse['result']));

      if (listCoupons.isNotEmpty) {
        //get active coupons
        for (CouponModel coupon in listCoupons) {
          if (!isCouponExpired(coupon.expiryDate)) {
            activeCouponList.add(coupon);
          }
        }
        listCoupons = activeCouponList;
        if (listCoupons.isNotEmpty) {
          monthlyDiscountCoupon = listCoupons[0];
          isMonthlyDiscountAvailable = true;
        }
      }
      update();
      return true;
    } else {
      BotToast.showText(text: apiResponse['message']);
      return false;
    }
  }

  Future<bool> getAutoDiscountCoupons() async {
    List<CouponModel> listCoupons = [];
    List<CouponModel> activeCouponList = [];
    Map<String, dynamic> apiResponse = await RemoteService().get(
      context: context,
      endpoint: "${Api.apiListCoupons}/${hiveBox.get(AppStorageKeys.selectedCountryId)}?couponType=${EnumCouponType.autoDiscount.index}",
      willLoad: false,
    );
    if (apiResponse.isNotEmpty && apiResponse['status']) {
      listCoupons = couponModelFromJson(jsonEncode(apiResponse['result']));

      if (listCoupons.isNotEmpty) {
        //get active coupons
        for (CouponModel coupon in listCoupons) {
          if (!isCouponExpired(coupon.expiryDate)) {
            activeCouponList.add(coupon);
          }
        }
        listCoupons = activeCouponList;
        if (listCoupons.isNotEmpty) {
          autoDiscountCoupon = listCoupons[0];
          isAutoDiscountAvailable = true;
        }
      }
      update();
      return true;
    } else {
      BotToast.showText(text: apiResponse['message']);
      return false;
    }
  }

  bool isCouponExpired(DateTime dateTime) => dateTime.isBefore(DateTime.now());

  removeCoupon() {
    isUserCouponAvailable = false;
    isCouponApplied = false;
    getCartList();
    update();
  }

  String? validator(String? value) {
    if (value != null) {
      if (value.isEmpty) {
        return "textFieldEmptyError".tr;
      }
    }
    return null;
  }

  openCouponDialog() async {
    final code = await showTextInputDialog(
      context: context,
      title: "enterCouponCode".tr,
      okLabel: "apply".tr,
      cancelLabel: "cancel".tr,
      barrierDismissible: false,
      style: AdaptiveStyle.adaptive,
      fullyCapitalizedForMaterial: false,
      textFields: [
        DialogTextField(
          hintText: "couponCode".tr,
          validator: validator,
          autocorrect: false,
          // initialText: "ilvYrJhQ",
        ),
      ],
    );

    if (code != null) {
      if (code.isNotEmpty) {
        getCouponDetailsFromCode(code[0]);
      }
    }
  }

  getCouponDetailsFromCode(String couponCode) async {
    Map<String, dynamic> apiResponse = await RemoteService().get(
      context: context,
      endpoint: "${Api.apiCouponDetailsByCouponCode}/$couponCode",
      willLoad: false,
    );

    if (apiResponse.isNotEmpty && apiResponse['status']) {
      userCoupon = singleCouponModelFromJson(jsonEncode(apiResponse['result']));
      isUserCouponAvailable = true;
      isCouponApplied = true;
      calculateCartValues(listCartItems);
      update();
      return true;
    } else {
      BotToast.showText(text: apiResponse['message']);
      return false;
    }
  }
}
