import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_store/constants/app_enums.dart';
import 'package:shopping_store/constants/app_sizes.dart';
import 'package:shopping_store/constants/app_storage_keys.dart';
import 'package:shopping_store/controllers/language/language_controller.dart';
import 'package:shopping_store/controllers/profile/profile_edit_controller.dart';
import 'package:shopping_store/main.dart';
import 'package:shopping_store/models/user_details_model.dart';
import 'package:shopping_store/services/api.dart';
import 'package:shopping_store/services/remote_service.dart';
import 'package:shopping_store/views/pages/auth/login_page.dart';
import 'package:shopping_store/views/pages/auth/welcome_page.dart';
import 'package:shopping_store/views/pages/bottom_navigation/bottom_navigation_page.dart';
import 'package:shopping_store/views/pages/customer_address/customer_address_list_page.dart';
import 'package:shopping_store/views/pages/orders/orders_list_page.dart';
import 'package:shopping_store/views/pages/profile/profile_edit_page.dart';
import 'package:shopping_store/views/pages/select_country/select_country_page.dart';
import 'package:popup_menu_plus/popup_menu_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileController extends GetxController {
  final BuildContext context;
  late PopupMenu popupMenu;
  late UserDetailsModel userDetails;
  bool isUserDetailsInit = false;
  GlobalKey languageChangeButtonKey = GlobalKey();

  ProfileController(
    this.context,
  );

  @override
  void onInit() {
    _getUserDetails();
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  onFlagClicked() async {
    Get.to(
      () => const SelectCountryPage(
        isFromAppBar: true,
      ),
    );
  }

  openLanguageMenu({required Size size}) async {
    popupMenu.show(widgetKey: languageChangeButtonKey);
  }

  onMenuItemClicked(PopUpMenuItemProvider item) {
    onLanguageClick(language: item.menuTitle);
  }

  onDismiss() {}

  onLanguageClick({required String language}) async {
    await hiveBox.put(AppStorageKeys.selectedLocale, language == 'English' ? enumAppLanguage.english.index : enumAppLanguage.arabic.index);
    await hiveBox.put(AppStorageKeys.selectedDefaultLanguage, language == 'English' ? "english" : "arabic");

    //update app language
    LanguageController().changeLanguage(
      languageCode: language == 'English' ? 'en' : 'ar',
      countryCode: language == 'English' ? 'US' : 'AE',
    );
    update();
  }

  _getUserDetails() async {
    Map<String, dynamic> apiResponse = await RemoteService().get(
      context: context,
      endpoint: Api.apiUserDetails,
      willLoad: false,
    );
    if (apiResponse.isNotEmpty && apiResponse['status']) {
      userDetails = userDetailsModelFromJson(jsonEncode(apiResponse['result']));
      isUserDetailsInit = true;
      update();
    } else {
      BotToast.showText(text: apiResponse['message']);
    }
  }

  String getProfilePictureUrl(String suffixUrl) {
    return "${Api.fileBaseUrl}/${suffixUrl.replaceAll('"', '')}";
  }

  onEditTapped() async {
    Get.to(
      () => ProfileEditPage(
        userDetails: userDetails,
      ),
    )!
        .then((value) {
      _getUserDetails();
    });
  }

  openSavedAddresses() => Get.to(() => const CustomerAddressListPage());

  openOrdersListPage() => Get.to(() => const OrdersListPage());

  openLoginPage() => Get.to(() => const WelcomePage());

  onHelpCenter() async {
    // var messengerUrl = "http://m.me/${AppAssets.fbMessengerUsername}";
    // var whatsAppUrl = "whatsapp://send?phone=${hiveBox.get(AppStorageKeys.selectedCountryPhoneNumber, defaultValue: "+971526330035")}";
    var whatsAppUrl = "https://wa.me/${hiveBox.get(AppStorageKeys.selectedCountryPhoneNumber)}";
    if (!await launchUrl(Uri.parse(whatsAppUrl))) {
      BotToast.showText(text: "chatError".tr);
    }
  }
}
