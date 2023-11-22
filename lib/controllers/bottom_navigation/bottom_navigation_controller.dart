import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:get/get.dart';
import 'package:shopping_store/constants/app_storage_keys.dart';
import 'package:shopping_store/main.dart';
import 'package:shopping_store/models/user_details_model.dart';
import 'package:shopping_store/services/api.dart';
import 'package:shopping_store/services/remote_service.dart';
import 'package:shopping_store/views/pages/cart/cart_page.dart';
import 'package:shopping_store/views/pages/profile/profile_page.dart';
import 'package:shopping_store/views/pages/shop/shop_page.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../views/pages/home/home_page.dart';

class BottomNavigationController extends GetxController {
  final BuildContext context;
  int selectedTab;
  late PageController pageController;
  late ExpandedTileController expandedTileController;
  List<Widget> listPages = [];
  List<String> listAppBarTitle = ["home".tr, "shop".tr, "cart".tr, "myshopping".tr];
  bool isAppBarVisible = true;

  BottomNavigationController(this.context, this.selectedTab);

  @override
  void onInit() {
    expandedTileController = ExpandedTileController(isExpanded: false);
    pageController = PageController(initialPage: selectedTab);
    listPages = [
      const HomePage(),
      const ShopPage(),
      const CartPage(),
      const ProfilePage(),
    ];
    super.onInit();
  }

  onItemTap(int itemIndex) async {
    pageController.jumpToPage(itemIndex);
    selectedTab = itemIndex;
    update();
  }

  onPageChanges(int pageIndex) {
    selectedTab = pageIndex;
    isAppBarVisible = pageIndex == 3
        ? false
        : pageIndex == 1
            ? false
            : true;
    update();
  }

  onFloatingButtonTap() async {
    // var messengerUrl = "http://m.me/${AppAssets.fbMessengerUsername}";
    // var whatsAppUrl = "whatsapp://send?phone=${hiveBox.get(AppStorageKeys.selectedCountryPhoneNumber, defaultValue: "+971526330035")}";
    var whatsAppUrl = "https://wa.me/${hiveBox.get(AppStorageKeys.selectedCountryPhoneNumber)}";
    if (!await launchUrl(Uri.parse(whatsAppUrl))) {
      BotToast.showText(text: "chatError".tr);
    }
  }
}
