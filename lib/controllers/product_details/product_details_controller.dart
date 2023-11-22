import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_store/constants/app_enums.dart';
import 'package:shopping_store/constants/app_storage_keys.dart';
import 'package:shopping_store/main.dart';
import 'package:shopping_store/models/coupon_model.dart';
import 'package:shopping_store/models/product_list_model.dart';
import 'package:shopping_store/services/api.dart';
import 'package:shopping_store/services/remote_service.dart';
import 'package:shopping_store/views/pages/bottom_navigation/bottom_navigation_page.dart';
import 'package:shopping_store/views/pages/search_products/search_products_page.dart';
import 'package:shopping_store/views/widgets/image_view_widget.dart';
import 'package:chewie/chewie.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class ProductDetailsController extends GetxController {
  final BuildContext context;
  final String videoUrl;
  final ProductListModel productDetails;
  TextEditingController searchTextEditingController = TextEditingController();
  late VideoPlayerController videoPlayerController;
  late ChewieController chewieController;
  bool isMediaActive = true;
  bool isCartButtonEnabled = true;
  List<CouponModel> listCoupons = [];
  bool isCouponVisible = false;
  late CouponModel latestCoupon;
  int selectedCouponIndex = 0;
  late PageController pageController;

  ProductDetailsController({
    required this.context,
    this.videoUrl = "",
    required this.productDetails,
  });

  @override
  void onInit() {
    pageController = PageController(initialPage: selectedCouponIndex);

    if (videoUrl != "") {
      videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(
          "${Api.fileBaseUrl}/$videoUrl",
        ),
      );

      chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        autoPlay: false,
        looping: false,
        showControlsOnInitialize: true,
        overlay: Container(
          color: Colors.transparent,
        ),
      );
      chewieController.setVolume(0.0);
    }
    _getCoupons();
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

  searchFieldOnChanged(String text) {
    debugPrint("=> $text");
  }

  goBack() async {
    Get.back();
  }

  bool isImage(String url) {
    List<String> splitedPath = url.split(".");
    String ext = splitedPath[splitedPath.length - 1];
    List<String> listImageExt = ['jpg', 'jpeg', 'png'];
    return listImageExt.contains(ext);
  }

  List<String> removeVideoUrl(List<String> arRMedia) {
    List<String> newList = [];
    for (String url in arRMedia) {
      if (isImage(url)) {
        newList.add(url);
      }
    }
    return newList;
  }

  onSearchBarTapped() {
    Get.to(() => const SearchProductsPage(
          cameFromSearch: false,
        ));
  }

  onPhotoTap(String imageUrl, List<String> arrMedia) {
    Get.to(
      () => ImageViewWidget(
        imageUrl: imageUrl,
        arrMedia: arrMedia,
      ),
    );
  }

  onChatButtonTapped() async {
    // var messengerUrl = "http://m.me/${AppAssets.fbMessengerUsername}";
    // var whatsAppUrl = "whatsapp://send?phone=${hiveBox.get(AppStorageKeys.selectedCountryPhoneNumber, defaultValue: "+971526330035")}";
    var whatsAppUrl = "https://wa.me/${hiveBox.get(AppStorageKeys.selectedCountryPhoneNumber)}";
    if (!await launchUrl(Uri.parse(whatsAppUrl))) {
      BotToast.showText(text: "chatError".tr);
    }
  }

  onStoreIconTapped() {
    Get.offAll(() => const BottomNavigationPage(selectedTab: 1));
  }

  onMediaButtonClick() {
    isMediaActive = true;
    update();
  }

  onHighlightButtonClick() {
    isMediaActive = false;
    update();
  }

  addToCart() async {
    if (isCartButtonEnabled) {
      isCartButtonEnabled = false;
      update();
      var payload = jsonEncode(<String, dynamic>{
        "productId": productDetails.id,
        "countryId": hiveBox.get(AppStorageKeys.selectedCountryId, defaultValue: 1),
      });

      Map<String, dynamic> apiResponse = await RemoteService().post(
        context: context,
        endpoint: Api.apiAddCart,
        payloadObj: payload,
      );

      if (apiResponse.isNotEmpty && apiResponse['status']) {
        BotToast.showText(text: apiResponse['message']);
        update();
      } else {
        isCartButtonEnabled = true;
        update();
        BotToast.showText(text: apiResponse['message']);
      }
    } else {
      Get.offAll(
        () => const BottomNavigationPage(
          selectedTab: 2,
        ),
      );
    }
  }

  _getCoupons() async {
    List<CouponModel> activeCouponList = [];
    Map<String, dynamic> apiResponse = await RemoteService().get(
        context: context,
        endpoint: "${Api.apiListCoupons}/${hiveBox.get(AppStorageKeys.selectedCountryId)}?couponType=${EnumCouponType.monthlyDiscount.index}");
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
      }

      if (activeCouponList.isNotEmpty) {
        latestCoupon = activeCouponList[0];
        isCouponVisible = true;
      }
      update();
    } else {
      BotToast.showText(text: apiResponse['message']);
    }
  }

  bool isCouponExpired(DateTime dateTime) => dateTime.isBefore(DateTime.now());

  onPageChanges(int index) {
    selectedCouponIndex = index;
    update();
  }

  onIndicatorClicked(int index) {
    pageController.jumpToPage(index);
    selectedCouponIndex = index;
    update();
  }
}
